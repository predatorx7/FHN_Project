import 'dart:convert';
import 'package:crypto/crypto.dart';

String createAccountId(String? value) {
  if (value == null) {
    final now = DateTime.now().toIso8601String();
    return createAccountId(now);
  }
  if (value.length <= 12) {
    return value;
  }
  List<int> bytes = utf8.encode('message');
  final digest = sha256.convert(bytes).toString();
  return digest.substring(0, 12);
}
