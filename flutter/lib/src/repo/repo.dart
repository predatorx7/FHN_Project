import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';

import '../utils/compute/json_decode.dart';
import '../utils/uri.dart';

export 'package:dio/dio.dart' show Dio;

class RepositoryError {
  final String message;
  final Object? error;
  final StackTrace? stackTrace;
  final String? errorMessage;

  const RepositoryError(
    this.message, {
    this.error,
    this.stackTrace,
    this.errorMessage,
  });

  @override
  String toString() {
    return 'RepositoryError($message)';
  }
}

abstract class HttpClientProvider {
  const HttpClientProvider();

  @protected
  AppApi get api;

  @protected
  String get baseUrl => api.url.toString();

  static bool decodeJsonInBackground = true;

  @protected
  Dio getHttpClient() {
    final headers = <String, dynamic>{};

    final options = BaseOptions(
      baseUrl: baseUrl,
      headers: headers,
    );

    final dio = Dio(options);

    if (decodeJsonInBackground) {
      setBackgroundDataProcessingForDio(dio.transformer);
    }

    return dio;
  }
}

abstract class SingleServiceRepository<SERVICE> extends HttpClientProvider {
  SERVICE? _cachedService;

  @protected
  SERVICE createService(
    Dio dio, {
    required String baseUrl,
  });

  @protected
  SERVICE get service => getService();

  @protected
  SERVICE getService() {
    if (_cachedService == null) {
      final dio = getHttpClient();

      _cachedService = createService(
        dio,
        baseUrl: baseUrl,
      );
    }

    return _cachedService!;
  }

  void dispose() {
    _cachedService = null;
  }
}

abstract class MultiServicesRepository extends HttpClientProvider {
  final Map<Type, Object> _cachedServices = {};

  @protected
  List<Type> get supportedServices;

  @protected
  T createService<T extends Object>(
    Dio dio, {
    required String baseUrl,
  });

  @protected
  T getService<T extends Object>() {
    if (!supportedServices.contains(T)) {
      throw RepositoryError('Unsupported service: $T');
    }

    if (!_cachedServices.containsKey(T)) {
      final dio = getHttpClient();

      _cachedServices[T] = createService<T>(
        dio,
        baseUrl: baseUrl,
      );
    }

    return _cachedServices[T] as T;
  }

  void dispose() {
    _cachedServices.clear();
  }
}
