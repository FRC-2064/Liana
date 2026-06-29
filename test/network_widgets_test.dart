import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liana/services/network_tables/memory_nt_repository.dart';
import 'package:liana/services/network_tables/nt_entry.dart';
import 'package:liana/services/network_tables/nt_repository.dart';
import 'package:liana/services/network_tables/nt_topic.dart';
import 'package:liana/widgets/network_tables/nt_adjustment.dart';
import 'package:liana/widgets/network_tables/nt_bool.dart';
import 'package:liana/widgets/network_tables/nt_button_group.dart';
import 'package:liana/widgets/network_tables/selected_auto.dart';
import 'package:liana/widgets/network_tables/timer.dart';
import 'package:provider/provider.dart';

Widget _host(NtRepository repository, Widget child) {
  return Provider<NtRepository>.value(
    value: repository,
    child: MaterialApp(
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  group('NtButtonGroup', () {
    const topic = NtTopic<String>(path: 'Group', testValue: 'A');

    testWidgets('shows selected, unknown, and pressed values', (tester) async {
      final repository = MemoryNtRepository();
      final entry = repository.entry(topic);
      await tester.pumpWidget(
        _host(
          repository,
          NtButtonGroup<String>(
            topic: topic,
            options: const [
              NtButtonOption(value: 'A', child: Text('A')),
              NtButtonOption(value: 'B', child: Text('B')),
            ],
            itemBuilder: (_, option, state) => TextButton(
              key: Key('option-${option.value}'),
              onPressed: state.onPressed,
              child: Text(
                '${option.value}:${state.isSelected}:${state.isMissing}',
              ),
            ),
          ),
        ),
      );
      expect(find.text('A:true:false'), findsOneWidget);
      expect(find.text('B:false:false'), findsOneWidget);

      entry.set('unknown');
      await tester.pump();
      expect(find.text('A:false:false'), findsOneWidget);
      expect(find.text('B:false:false'), findsOneWidget);

      await tester.tap(find.byKey(const Key('option-B')));
      await tester.pump();
      expect(entry.current.value, 'B');
      expect(find.text('B:true:false'), findsOneWidget);
    });

    testWidgets('represents missing data and custom layout/style', (
      tester,
    ) async {
      final repository = _ManualRepository<String>();
      await tester.pumpWidget(
        _host(
          repository,
          NtButtonGroup<String>(
            topic: topic,
            options: const [NtButtonOption(value: 'A', child: Text('A'))],
            itemBuilder: (_, option, state) => Container(
              key: Key('custom-${state.isMissing}-${state.isSelected}'),
              child: option.child,
            ),
            layoutBuilder: (_, children) =>
                Column(key: const Key('custom-layout'), children: children),
          ),
        ),
      );
      expect(find.byKey(const Key('custom-layout')), findsOneWidget);
      expect(find.byKey(const Key('custom-true-false')), findsOneWidget);
      expect(repository.entryValue.listenCount, 1);
    });

    testWidgets('default item uses 2025 expressive dimensions and styling', (
      tester,
    ) async {
      final repository = MemoryNtRepository();
      await tester.pumpWidget(
        _host(
          repository,
          NtButtonGroup<String>(
            topic: topic,
            options: const [NtButtonOption(value: 'A', child: Text('A'))],
          ),
        ),
      );

      expect(find.byType(AnimatedScale), findsOneWidget);
      final size = tester.getSize(find.byType(AnimatedScale));
      expect(size, const Size(150, 75));
      final text = tester.widget<Text>(find.text('A'));
      expect(text.style, isNull);
    });

    test('rejects duplicate option values', () {
      expect(
        () => NtButtonGroup<String>(
          topic: topic,
          options: const [
            NtButtonOption(value: 'A', child: Text('1')),
            NtButtonOption(value: 'A', child: Text('2')),
          ],
        ),
        throwsArgumentError,
      );
    });
  });

  testWidgets('boolean indicator switch reads and writes topic', (
    tester,
  ) async {
    final repository = MemoryNtRepository();
    const topic = NtTopic<bool>(path: 'Bool', testValue: false);
    await tester.pumpWidget(
      _host(
        repository,
        const NtBool(name: 'Enabled', topic: topic, isSwitch: true),
      ),
    );
    expect(repository.entry(topic).current.value, isFalse);
    await tester.tap(find.text('Enabled'));
    await tester.pump();
    expect(repository.entry(topic).current.value, isTrue);
  });

  testWidgets('timer formats values and adjustment writes increments', (
    tester,
  ) async {
    final repository = MemoryNtRepository();
    const timer = NtTopic<double>(path: 'Time', testValue: 65);
    const adjustment = NtTopic<double>(path: 'Adjust', testValue: 0);
    await tester.pumpWidget(
      _host(
        repository,
        const Column(
          children: [
            NtTimer(topic: timer),
            NtAdjustment(
              topic: adjustment,
              incrementAmount: 2,
              title: 'Adjustment',
            ),
          ],
        ),
      ),
    );
    expect(find.text('1:05'), findsOneWidget);
    expect(find.text('0.0'), findsOneWidget);
    await tester.tap(find.text('+'));
    await tester.pump();
    expect(repository.entry(adjustment).current.value, 2);
    expect(find.text('2.0'), findsOneWidget);
  });

  testWidgets('auto selector handles empty, updates, and removed selection', (
    tester,
  ) async {
    final repository = MemoryNtRepository();
    const autos = NtTopic<List<String>>(path: 'Autos', testValue: <String>[]);
    const selected = NtTopic<String>(path: 'Selected', testValue: 'A');
    await tester.pumpWidget(
      _host(
        repository,
        const SelectedAuto(
          availableAutosTopic: autos,
          selectedAutoTopic: selected,
          gifBasePath: 'assets/gifs',
        ),
      ),
    );
    expect(find.text('No autos available'), findsOneWidget);

    repository.entry(autos).set(['A', 'B']);
    await tester.pump();
    await tester.pump();
    expect(find.text('A'), findsOneWidget);

    repository.entry(selected).set('A');
    repository.entry(autos).set(['B']);
    await tester.pump();
    await tester.pump();
    expect(repository.entry(selected).current.value, 'B');
  });
}

final class _ManualRepository<T> implements NtRepository {
  final _ManualEntry<T> entryValue = _ManualEntry<T>();

  @override
  NtEntry<V> entry<V>(NtTopic<V> topic) => entryValue as NtEntry<V>;
  @override
  Stream<bool> get connectionStatus => const Stream.empty();
  @override
  bool get isConnected => false;
  @override
  String? get serverAddress => 'test';
  @override
  void dispose() => entryValue.dispose();
}

final class _ManualEntry<T> implements NtEntry<T> {
  late final StreamController<NtValue<T>> _controller;
  NtValue<T> currentValue = const NtValue.missing();
  int listenCount = 0;

  _ManualEntry() {
    _controller = StreamController.broadcast(onListen: () => listenCount++);
  }

  @override
  NtValue<T> get current => currentValue;
  @override
  Stream<NtValue<T>> get values => _controller.stream;
  @override
  void set(T value) {
    currentValue = NtValue.present(value);
    _controller.add(currentValue);
  }

  void dispose() => _controller.close();
}
