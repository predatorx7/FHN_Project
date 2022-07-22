import 'package:riverpod/riverpod.dart';
import 'package:shopping/src/data/data.dart';
import 'package:shopping/src/utils/logging/logging.dart';

// Keeping the state as an [Iterable] instead of a [List] to disallow consumers accessing .add, and other methods for
// modifying the list because the state must be immutable and the list is unmmodifiable (modifications will throw).
class ShoppingCartController extends StateNotifier<Iterable<SampleItem>> {
  ShoppingCartController() : super(const []);

  final logger = logging('ShoppingCartController');

  void operator +(SampleItem other) {
    validateItem(other);

    final values = state;

    state = List.unmodifiable([...values, other]);
  }

  void removeLastOf(SampleItem item) {
    validateItem(item);

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
    validateItem(other);
    // Creating a new list without the item matching [other]'s id because state is unmodifiable.

    final values = state;
    assert(
      values.isNotEmpty,
      'Attempted to remove items when cart was already empty',
    );

    final newValues = <SampleItem>[];
    for (var i = 0; i < values.length; i++) {
      final it = values.elementAt(i);
      if (it.id != other.id) {
        newValues.add(it);
      }
    }

    state = List.unmodifiable(newValues);
  }

  void validateItem(SampleItem it) {
    if (it.id == null) {
      throw ArgumentError.value(
        it,
        'Attempted to use item with null id',
        'id',
      );
    }
  }
}
