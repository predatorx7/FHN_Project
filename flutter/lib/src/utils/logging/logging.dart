import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:logging_manager_flutter/logging_manager_flutter.dart';

const String appLoggerName = 'shopping';

Logging logging = Logging(appLoggerName);

final _defaultLoggingManager = FlutterLoggingManager(
  logger: logging._logger,
  tree: LoggingTree.coloredPrinting(),
);

FlutterLoggingManager internalLoggingManager = _defaultLoggingManager;

FlutterLoggingManager get loggingManager => internalLoggingManager;

class DebugPrinterLoggerOutput implements LoggerOutput {
  const DebugPrinterLoggerOutput();

  @override
  void call(String message, LogRecord record) {
    debugPrint(message);
  }
}

void startPrinting() {
  logging.onRecord.listen((event) {
    debugPrint(
      '${event.level.name}/${event.loggerName} (${event.sequenceNumber}) ${event.message}',
      wrapWidth: 600,
    );
    if (event.error != null) {
      debugPrint(
        '${event.level.name}/${event.sequenceNumber} ${event.error}',
        wrapWidth: 600,
      );
    }
    if (event.object != null) {
      debugPrint(
        '${event.level.name}/${event.sequenceNumber} ${event.object}',
        wrapWidth: 600,
      );
    }
    if (event.stackTrace != null) {
      debugPrintStack(
        stackTrace: event.stackTrace,
        label: event.sequenceNumber.toString(),
      );
    }
    debugPrint(
      '${event.level.name}/${event.sequenceNumber} ${event.time}',
      wrapWidth: 600,
    );
  });
}

class Logging {
  final String name;

  final Logger _logger;

  Logger get logger => _logger;

  Logging(this.name) : _logger = Logger(name);

  Logging call(String name) {
    assert(name.isNotEmpty, 'Name should not be empty');

    return Logging('${_logger.fullName}.$name');
  }

  /// Log message at level [Level.FINEST].
  ///
  /// See [log] for information on how non-String [message] arguments are
  /// handled.
  void finest(Object? message, [Object? error, StackTrace? stackTrace]) =>
      log(Level.FINEST, message, error, stackTrace);

  /// Log message at level [Level.FINER].
  ///
  /// See [log] for information on how non-String [message] arguments are
  /// handled.
  void finer(Object? message, [Object? error, StackTrace? stackTrace]) =>
      log(Level.FINER, message, error, stackTrace);

  /// Log message at level [Level.FINE].
  ///
  /// See [log] for information on how non-String [message] arguments are
  /// handled.
  void fine(Object? message, [Object? error, StackTrace? stackTrace]) =>
      log(Level.FINE, message, error, stackTrace);

  /// Log message at level [Level.CONFIG].
  ///
  /// See [log] for information on how non-String [message] arguments are
  /// handled.
  void config(Object? message, [Object? error, StackTrace? stackTrace]) =>
      log(Level.CONFIG, message, error, stackTrace);

  /// Log message at level [Level.INFO].
  ///
  /// See [log] for information on how non-String [message] arguments are
  /// handled.
  void info(Object? message, [Object? error, StackTrace? stackTrace]) =>
      log(Level.INFO, message, error, stackTrace);

  /// Log message at level [Level.WARNING].
  ///
  /// See [log] for information on how non-String [message] arguments are
  /// handled.
  void warning(Object? message, [Object? error, StackTrace? stackTrace]) =>
      log(Level.WARNING, message, error, stackTrace);

  /// Log message at level [Level.SEVERE].
  ///
  /// See [log] for information on how non-String [message] arguments are
  /// handled.
  void severe(Object? message, [Object? error, StackTrace? stackTrace]) =>
      log(Level.SEVERE, message, error, stackTrace);

  /// Log message at level [Level.SHOUT].
  ///
  /// See [log] for information on how non-String [message] arguments are
  /// handled.
  void shout(Object? message, [Object? error, StackTrace? stackTrace]) =>
      log(Level.SHOUT, message, error, stackTrace);

  void log(
    Level logLevel,
    Object? message,
    dynamic error,
    StackTrace? stackTrace,
  ) {
    return _logger.log(logLevel, message, error, stackTrace);
  }

  Stream<LogRecord> get onRecord {
    return _logger.onRecord;
  }
}
