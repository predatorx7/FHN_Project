import 'package:flutter/material.dart';

List<T>? cloneList<T>(Iterable<T>? iterable) {
  if (iterable == null) return null;
  final clonedIterable = <T>[];
  clonedIterable.addAll(iterable);
  return clonedIterable;
}

List<T>? cloneAsUnmodifiableList<T>(Iterable<T>? iterable) {
  if (iterable == null) return null;
  final clonedIterable = cloneList(iterable);
  if (clonedIterable == null) return null;
  return List<T>.unmodifiable(clonedIterable);
}

Matrix4 matrixAtPosition({
  double x = 0,
  double y = 0,
}) {
  const d = 1.0;
  final a = x;
  final b = y;

  return Matrix4(
    d, 0, 0, 0, //
    0, d, 0, 0, //
    0, 0, d, 0, //
    a, b, 0, d, //
  );
}

Matrix4 matrixFromOffset(Offset offset) {
  return matrixAtPosition(
    x: -offset.dx,
    y: -offset.dy,
  );
}
