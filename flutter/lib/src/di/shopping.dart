import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping/src/data/data.dart';
import 'package:shopping/src/modules/cart.dart';

final shoppingCartControllerProvider =
    StateNotifierProvider<ShoppingCartController, Iterable<SamplePhoto>>((ref) {
  return ShoppingCartController();
});

final cartItemLengthProvider = Provider<int>((ref) {
  return ref.watch(shoppingCartControllerProvider.select(
    (value) => value.length,
  ));
});

final isItemInCartProviderFamily = ProviderFamily<bool, SamplePhoto>(
  (ref, SamplePhoto arg) {
    return ref.watch(shoppingCartControllerProvider.select(
      (value) {
        // using where and checking its length instead of contains because contains can fail if instance is different and equals is not overriden.
        return value.where((it) => it.id == arg.id).isNotEmpty;
      },
    ));
  },
);
