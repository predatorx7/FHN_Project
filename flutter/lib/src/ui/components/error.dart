import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shopping/src/utils/logging/logging.dart';

import '../../../gen/assets.gen.dart';

class SliverErrorPlaceholder extends StatelessWidget {
  const SliverErrorPlaceholder({
    Key? key,
    this.error,
    this.onRetryPress,
  }) : super(key: key);

  final Object? error;
  final VoidCallback? onRetryPress;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: ErrorPlaceholder(
        error: error,
        onRetryPress: onRetryPress,
      ),
    );
  }
}

class ErrorPlaceholder extends StatelessWidget {
  const ErrorPlaceholder({
    Key? key,
    this.error,
    this.label,
    this.onRetryPress,
  }) : super(key: key);

  final Object? error;
  final String? label;
  final VoidCallback? onRetryPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final errorObject = error;
    String message = 'Oh no!\nSomething went wrong';
    ImageProvider<Object> image = AssetImage(Assets.icons.brokenWire.path);

    if (errorObject is DioError) {
      final statusCode = errorObject.response?.statusCode ?? -1;
      final errorInDio = errorObject.error;
      logging.info('error details: $errorInDio, status code: $statusCode');
      if (statusCode == 404 ||
          statusCode >= 500 ||
          (!kIsWeb && errorInDio is SocketException)) {
        message = 'Unable to connect with VROTT service';
        image = AssetImage(Assets.icons.cancel.path);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: image,
              ),
            ],
          ),
          Text(
            label ?? message,
            textAlign: TextAlign.center,
            style: textTheme.headline5,
          ),
          if (onRetryPress != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: onRetryPress,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 21.0),
                      child: Text('Try again'),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
