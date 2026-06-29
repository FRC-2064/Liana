import 'dart:convert';

import 'package:liana/app/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class SettingsStore {
  static const String settingsKey = 'appSettings';

  final SharedPreferences _preferences;

  const SettingsStore(this._preferences);

  static Future<SettingsStore> create() async {
    return SettingsStore(await SharedPreferences.getInstance());
  }

  AppSettings load() {
    try {
      final encoded = _preferences.getString(settingsKey);
      if (encoded == null) return const AppSettings();
      final decoded = jsonDecode(encoded);
      if (decoded is! Map) return const AppSettings();
      return AppSettings.fromJson(Map<String, Object?>.from(decoded));
    } on Object {
      return const AppSettings();
    }
  }

  Future<bool> save(AppSettings settings) {
    return _preferences.setString(settingsKey, jsonEncode(settings.toJson()));
  }
}
