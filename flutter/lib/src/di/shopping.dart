import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping/src/data/data.dart';
import 'package:shopping/src/modules/cart.dart';
import 'package:shopping/src/modules/query.dart';

final shoppingCartControllerProvider =
    StateNotifierProvider<ShoppingCartController, Iterable<SampleItem>>((ref) {
  return ShoppingCartController();
});

final shoppingCartUniqueItemsProvider = Provider((ref) {
  return ref.watch(shoppingCartControllerProvider).toSet();
});

final sameShoppingCartItemCountProvider = Provider.family((
  ref,
  SampleItem item,
) {
  return ref.watch(shoppingCartControllerProvider.select(
    (values) => values.where((it) => it.id == item.id).length,
  ));
});

final cartItemSubtotalProvider = Provider<double>((ref) {
  return ref.watch(shoppingCartControllerProvider.select(
    (value) => value.fold(
      0.0,
      (currentTotal, it) => currentTotal + (it.price ?? 0.0),
    ),
  ));
});

final cartItemLengthProvider = Provider<int>((ref) {
  return ref.watch(shoppingCartControllerProvider.select(
    (value) => value.length,
  ));
});

final uniqueCartItemLengthProvider = Provider<int>((ref) {
  return ref.watch(shoppingCartUniqueItemsProvider.select(
    (value) => value.length,
  ));
});

final isItemInCartProviderFamily = ProviderFamily<bool, SampleItem>(
  (ref, SampleItem arg) {
    return ref.watch(shoppingCartControllerProvider.select(
      (value) {
        // using where and checking its length instead of contains because contains can fail if instance is different and equals is not overriden.
        return value.where((it) => it.id == arg.id).isNotEmpty;
      },
    ));
  },
);

final browsingSearchQueryProvider =
    StateNotifierProvider<SearchQueryProvider, String?>(
  (ref) {
    return SearchQueryProvider();
  },
);
