import 'package:flutter/material.dart';
import 'package:magnific_core/magnific_core.dart';
import 'package:shopping/l10n/l10n.dart';

String? resolveString(String? value) {
  if (value == null || StringX.isBlank(value)) {
    return null;
  }
  return value;
}

String resolveStringFallback(
  BuildContext context,
  String? value,
  String Function(AppLocalizations l10n) fallback,
) {
  return resolveString(value) ?? fallback(context.l10n);
}
