import 'dart:async';

class SingleAsyncMessage<T> {
  Completer<T?>? _completer;

  void markNeedsResult() {
    _completer = Completer<T?>();
  }

  bool get isResultRequired => _completer != null;

  void send(T value) {
    final completer = _completer;
    if (completer == null) return;
    completer.complete(value);
    clear();
  }

  Future<T?> get() {
    final completer = _completer;
    if (completer == null) return Future.value(null);
    return completer.future;
  }

  void clear() {
    if (_completer?.isCompleted == false) _completer?.complete(null);
    _completer = null;
  }
}
