import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shopping/src/data/data.dart';
import 'package:shopping/src/utils/logging/logging.dart';

class ShoppingCartController extends StateNotifier<Iterable<SampleItem>> {
  ShoppingCartController() : super(const []);

  final logger = logging('ShoppingCartController');

  void operator +(SampleItem other) {
    final values = state;

    state = List.unmodifiable([...values, other]);
  }

  void removeLastOf(SampleItem item) {
    final newValues = <SampleItem>[];
    final values = state;
    bool hasRemovedOnce = false;

    for (var i = values.length - 1; i >= 0; i--) {
      final it = values.elementAt(i);
      if (hasRemovedOnce || it.id != item.id) {
        newValues.add(it);
      } else {
        hasRemovedOnce = true;
      }
    }

    state = List.unmodifiable(newValues);
  }

  void operator -(SampleItem other) {
    // Creating a new list without the item matching [other]'s id because state is unmodifiable.

    final newValues = <SampleItem>[];
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
