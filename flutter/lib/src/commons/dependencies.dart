import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> resolveAppDependencies(
  BuildContext context,
  WidgetRef ref,
) async {
  await _initializeFirebaseMessaging();
}

Future<void> _initializeFirebaseMessaging() async {
  final firebaseMessaging = FirebaseMessaging.instance;
  await firebaseMessaging.requestPermission(
    sound: true,
    badge: true,
    alert: true,
  );
}
