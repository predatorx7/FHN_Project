import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magnific_ui/magnific_ui.dart';
import 'package:shopping/src/data/data.dart';
import 'package:shopping/src/di/json.dart';
import 'package:shopping/src/di/shopping.dart';
import 'package:shopping/src/ui/components/error.dart';
import 'package:transparent_image/transparent_image.dart';

import '../components/cart_icon.dart';
import '../components/loading.dart';

class BrowsingScreen extends ConsumerWidget {
  const BrowsingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paginationController = ref.read(
      itemsPaginationControllerProvider.notifier,
    );

    return Scaffold(
      appBar: AppBar(
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
                if (values.isNotEmpty) SliverItemsGrid(values: values),
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

class SliverItemsGrid extends StatelessWidget {
  const SliverItemsGrid({
    Key? key,
    required this.values,
  }) : super(key: key);

  final Iterable<SamplePhoto> values;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180,
        childAspectRatio: 1,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = values.elementAt(index);

          return ItemTile(item: item);
        },
        childCount: values.length,
      ),
    );
  }
}

class ItemTile extends ConsumerWidget {
  const ItemTile({
    Key? key,
    required this.item,
  }) : super(key: key);

  final SamplePhoto item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridTile(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: item.thumbnailUrl ?? item.url ?? '',
              fit: BoxFit.fill,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: AddToCartIconButton(
              item: item,
            ),
          ),
        ],
      ),
    );
  }
}

class AddToCartIconButton extends ConsumerWidget {
  const AddToCartIconButton({
    Key? key,
    required this.item,
  }) : super(key: key);

  final SamplePhoto item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isItemInCart = ref.watch(isItemInCartProviderFamily(item));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
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
      ),
    );
  }
}
