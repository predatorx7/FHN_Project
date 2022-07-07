import 'package:app_boot/app_boot.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping/src/commons/settings.dart';
import 'package:shopping/src/config/firebase/firebase_options.dart';
import 'package:shopping/src/utils/logging/logging.dart';

import 'src/config/bootstrap.dart';
import 'src/ui/main/app.dart';
import 'src/utils/logging/default_logging.dart';

void main() {
  final bootstrap = BootstrapApp(
    onStart: () async {
      settingsManager.settings = mainAppSettings;

      await onStart(DefaultFirebaseOptions.android);
    },
    createLoggingManager: () {
      return createDefaultLoggingManager(true, false, false, logging.logger);
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
