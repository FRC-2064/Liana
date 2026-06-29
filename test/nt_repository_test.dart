import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:liana/services/network_tables/memory_nt_repository.dart';
import 'package:liana/services/network_tables/nt4_repository.dart';
import 'package:liana/services/network_tables/nt_topic.dart';
import 'package:liana/services/network_tables/nt_types.dart';

void main() {
  test('legacy path resolution strips one optional leading slash', () {
    expect(resolveNtTopicPath('Robot/Value'), 'Liana/Robot/Value');
    expect(resolveNtTopicPath('/Robot/Value'), 'Liana/Robot/Value');
    expect(() => resolveNtTopicPath('/'), throwsArgumentError);
  });

  test('maps supported types and converts payloads centrally', () {
    expect(ntTypeForValue(false), 'boolean');
    expect(ntTypeForValue(1), 'int');
    expect(ntTypeForValue(1.0), 'double');
    expect(ntTypeForValue('x'), 'string');
    expect(ntTypeForValue(<bool>[]), 'boolean[]');
    expect(ntTypeForValue(<int>[]), 'int[]');
    expect(ntTypeForValue(<double>[]), 'double[]');
    expect(ntTypeForValue(<String>[]), 'string[]');
    expect(convertNtPayload<double>(2), 2.0);
    expect(convertNtPayload<int>(2.9), 2);
    expect(convertNtPayload<List<double>>([1, 2.5]), [1.0, 2.5]);
    expect(convertNtPayload<List<int>>([1.2, 2]), [1, 2]);
    expect(convertNtPayload<List<String>>([1]), ['1']);
  });

  group('MemoryNtRepository', () {
    test('shares entries and writes while opening no transport', () async {
      final repository = MemoryNtRepository();
      const topic = NtTopic<String>(path: '/Shared', testValue: 'A');
      final first = repository.entry(topic);
      final second = repository.entry(topic);
      expect(identical(first, second), isTrue);
      expect(first.current, const NtValue.present('A'));

      final next = first.values.first;
      second.set('B');
      expect(await next, const NtValue.present('B'));
      expect(first.current.value, 'B');
      expect(repository.isConnected, isTrue);
      expect(repository.serverAddress, isNull);
      repository.dispose();
      expect(() => repository.entry(topic), throwsStateError);
    });

    test('rejects conflicting declarations', () {
      final repository = MemoryNtRepository();
      repository.entry(const NtTopic<int>(path: 'Same', testValue: 0));
      expect(
        () => repository.entry(
          const NtTopic<int>(path: '/Same', testValue: 0, interval: 0.1),
        ),
        throwsStateError,
      );
      expect(
        () =>
            repository.entry(const NtTopic<double>(path: 'Same', testValue: 0)),
        throwsStateError,
      );
    });
  });

  group('Nt4Repository', () {
    test('subscribes once, starts missing, and publishes lazily', () async {
      final transport = _FakeTransport();
      final repository = Nt4Repository.withTransport(transport);
      const topic = NtTopic<double>(path: '/Robot/Speed', testValue: 4);
      final first = repository.entry(topic);
      final second = repository.entry(topic);

      expect(identical(first, second), isTrue);
      expect(transport.subscribeCount, 1);
      expect(first.current.hasValue, isFalse);
      expect(transport.publishCount, 0);
      expect(transport.samples, isEmpty);

      first.set(8);
      first.set(9);
      expect(transport.publishCount, 1);
      expect(transport.samples, [8.0, 9.0]);
      expect(first.current.value, 9);

      transport.emit(2);
      await Future<void>.delayed(Duration.zero);
      expect(first.current.value, 2.0);
    });

    test('rejects conflicts and disposes subscriptions/publications', () {
      final transport = _FakeTransport();
      final repository = Nt4Repository.withTransport(transport);
      repository.entry(const NtTopic<int>(path: 'Value', testValue: 0)).set(2);
      expect(
        () => repository.entry(
          const NtTopic<int>(path: '/Value', testValue: 0, interval: 0.2),
        ),
        throwsStateError,
      );
      repository.dispose();
      expect(transport.unsubscribeCount, 1);
      expect(transport.unpublishCount, 1);
      expect(
        () => repository.entry(const NtTopic<int>(path: 'Other', testValue: 0)),
        throwsStateError,
      );
    });
  });
}

final class _FakeTransport implements Nt4Transport {
  void Function(Object?)? callback;
  int subscribeCount = 0;
  int unsubscribeCount = 0;
  int publishCount = 0;
  int unpublishCount = 0;
  final List<Object> samples = [];

  @override
  Stream<bool> get connectionStatus => const Stream.empty();
  @override
  bool get isConnected => false;
  @override
  String get serverAddress => 'test';

  @override
  Object subscribe(
    String path,
    double interval,
    void Function(Object?) onValue,
  ) {
    subscribeCount++;
    callback = onValue;
    return Object();
  }

  void emit(Object? value) => callback?.call(value);

  @override
  void unsubscribe(Object subscription) => unsubscribeCount++;
  @override
  Object publish(String path, String ntType) {
    publishCount++;
    return Object();
  }

  @override
  void unpublish(Object publication) => unpublishCount++;
  @override
  void addSample(Object publication, Object value) => samples.add(value);
  @override
  void reconnect(String serverAddress) {}
}
