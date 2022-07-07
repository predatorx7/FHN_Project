import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logging_manager_flutter/logging_manager_flutter.dart';

final isFirebaseSupported = kIsWeb ||
    defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS ||
    defaultTargetPlatform == TargetPlatform.macOS;

final isFirebaseCrashlyticsSupported = !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS);

FirebaseFlutterLoggingManager createDefaultLoggingManager([
  bool enableCrashlytics = false,
  bool printDetailsWhenCrashlyticsEnabled = true,
  bool recordFlutterErrorsAsFatal = false,
  Logger? logger,
  LoggingTree? tree,
]) {
  return FirebaseFlutterLoggingManager(
    logger: logger,
    tree: tree ??
        (enableCrashlytics && isFirebaseCrashlyticsSupported
            ? FirebaseLogsTree(
                crashlytics: FirebaseCrashlytics.instance,
                printDetails: printDetailsWhenCrashlyticsEnabled,
              )
            : PrintingColoredLogsTree()),
    printDetails: printDetailsWhenCrashlyticsEnabled,
    recordFlutterErrorsAsFatal: recordFlutterErrorsAsFatal,
  );
}

class FirebaseFlutterLoggingManager extends FlutterLoggingManager {
  FirebaseFlutterLoggingManager({
    super.logger,
    LoggingTree? tree,
    this.printDetails,
    this.recordFlutterErrorsAsFatal = false,
  })  : _tree = tree,
        super(tree: tree);

  final LoggingTree? _tree;

  bool? printDetails;
  bool recordFlutterErrorsAsFatal;

  @override
  Future<void> onRecordError(
    Object? error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) {
    final tree = _tree;
    if (hasTree && tree is FirebaseLogsTree) {
      return tree.crashlytics.recordError(
        error,
        stackTrace,
        reason: reason,
        printDetails: printDetails,
        fatal: fatal,
      );
    } else {
      return super.onRecordError(
        error,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );
    }
  }

  /// Creates a log from [FlutterErrorDetails].
  @override
  Future<void> onFlutterError(FlutterErrorDetails details) {
    final tree = _tree;
    if (hasTree && tree is FirebaseLogsTree) {
      return tree.crashlytics.recordFlutterError(
        details,
        fatal: recordFlutterErrorsAsFatal,
      );
    }

    super.onFlutterError(details);
    return Future.value();
  }

  /// Initialize firebase in beforeRun.
  @override
  Future<void>? runFlutterInZoneGuardedWithLogging(
    FutureCallback onRun, {
    void Function(Object, StackTrace)? onError,
    Map<Object?, Object?>? zoneValues,
    ZoneSpecification? zoneSpecification,
  }) {
    return runZoneGuardedWithLogging(
      () async {
        /// We must call WidgetsFlutterBinding.ensureInitialized() inside
        /// runZonedGuarded. Error handling wouldn’t work if
        /// WidgetsFlutterBinding.ensureInitialized() was called from the outside.
        WidgetsFlutterBinding.ensureInitialized();

        // The following lines are the same as previously explained in "Handling uncaught errors"
        FlutterError.onError = onFlutterError;

        if (!kIsWeb) {
          // To catch errors outside of the Flutter context, we attach an error
          // listener to the current isolate.
          listenErrorsWithCurrentIsolate();
        }

        onRun();
      },
      onError: onError,
      zoneValues: zoneValues,
      zoneSpecification: zoneSpecification,
    );
  }
}

class FirebaseLogsTree extends FormattedOutputLogsTree {
  /// Value of log's [Level.value] greater than this value will allow print of stacktrace
  final int errorThreshold;
  final FirebaseCrashlytics crashlytics;
  final bool? printDetails;

  FirebaseLogsTree({
    // Warning level. Only consider as error when level more than threshold.
    this.errorThreshold = 900,
    this.printDetails,
    required this.crashlytics,
  });

  static _getWithNewLineIfNotEmpty(String? value) {
    if (value == null || value.isEmpty) return '';
    return '\n$value';
  }

  @override
  void logger(
    String messageText,
    String objectText,
    String? errorLabel,
    FormattedStacktrace stacktrace,
    LogRecord record,
  ) {
    StackTrace? stackTrace;
    final reason = '$messageText${_getWithNewLineIfNotEmpty(objectText)}';
    crashlytics.log(reason);
    if (record.level.value > errorThreshold) {
      stackTrace = stacktrace.stackTrace;
      crashlytics.recordError(
        record.error,
        stackTrace,
        reason: reason,
        printDetails: printDetails,
      );
    }
  }
}
