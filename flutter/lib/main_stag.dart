import 'package:app_boot/app_boot.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping/src/config/firebase/firebase_options_stg.dart';
import 'package:shopping/src/ui/main/app.dart';
import 'package:shopping/src/utils/logging/logging.dart';

import 'src/commons/settings.dart';
import 'src/config/bootstrap.dart';
import 'src/utils/logging/default_logging.dart';

const bool useProductionAPI = false;

void main() {
  final bootstrap = BootstrapApp(
    onStart: () async {
      settingsManager.settings = mainAppSettings.copyWith(
        flavorName: 'staging',
        identifier: SettingsFor.staging,
      );

      await onStart(DefaultFirebaseOptions.android);
    },
    createLoggingManager: () {
      return createDefaultLoggingManager(
        true,
        true,
        true,
        logging.logger,
      );
    },
    onStarted: onStarted,
    runApp: () {
      return const ProviderScope(
        child: MainApp(),
      );
    },
  );

  bootstrap.start();
}
