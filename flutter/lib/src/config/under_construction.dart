import 'package:app_boot/app_boot.dart';
import 'package:flutter/foundation.dart';

import '../commons/settings.dart';

class DevelopmentError {
  const DevelopmentError(this.moduleName);

  final String moduleName;

  @override
  String toString() {
    return 'DevelopmentError: $moduleName was enabled but it cannot be used in production. It is marked as "IN DEVELOPMENT".\n\nHint: To fix this issue, assign `false` to the constant `InDevelopment.$moduleName` in the under_construction.dart file.';
  }
}

class InDevelopment {
  InDevelopment._();

  static const _assertsEnabled = false;

  static void assertFlags() {
    if (_assertsEnabled &&
        kReleaseMode &&
        settingsManager.isFor(SettingsFor.production)) {
      _assert(offlinePlayback, 'offlinePlayback');
    }
  }

  static void _assert(bool flag, String moduleName) {
    if (flag) {
      throw DevelopmentError(moduleName);
    }
  }

  static const bool offlinePlayback = true;
}

class BuildConfiguration {
  BuildConfiguration._();

  static const bool displaySubscriptionsAfterSkipOrLoginFromOnboarding = false;
}
