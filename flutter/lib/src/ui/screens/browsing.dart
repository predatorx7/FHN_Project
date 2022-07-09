import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magnific_ui/magnific_ui.dart';
import 'package:shopping/l10n/l10n.dart';
import 'package:shopping/src/data/data.dart';
import 'package:shopping/src/di/json.dart';
import 'package:shopping/src/di/shopping.dart';
import 'package:shopping/src/ui/components/error.dart';

import '../components/cart_icon.dart';
import '../components/loading.dart';
import '../components/cart_item.dart';
import '../components/search.dart';

class BrowsingScreen extends ConsumerWidget {
  const BrowsingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paginationController = ref.read(
      itemsPaginationControllerProvider.notifier,
    );

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        toolbarHeight: kToolbarHeight + 10,
        centerTitle: false,
        titleSpacing: 8,
        title: const BrowsingSearchBar(),
        actions: const [
          CartBadgeIconButton(),
          SizedBox(
            width: 16,
          ),
        ],
      ),
      body: NotificationListener<ScrollUpdateNotification>(
        onNotification: paginationController.onScrollUpdate,
        child: Consumer(
          builder: (context, ref, _) {
            final pagination = ref.watch(itemsPaginationControllerProvider);
            final values = pagination.iterable;
            final valueAsync = pagination.value;

            void onRetry() {
              ref.refresh(itemsPaginationControllerProvider);
            }

            if (valueAsync is AsyncLoading) {
              return const Center(
                child: MiniCircularProgressIndicator(),
              );
            } else if (values == null || values.isEmpty) {
              return ErrorPlaceholder(
                error: valueAsync is AsyncError
                    ? (valueAsync as AsyncError).error
                    : null,
                onRetryPress: onRetry,
              );
            }

            const sliverNothing = SliverToBoxAdapter(child: SizedBox());

            return CustomScrollView(
              slivers: [
                // To avoid a rendering bug which occurs when first item in a custom scroll view changes.
                sliverNothing,
                if (values.isNotEmpty) SliverItemsGrid(data: values),
                if (valueAsync is AsyncData && pagination.nextAvailable)
                  const SliverLoading(),
                if (valueAsync is AsyncError)
                  SliverErrorPlaceholder(
                    error: (valueAsync as AsyncError).error,
                    onRetryPress: onRetry,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class SliverItemsGrid extends ConsumerWidget {
  const SliverItemsGrid({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Iterable<SampleItem> data;

  void onItemSelected(BuildContext context, SampleItem item) {
    //
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onGridTileSelected(SampleItem item) {
      return onItemSelected(context, item);
    }

    final query = ref.watch(browsingSearchQueryProvider);
    final isSearched = query != null;

    final Iterable<SampleItem> values;
    if (isSearched) {
      values = data.where(
        (item) => item.title?.contains(query) == true,
      );
    } else {
      values = data;
    }

    if (values.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                FluentIcons.search_48_filled,
                size: 100,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    isSearched
                        ? context.l10n.noResults
                        : context.l10n.noProducts,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        ref.refresh(shoppingCartControllerProvider);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 21.0),
                        child: Text('Try again'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180,
          childAspectRatio: 0.70,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = values.elementAt(index);

            return ItemTile(
              item: item,
              onItemSelected: onGridTileSelected,
            );
          },
          childCount: values.length,
        ),
      ),
    );
  }
}

class ItemTile extends ConsumerWidget {
  const ItemTile({
    Key? key,
    required this.item,
    this.onItemSelected,
  }) : super(key: key);

  final SampleItem item;
  final ValueChanged<SampleItem>? onItemSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onItemSelected != null ? () => onItemSelected!(item) : null,
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: AspectRatio(
              aspectRatio: 1,
              child: ItemTilePicture(item: item),
            ),
          ),
          ItemTileBar(
            item: item,
          ),
        ],
      ),
    );
  }
}

class ItemTilePicture extends StatelessWidget {
  const ItemTilePicture({
    Key? key,
    required this.item,
  }) : super(key: key);

  final SampleItem item;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: Row(
        children: [
          AddToCartIconButton(
            item: item,
          ),
        ],
      ),
      child: SampleItemPicture(item: item),
    );
  }
}

class AddToCartIconButton extends ConsumerWidget {
  const AddToCartIconButton({
    Key? key,
    required this.item,
  }) : super(key: key);

  final SampleItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isItemInCart = ref.watch(isItemInCartProviderFamily(item));

    return IconButton(
      onPressed: () {
        final ctrl = ref.read(
          shoppingCartControllerProvider.notifier,
        );
        if (isItemInCart) {
          ctrl - item;
        } else {
          ctrl + item;
        }
      },
      icon: PhysicalModel(
        color: Colors.white38,
        shape: BoxShape.circle,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: isItemInCart
              ? const Icon(Icons.shopping_cart_rounded)
              : const Icon(Icons.add_shopping_cart_rounded),
        ),
      ),
      iconSize: 18,
    );
  }
}
