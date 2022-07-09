import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shopping/src/data/data.dart';
import 'package:shopping/src/utils/logging/logging.dart';

// TODO: Change state to use [Set]
class ShoppingCartController extends StateNotifier<Iterable<SamplePhoto>> {
  ShoppingCartController() : super(const []);

  final logger = logging('ShoppingCartController');

  void operator +(SamplePhoto other) {
    final values = state;
    if (kDebugMode) {
      for (var i = 0; i < values.length; i++) {
        final it = values.elementAt(i);
        assert(it.id != other.id, 'Cannot add same item twice');
      }
    }

    state = List.unmodifiable([...values, other]);
  }

  void operator -(SamplePhoto other) {
    // Creating a new list without the item matching [other]'s id because state is unmodifiable.

    final newValues = <SamplePhoto>[];
    final values = state;
    for (var i = 0; i < values.length; i++) {
      final it = values.elementAt(i);
      if (it.id != other.id) {
        newValues.add(it);
      }
    }

    state = List.unmodifiable(newValues);
  }
}
