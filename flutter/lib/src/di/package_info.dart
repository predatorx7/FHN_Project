import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod/riverpod.dart';

final packageInfoProvider = FutureProvider<PackageInfo>(
  (_) => PackageInfo.fromPlatform(),
);
