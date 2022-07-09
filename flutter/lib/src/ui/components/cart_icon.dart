import 'package:badges/badges.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping/src/di/shopping.dart';
import 'package:shopping/src/ui/screens/checkout.dart';

class CartBadgeIconButton extends ConsumerWidget {
  const CartBadgeIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartContentLength = ref.watch(uniqueCartItemLengthProvider);
    final theme = Theme.of(context);

    return IconButton(
      onPressed: () {
        context.pushNamed(CheckoutScreen.routeName);
      },
      icon: Badge(
        badgeContent: Text(
          cartContentLength.toString(),
          style: TextStyle(color: theme.colorScheme.onTertiary),
        ),
        badgeColor: theme.colorScheme.tertiary,
        showBadge: cartContentLength > 0,
        child: const Icon(
          FluentIcons.shopping_bag_24_regular,
          size: 28,
        ),
      ),
    );
  }
}
