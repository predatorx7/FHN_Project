import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:magnific_ui/magnific_ui.dart';
import 'package:shopping/l10n/l10n.dart';
import 'package:single_async_widget/single_async_widget.dart';

import '../../data/data.dart';
import '../../di/shopping.dart';
import '../components/cart_item.dart';
import 'home.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  static const String routeName = '/checkout';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.shoppingCart),
      ),
      body: const CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(),
          ),
          SliverCheckoutHeader(),
          SliverCartItemList(),
        ],
      ),
    );
  }
}

class SliverCartItemList extends ConsumerWidget {
  const SliverCartItemList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uniqueCartItems = ref.watch(shoppingCartUniqueItemsProvider);

    if (uniqueCartItems.isEmpty) {
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
                FluentIcons.shopping_bag_24_filled,
                size: 100,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    context.l10n.cartEmpty,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4.0,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = uniqueCartItems.elementAt(index);
            return CartItem(
              item: item,
            );
          },
          childCount: uniqueCartItems.length,
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  const CartItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final SampleItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: SampleItemPicture(
                    item: item,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 8.0,
                    ),
                    child: ItemTileBar(
                      item: item,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ItemQuantity(
                item: item,
              ),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}

class ItemQuantity extends ConsumerWidget {
  const ItemQuantity({
    Key? key,
    required this.item,
  }) : super(key: key);

  final SampleItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemCount = ref.watch(sameShoppingCartItemCountProvider(item));

    const _kMinButtonSize = 30.0;

    const buttonConstraints = BoxConstraints(
      minWidth: _kMinButtonSize,
      minHeight: _kMinButtonSize,
    );

    return Material(
      color: Colors.grey.shade300,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              final ctrl = ref.read(shoppingCartControllerProvider.notifier);
              if (itemCount <= 1) {
                ctrl - item;
              } else {
                ctrl.removeLastOf(item);
              }
            },
            constraints: buttonConstraints,
            icon: itemCount <= 1
                ? const Icon(Icons.delete_outlined)
                : const Icon(Icons.remove_rounded),
          ),
          SizedBox(
            width: 70,
            child: Center(
              child: Text(
                itemCount.toString(),
                style: Theme.of(context).textTheme.button,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              final ctrl = ref.read(shoppingCartControllerProvider.notifier);
              ctrl + item;
            },
            constraints: buttonConstraints,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}

class SliverCheckoutHeader extends StatelessWidget {
  const SliverCheckoutHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Material(
        color: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.surfaceTint,
        elevation: 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            SubTotalText(),
            ProceedPurchaseButton(),
            SizedBox(
              height: 8.0,
            ),
          ],
        ),
      ),
    );
  }
}

class ProceedPurchaseButton extends ConsumerWidget {
  const ProceedPurchaseButton({Key? key}) : super(key: key);

  Future<void> onPurchase(WidgetRef ref, BuildContext context) async {
    final sm = ScaffoldMessenger.of(context);
    await Future.delayed(const Duration(seconds: 1));

    sm.showSnackBar(
      const SnackBar(
        content: Text('successful payment'),
      ),
    );

    ref.refresh(shoppingCartControllerProvider);
  }

  void onExplore(BuildContext context) {
    context.go(HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cartContentLength = ref.watch(cartItemLengthProvider);
    final canProceed = cartContentLength > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: SingleAsyncScope(
        builder: (action, _) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: theme.colorScheme.primary,
              onPrimary: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 12.0,
              ),
            ),
            onPressed: canProceed
                ? action.createCallback(() => onPurchase(ref, context))
                : () => onExplore(context),
            child: action.isProcessing
                ? const MiniCircularProgressIndicator()
                : Text(
                    canProceed
                        ? '${context.l10n.proceedToBuy} (${context.l10n.nItems(cartContentLength)})'
                        : context.l10n.explore,
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
          );
        },
      ),
    );
  }
}

class SubTotalText extends ConsumerWidget {
  const SubTotalText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtotal = ref.watch(cartItemSubtotalProvider);
    final cartContentLength = ref.watch(cartItemLengthProvider);

    final textTheme = Theme.of(context).textTheme;

    final locale = Localizations.localeOf(context);
    final currencyFormat = NumberFormat("#,##0.00", locale.toString());
    final List<Widget> children;
    if (cartContentLength > 0) {
      children = [
        Flexible(
          child: Text(
            context.l10n.subtotal,
            textAlign: TextAlign.start,
            style: textTheme.titleLarge,
          ),
        ),
        const Flexible(
          flex: 0,
          child: SizedBox(width: 8),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                '₹',
                textScaleFactor: 0.5,
                style: textTheme.displaySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            DefaultTextStyle(
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18,
              ),
              child: Text(
                currencyFormat.format(subtotal),
                style: textTheme.displaySmall,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ];
    } else {
      children = [
        const Flexible(
          child: SizedBox(height: 43),
        ),
      ];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}
