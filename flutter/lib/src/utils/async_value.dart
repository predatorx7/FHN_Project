import 'package:riverpod/riverpod.dart';

extension ValueX<T> on AsyncValue<T> {
  T? get justGet {
    return when<T?>(
      data: (it) => it,
      error: (e, s) => null,
      loading: () => null,
    );
  }
}
