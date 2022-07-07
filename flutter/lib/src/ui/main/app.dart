import 'package:app_boot/app_boot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping/src/di/locale.dart';

import '../../../l10n/l10n.dart';
import '../../commons/settings.dart';
import '../../commons/theme.dart';
import '../../navigation/router.dart';
import '../components/banner.dart';

class MainApp extends ConsumerStatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MainApp> createState() => MainAppState();
}

class MainAppState extends ConsumerState<MainApp> {
  @override
  Widget build(BuildContext context) {
    final settings = currentSettings;
    final router = ref.read(routerProviderRef);
    final locale = ref.watch(localeControllerProvider);

    Widget app = MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      locale: locale,
      title: settings.appName,
      theme: AppStyles.theme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      scrollBehavior: const CupertinoScrollBehavior(),
    );

    if (!settingsManager.isFor(SettingsFor.production)) {
      app = CustomModeBanner(
        label: currentSettings.flavorName,
        child: app,
      );
    }

    return app;
  }
}
