import 'package:app_boot/app_boot.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/uri.dart';
import 'dependencies.dart';

class SettingsFor {
  static const production = SettingsIdentifier('production');
  static const staging = SettingsIdentifier('staging');
  static const development = SettingsIdentifier('devel');
}

class AppDependency with DependencyObject {
  final BuildContext context;
  final WidgetRef ref;

  const AppDependency(this.context, this.ref);
}

final mainAppSettings = AppSettings<AppData, DependencyObject>(
  appName: 'Shopping',
  dependencies: (input) async {
    if (input is AppDependency) {
      // Because our app needs riverpod's ref and flutter's context to
      // find its dependencies
      return resolveAppDependencies(input.context, input.ref);
    } else {
      assert(false, 'Unknown dependency');
    }
  },
  flavorName: SettingsFor.production.id,
  identifier: SettingsFor.production,
  payload: AppData(
    AppApi(
      Uri.https('api.magnificsoftware.com', ''),
    ),
    Uri.https('magnificsoftware.com', '/'),
  ),
);

class AppData {
  final AppApi mainApi;
  final Uri websiteUri;

  const AppData(this.mainApi, this.websiteUri);
}

AppApi get currentAppApi => (currentSettings.payload as AppData).mainApi;
Uri get currentWebsiteUri => (currentSettings.payload as AppData).websiteUri;
