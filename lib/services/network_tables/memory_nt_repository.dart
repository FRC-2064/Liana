import 'dart:async';

import 'package:liana/services/network_tables/nt_entry.dart';
import 'package:liana/services/network_tables/nt_repository.dart';
import 'package:liana/services/network_tables/nt_topic.dart';
import 'package:liana/services/network_tables/nt_types.dart';

final class MemoryNtRepository implements NtRepository {
  final Map<String, _MemoryNtEntry<Object>> _entries = {};
  bool _disposed = false;

  @override
  Stream<bool> get connectionStatus => const Stream<bool>.empty();

  @override
  bool get isConnected => true;

  @override
  String? get serverAddress => null;

  @override
  NtEntry<T> entry<T>(NtTopic<T> topic) {
    if (_disposed) throw StateError('MemoryNtRepository is disposed');
    final path = resolveNtTopicPath(topic.path);
    final ntType = ntTypeForValue(topic.testValue as Object);
    final existing = _entries[path];
    if (existing != null) {
      existing.validate(T, ntType, topic.interval);
      return existing as NtEntry<T>;
    }

    final created = _MemoryNtEntry<T>(
      dartType: T,
      ntType: ntType,
      interval: topic.interval,
      initialValue: topic.testValue,
    );
    _entries[path] = created as _MemoryNtEntry<Object>;
    return created;
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    for (final entry in _entries.values) {
      entry.dispose();
    }
    _entries.clear();
  }
}

final class _MemoryNtEntry<T> implements NtEntry<T> {
  final Type dartType;
  final String ntType;
  final double interval;
  final StreamController<NtValue<T>> _controller = StreamController.broadcast();
  NtValue<T> _current;
  bool _disposed = false;

  _MemoryNtEntry({
    required this.dartType,
    required this.ntType,
    required this.interval,
    required T initialValue,
  }) : _current = NtValue.present(initialValue);

  void validate(
    Type requestedType,
    String requestedNtType,
    double requestedInterval,
  ) {
    if (dartType != requestedType ||
        ntType != requestedNtType ||
        interval != requestedInterval) {
      throw StateError(
        'Conflicting declaration: $dartType/$ntType/$interval vs '
        '$requestedType/$requestedNtType/$requestedInterval',
      );
    }
  }

  @override
  NtValue<T> get current => _current;

  @override
  Stream<NtValue<T>> get values => _controller.stream;

  @override
  void set(T value) {
    if (_disposed) throw StateError('NtEntry is disposed');
    _current = NtValue.present(value);
    _controller.add(_current);
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _controller.close();
  }
}
