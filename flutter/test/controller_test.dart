import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopping/src/data/data.dart';
import 'package:shopping/src/modules/cart.dart';

void main() {
  group('Cart controller', () {
    late ShoppingCartController controller;
    late Iterable<SampleItem>? latestState;
    late VoidCallback removeListener;

    setUp(() {
      controller = ShoppingCartController();
      removeListener = controller.addListener((state) {
        latestState = state;
      });
    });

    test('addition of item in the cart', () {
      final a = getRandomSampleItem();

      expect(
        () {
          controller + a;
        },
        returnsNormally,
        reason: 'Addition should not throw',
      );

      expect(
        latestState,
        contains(a),
        reason: 'Cart should contain the added item',
      );

      expect(
        latestState,
        hasLength(1),
        reason: 'Cart should contain only one item',
      );

      expect(
        latestState!.first,
        same(a),
        reason: 'Cart should contain only one item',
      );
    });

    test('addition of multiple different items in the cart', () {
      final items = getRandomSampleItems();
      final itemCount = items.length;

      for (var i in items) {
        controller + i;
      }

      expect(
        latestState,
        hasLength(itemCount),
        reason: 'Cart should contain exact amount of items that were added',
      );
    });

    test('addition of multiple same items in the cart', () {
      final a = getRandomSampleItem();
      final items = getSampleNTimes(a);
      final itemCount = items.length;

      for (var i in items) {
        controller + i;
      }

      expect(
        latestState,
        hasLength(itemCount),
        reason:
            'Cart should contain exact amount of items that were added, even if they are the same',
      );

      expect(
        latestState,
        contains(a),
      );

      expect(
        latestState,
        everyElement(a),
        reason: 'All items in the cart should be the `a`',
      );
    });

    test('removal of item in the cart', () {
      final a = getRandomSampleItem();

      controller + a;

      // ensuring that the item is in the cart
      expect(
        latestState,
        contains(a),
        reason: 'Cart should contain the added item',
      );

      expect(
        latestState,
        isNotEmpty,
        reason: 'Cart should not be empty',
      );
      // ensured item is in cart

      expect(() {
        controller - a;
      }, returnsNormally, reason: 'Removal should not throw');

      expect(
        latestState,
        isNot(contains(a)),
        reason: 'Cart should not contain the added item',
      );

      expect(latestState, isEmpty);
    });

    test('removal of item in the cart when it has no items', () {
      final a = getRandomSampleItem();

      // ensuring that the item is in the cart
      expect(
        () {
          controller - a;
        },
        throwsAssertionError,
        reason: 'Removal should throw assertion when cart is empty',
      );

      expect(latestState, isEmpty);
    });

    test('removal of multiple same items in the cart', () {
      final a = getRandomSampleItem();

      final items = getSampleNTimes(a);
      final itemCount = items.length;

      for (var i in items) {
        controller + i;
      }

      // ensuring that the items are in the cart
      expect(
        latestState,
        hasLength(itemCount),
        reason:
            'Cart should contain exact amount of items that were added, even if they are the same',
      );

      expect(
        latestState,
        everyElement(a),
        reason: 'All items in the cart should be the `a`',
      );
      // ensured same items are in cart

      final b = getRandomSampleItem();
      // Add other element
      controller + b;

      expect(() {
        controller - a;
      }, returnsNormally, reason: 'Removal should not throw');

      expect(
        latestState,
        hasLength(1),
        reason:
            'Removal of a type of item should remove all of items that matches the id',
      );

      expect(
        latestState,
        everyElement(b),
        reason:
            'Removal of a type of item should remove all of them which matches the id. Only other elements must be left.',
      );
    });

    test('removal of last item when cart has multiple same items', () {
      final a = getRandomSampleItem();

      final items = getSampleNTimes(a);
      final itemCount = items.length;

      for (var i in items) {
        controller + i;
      }

      // ensuring that the items are in the cart
      expect(
        latestState,
        hasLength(itemCount),
        reason:
            'Cart should contain exact amount of items that were added, even if they are the same',
      );

      expect(
        latestState,
        everyElement(a),
        reason: 'All items in the cart should be the `a`',
      );
      // ensured same items are in cart

      expect(() {
        controller.removeLastOf(a);
      }, returnsNormally, reason: 'Removal should not throw');

      expect(
        latestState,
        hasLength(itemCount - 1),
        reason:
            'Removal of a type of item using `removeLastOf` should only remove the last item that matches the id',
      );
    });

    test('addition or removal of invalid item in the cart', () {
      final a = getRandomSampleItem();
      // to avoid assertion on removal when empty
      controller + a;

      final b = getSampleItemWithoutId();

      expect(
        () {
          controller - b;
        },
        throwsArgumentError,
        reason:
            'Removal of item which does not have an id should throw argument error',
      );

      expect(
        () {
          controller + b;
        },
        throwsArgumentError,
        reason:
            'Addition of item which does not have an id should throw argument error',
      );

      expect(
        () {
          controller.removeLastOf(b);
        },
        throwsArgumentError,
        reason:
            'Removing last item which does not have an id should throw argument error',
      );
    });

    test('immutability of controller\'s state', () {
      // controller would have no items.

      final a = getRandomSampleItem();

      // state when controller state has no items
      var oldState1 = latestState;
      controller + a;

      // controller would have 1 item matching [a]'s id.
      expect(oldState1, isNot(same(latestState)));

      var oldState2 = latestState;
      controller + a;

      // controller would have 2 items matching [a]'s id.
      expect(oldState2, isNot(same(latestState)));
      expect(oldState2, isNot(same(oldState1)));

      var oldState3 = latestState;
      controller - a;

      // controller would have no items matching [a]'s id.
      expect(oldState3, isNot(same(latestState)));
      expect(oldState3, isNot(same(oldState2)));
      expect(oldState3, isNot(same(oldState1)));
    });

    tearDown(() {
      removeListener();
      controller.dispose();
    });
  });
}

SampleItem getSampleItemWithoutId() {
  final rand = Random();

  final id = rand.nextInt(100);
  return SampleItem(
    (rand.nextDouble() * 200.0) + 50.0,
    rand.nextInt(100),
    null,
    'Sample $id',
    '',
    '',
  );
}

SampleItem getRandomSampleItem() {
  final rand = Random();

  final id = rand.nextInt(100);
  return SampleItem(
    (rand.nextDouble() * 200.0) + 50.0,
    rand.nextInt(100),
    id,
    'Sample $id',
    '',
    '',
  );
}

Iterable<SampleItem> getSampleNTimes(SampleItem item, [int? count]) {
  final total = count ?? Random().nextInt(100) + 5;

  return [for (var i = 0; i < total; i++) item];
}

Iterable<SampleItem> getRandomSampleItems([int? count]) {
  final total = count ?? Random().nextInt(100) + 5;

  return [for (var i = 0; i < total; i++) getRandomSampleItem()];
}
