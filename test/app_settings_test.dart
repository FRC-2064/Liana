import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liana/app/app_settings.dart';
import 'package:liana/app/layout_definition.dart';
import 'package:liana/app/layout_registry.dart';
import 'package:liana/app/settings_store.dart';
import 'package:liana/utils/liana_connection_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AppSettings', () {
    test('validates teams and generates robot addresses', () {
      expect(AppSettings.isValidTeamNumber(2064), isTrue);
      expect(AppSettings.robotAddressForTeam(2064), '10.20.64.2');
      expect(AppSettings.robotAddressForTeam(1), '10.0.1.2');
      expect(AppSettings.isValidTeamNumber(0), isFalse);
      expect(AppSettings.isValidTeamNumber(25600), isFalse);
      expect(() => AppSettings.robotAddressForTeam(25600), throwsArgumentError);
    });

    test('serializes and copies typed values', () {
      const settings = AppSettings(
        teamNumber: 1234,
        mode: LianaConnectionMode.simulation,
        gifBasePath: 'gifs',
        layoutId: 'example',
      );
      expect(AppSettings.fromJson(settings.toJson()), settings);
      expect(settings.copyWith(teamNumber: 2064).teamNumber, 2064);
      expect(settings.serverAddress, '127.0.0.1');
      expect(
        settings.copyWith(mode: LianaConnectionMode.uiTest).serverAddress,
        isNull,
      );
    });

    test('invalid serialized fields fall back independently', () {
      final settings = AppSettings.fromJson({
        'teamNumber': -4,
        'mode': 'broken',
        'gifBasePath': ' ',
        'layoutId': '',
      });
      expect(settings, const AppSettings());
    });
  });

  group('SettingsStore', () {
    test('loads defaults for missing and corrupt data', () async {
      SharedPreferences.setMockInitialValues({});
      var store = await SettingsStore.create();
      expect(store.load(), const AppSettings());

      SharedPreferences.setMockInitialValues({
        SettingsStore.settingsKey: '{bad',
      });
      store = await SettingsStore.create();
      expect(store.load(), const AppSettings());
    });

    test('persists settings', () async {
      SharedPreferences.setMockInitialValues({});
      final store = await SettingsStore.create();
      const settings = AppSettings(layoutId: 'example');
      expect(await store.save(settings), isTrue);
      expect(store.load(), settings);
    });

    test('invalid persisted values use defaults', () async {
      SharedPreferences.setMockInitialValues({
        SettingsStore.settingsKey: jsonEncode({'teamNumber': 99999}),
      });
      final store = await SettingsStore.create();
      expect(store.load().teamNumber, AppSettings.defaultTeamNumber);
    });
  });

  testWidgets('registry resolves IDs and falls back', (tester) async {
    final registry = LayoutRegistry([
      LayoutDefinition(
        id: AppSettings.defaultLayoutId,
        name: 'Default',
        description: 'default',
        builder: (_, _) => const SizedBox(),
      ),
      LayoutDefinition(
        id: 'other',
        name: 'Other',
        description: 'other',
        builder: (_, _) => const SizedBox(),
      ),
    ]);
    expect(registry.lookup('other').id, 'other');
    expect(registry.lookup('unknown').id, AppSettings.defaultLayoutId);
  });
}
