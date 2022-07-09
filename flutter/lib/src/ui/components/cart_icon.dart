import 'package:badges/badges.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping/src/di/shopping.dart';

class CartBadgeIconButton extends ConsumerWidget {
  const CartBadgeIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartContentLength = ref.watch(cartItemLengthProvider);
    final theme = Theme.of(context);

    return IconButton(
      onPressed: () {},
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
