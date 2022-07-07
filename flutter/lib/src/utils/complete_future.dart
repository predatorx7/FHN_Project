import 'package:shopping/src/utils/logging/logging.dart';

Future<T?> tryFuture<T>(Future<T> Function() callback) async {
  try {
    return await callback();
  } catch (e, s) {
    logging.warning('Eror', e, s);
    return null;
  }
}
