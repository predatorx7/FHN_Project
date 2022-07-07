import 'package:shared_preferences/shared_preferences.dart';

class TelemetryPreferences {
  static const String _telemetryKey = 'telemetry_preferences:v0.1';
  static const String _lastUpdatedKey =
      '$_telemetryKey:last_updated_datetime_stamp';

  Future<DateTime?> getLastUpdated() async {
    final preferences = await SharedPreferences.getInstance();

    final value = preferences.getString(_lastUpdatedKey);

    if (value == null || value.isEmpty) return null;

    return DateTime.tryParse(value);
  }

  Future<bool> setLastUpdated() async {
    final preferences = await SharedPreferences.getInstance();
    final now = DateTime.now();
    return preferences.setString(_lastUpdatedKey, now.toIso8601String());
  }
}
