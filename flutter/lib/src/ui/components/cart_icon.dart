import 'package:badges/badges.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _cartContentLengthProvider = Provider((ref) {
  return 1;
});

class CartBadgeIconButton extends ConsumerWidget {
  const CartBadgeIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartContentLength = ref.read(_cartContentLengthProvider);
    return IconButton(
      onPressed: () {},
      icon: Badge(
        badgeContent: cartContentLength < 1
            ? null
            : Text(
                cartContentLength.toString(),
                style: const TextStyle(color: Colors.white),
              ),
        child: const Icon(
          FluentIcons.shopping_bag_24_regular,
          size: 28,
        ),
      ),
    );
  }
}
