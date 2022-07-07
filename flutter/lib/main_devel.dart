import 'package:app_boot/app_boot.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging_manager_flutter/logging_manager_flutter.dart';
import 'package:shopping/src/config/firebase/firebase_options_dev.dart';
import 'package:shopping/src/ui/main/app.dart';
import 'package:shopping/src/utils/logging/logging.dart';

import 'src/commons/settings.dart';
import 'src/config/bootstrap.dart';
import 'src/utils/logging/default_logging.dart';

void main() {
  final bootstrap = BootstrapApp(
    onStart: () async {
      settingsManager.settings = mainAppSettings.copyWith(
        flavorName: 'devel',
        identifier: SettingsFor.development,
      );

      await onStart(DefaultFirebaseOptions.android);
    },
    runGuarded: false,
    createLoggingManager: () {
      return createDefaultLoggingManager(
        false,
        false,
        true,
        logging.logger,
        PrintingColoredLogsTree(
          loggerOutput: const DebugPrinterLoggerOutput(),
        ),
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
