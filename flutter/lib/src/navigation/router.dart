import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping/src/ui/screens/home.dart';

import '../config/build_options.dart';
import '../ui/main/launch.dart';
import '../utils/logging/logging.dart';

T? getTypeIf<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

final routerProviderRef = Provider(
  (ref) {
    return GoRouter(
      debugLogDiagnostics: buildConfigurations.isDiagnosticsEnabled,
      // refreshListenable: GoRouterRefreshStream(accountManager.stream),
      observers: [
        if (packageSupportInfo.isFirebaseSupported)
          FirebaseAnalyticsObserver(
            analytics: FirebaseAnalytics.instance,
            onError: (e) {
              logging.warning(
                'Failed to send navigation analytics to firebase',
                e,
              );
            },
          ),
      ],
      routes: [
        GoRoute(
          name: AppLaunchScreen.routeName,
          path: AppLaunchScreen.routeName,
          builder: (context, s) {
            final redirectPath = getTypeIf<String>(s.queryParams['redirect']);

            return AppLaunchScreen(
              routePath: redirectPath,
              reRoutePath: HomeScreen.routeName,
            );
          },
        ),
        GoRoute(
          name: HomeScreen.routeName,
          path: HomeScreen.routeName,
          builder: (context, s) {
            return const HomeScreen();
          },
        ),
      ],
    );
  },
);
