import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart' as widgets show runApp;
import 'package:logging_manager_flutter/logging_manager_flutter.dart';
import 'package:magnific_core/magnific_core.dart';

import '../utils/logging/logging.dart';
import '../utils/sql/initialize.dart';
import 'under_construction.dart';

Future<void> _addFontLicense() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
}

List<Future> onStarted() {
  initializePlatformDatabase();

  cachedNetworkImageProviver = (it) {
    if (kIsWeb) return NetworkImage(it);
    return CachedNetworkImageProvider(it);
  };
  return <Future>[
    _addFontLicense(),
  ];
}

Future<void> _initFirebase(FirebaseOptions? options) async {
  await Firebase.initializeApp(options: options);
  // Force disable Crashlytics collection while doing every day development.
  // Temporarily toggle this to true if you want to test crash reporting in your app.
  if (!kIsWeb && kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  if (!kDebugMode) {
    final _ = FirebasePerformance.instance;
  }
}

Future<void> onStart(FirebaseOptions? options) async {
  InDevelopment.assertFlags();
  await _initFirebase(options);
}

class BootstrapApp {
  BootstrapApp({
    required this.onStart,
    required this.createLoggingManager,
    this.onStarted,
    this.level = Level.ALL,
    required this.runApp,
    this.runGuarded = true,
  });

  final bool runGuarded;

  @protected
  final Level? level;

  @protected

  /// Ran before the Zone guarded execution before creation of logging mechanism
  final Future<void> Function() onStart;
  @protected

  /// Creates logging mechanism.
  final FlutterLoggingManager Function() createLoggingManager;

  @protected
  final Widget Function() runApp;
  @protected

  /// Ran in the Zone guarded execution after creation of logging mechanism.
  final List<Future<dynamic>> Function()? onStarted;

  static void debug(String message, LogRecord record) {
    debugPrint(message);
  }

  Future<void> _bootstrap() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (kDebugMode) {
      debugPrint(
        'Created LoggingManager [${loggingManager.runtimeType}] with logger ${loggingManager.logger.fullName}',
      );
    } else {
      debugPrint(
        'U/bootstrap logging with ${loggingManager.logger.fullName}',
      );
    }

    FlutterError.onError = loggingManager.onFlutterError;

    if (onStarted != null) {
      await Future.wait(onStarted!());
    }
  }

  Future<void> _runGuarded() async {
    await _bootstrap();
    widgets.runApp(runApp());
  }

  Future<void> start() async {
    WidgetsFlutterBinding.ensureInitialized();

    await onStart();

    internalLoggingManager.removeTree();
    internalLoggingManager = createLoggingManager();
    internalLoggingManager.logger.level = level;

    if (!runGuarded) {
      return _runGuarded();
    }

    loggingManager.runFlutterInZoneGuardedWithLogging(
      _runGuarded,
      zoneSpecification: ZoneSpecification(
        print: (
          Zone self,
          ZoneDelegate parent,
          Zone zone,
          String line,
        ) {
          parent.print(zone, line);
        },
      ),
    );
  }
}
