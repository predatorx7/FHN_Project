import 'package:riverpod/riverpod.dart';

final userNameProvider = Provider<String?>((ref) {
  return 'John';
});