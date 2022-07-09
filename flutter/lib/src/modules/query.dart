import 'dart:async';

import 'package:magnific_core/magnific_core.dart';
import 'package:riverpod/riverpod.dart';

class SearchQueryProvider extends StateNotifier<String?> {
  SearchQueryProvider([
    this._debounceDuration = const Duration(milliseconds: 500),
  ]) : super(null);

  final Duration _debounceDuration;
  Timer? _debounce;

  void onTextChanged(String value) {
    if (StringX.isBlank(value)) {
      state = null;
      return;
    }

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      state = value;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
