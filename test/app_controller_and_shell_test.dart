import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liana/app/app_controller.dart';
import 'package:liana/app/app_settings.dart';
import 'package:liana/app/layout_registry.dart';
import 'package:liana/app/liana_app.dart';
import 'package:liana/app/settings_store.dart';
import 'package:liana/services/network_tables/memory_nt_repository.dart';
import 'package:liana/services/network_tables/nt4_repository.dart';
import 'package:liana/services/network_tables/nt_entry.dart';
import 'package:liana/services/network_tables/nt_repository.dart';
import 'package:liana/services/network_tables/nt_topic.dart';
import 'package:liana/utils/liana_connection_mode.dart';
import 'package:liana/widgets/settings_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SettingsStore> _store() async {
  SharedPreferences.setMockInitialValues({});
  return SettingsStore.create();
}

void main() {
  group('AppController', () {
    test(
      'unknown layout falls back and live layout applies immediately',
      () async {
        final controller = AppController(
          settings: const AppSettings(
            mode: LianaConnectionMode.uiTest,
            layoutId: 'unknown',
          ),
          store: await _store(),
        );
        expect(controller.selectedLayout.id, 'reefscape-2025');
        expect(controller.settings.layoutId, 'reefscape-2025');

        await controller.applySettings(
          controller.settings.copyWith(
            layoutId: 'example',
            gifBasePath: 'new-gifs',
          ),
        );
        expect(controller.selectedLayout.id, 'example');
        expect(controller.settings.gifBasePath, 'new-gifs');
        controller.dispose();
      },
    );

    test(
      'team changes reconnect robot backend and mode changes require restart',
      () async {
        final transport = _ControllerTransport();
        final repository = Nt4Repository.withTransport(transport);
        final controller = AppController(
          settings: const AppSettings(),
          store: await _store(),
          repositoryFactory: (_) => repository,
        );

        await controller.applySettings(
          controller.settings.copyWith(teamNumber: 1234),
        );
        expect(transport.reconnects, ['10.12.34.2']);
        expect(controller.restartRequired, isFalse);

        await controller.applySettings(
          controller.settings.copyWith(mode: LianaConnectionMode.uiTest),
        );
        expect(controller.restartRequired, isTrue);
        expect(identical(controller.repository, repository), isTrue);
        expect(controller.activeMode, LianaConnectionMode.robot);

        await controller.applySettings(
          controller.settings.copyWith(mode: LianaConnectionMode.robot),
        );
        expect(controller.restartRequired, isFalse);
        controller.dispose();
      },
    );
  });

  group('SettingsDialog', () {
    testWidgets('invalid fields disable save and cancel returns no mutation', (
      tester,
    ) async {
      AppSettings? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result = await showDialog<AppSettings>(
                  context: context,
                  builder: (_) => SettingsDialog(
                    settings: const AppSettings(),
                    layouts: LayoutRegistry.standard().layouts,
                  ),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('team-number-field')), '0');
      await tester.pump();
      final save = tester.widget<FilledButton>(
        find.byKey(const Key('save-settings')),
      );
      expect(save.onPressed, isNull);
      await tester.tap(find.byKey(const Key('cancel-settings')));
      await tester.pumpAndSettle();
      expect(result, isNull);
    });

    testWidgets('save returns typed settings and mode warning', (tester) async {
      AppSettings? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result = await showDialog<AppSettings>(
                  context: context,
                  builder: (_) => SettingsDialog(
                    settings: const AppSettings(),
                    layouts: LayoutRegistry.standard().layouts,
                  ),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('UI Test'));
      await tester.pump();
      expect(find.byKey(const Key('restart-required-message')), findsOneWidget);
      await tester.tap(find.byKey(const Key('save-settings')));
      await tester.pumpAndSettle();
      expect(result, isA<AppSettings>());
      expect(result!.mode, LianaConnectionMode.uiTest);
    });
  });

  group('app shell', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    testWidgets('smoke renders every registered layout using memory backend', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      for (final id in ['reefscape-2025', 'prototype-2026', 'example']) {
        final controller = AppController(
          settings: AppSettings(mode: LianaConnectionMode.uiTest, layoutId: id),
          store: await _store(),
        );
        await tester.pumpWidget(
          LianaApp(controller: controller, startUpdater: false),
        );
        await tester.pump();
        expect(find.byKey(const Key('settings-button')), findsOneWidget);
        expect(find.byKey(const Key('connection-overlay')), findsNothing);
        expect(tester.takeException(), isNull, reason: id);
      }
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('shows overlay for disconnected live backend', (tester) async {
      final controller = AppController(
        settings: const AppSettings(layoutId: 'example'),
        store: await _store(),
        repositoryFactory: (_) => _DisconnectedRepository(),
      );
      await tester.pumpWidget(
        LianaApp(controller: controller, startUpdater: false),
      );
      expect(find.byKey(const Key('connection-overlay')), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  });
}

final class _ControllerTransport implements Nt4Transport {
  final List<String> reconnects = [];
  String _address = '10.20.64.2';

  @override
  Stream<bool> get connectionStatus => const Stream.empty();
  @override
  bool get isConnected => false;
  @override
  String get serverAddress => _address;
  @override
  Object subscribe(
    String path,
    double interval,
    void Function(Object?) onValue,
  ) => Object();
  @override
  void unsubscribe(Object subscription) {}
  @override
  Object publish(String path, String ntType) => Object();
  @override
  void unpublish(Object publication) {}
  @override
  void addSample(Object publication, Object value) {}
  @override
  void reconnect(String serverAddress) {
    _address = serverAddress;
    reconnects.add(serverAddress);
  }
}

final class _DisconnectedRepository implements NtRepository {
  final MemoryNtRepository _entries = MemoryNtRepository();
  @override
  NtEntry<T> entry<T>(NtTopic<T> topic) => _entries.entry(topic);
  @override
  Stream<bool> get connectionStatus => const Stream.empty();
  @override
  bool get isConnected => false;
  @override
  String get serverAddress => '10.20.64.2';
  @override
  void dispose() => _entries.dispose();
}
