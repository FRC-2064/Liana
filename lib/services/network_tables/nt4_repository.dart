import 'dart:async';

import 'package:liana/services/network_tables/nt_entry.dart';
import 'package:liana/services/network_tables/nt_repository.dart';
import 'package:liana/services/network_tables/nt_topic.dart';
import 'package:liana/services/network_tables/nt_types.dart';
import 'package:nt4/nt4.dart';

abstract interface class Nt4Transport {
  Stream<bool> get connectionStatus;
  bool get isConnected;
  String get serverAddress;
  Object subscribe(
    String path,
    double interval,
    void Function(Object?) onValue,
  );
  void unsubscribe(Object subscription);
  Object publish(String path, String ntType);
  void unpublish(Object publication);
  void addSample(Object publication, Object value);
  void reconnect(String serverAddress);
}

final class Nt4Repository implements NtRepository {
  final Nt4Transport _transport;
  final Map<String, _Nt4Entry<Object>> _entries = {};
  bool _disposed = false;

  Nt4Repository({required String serverAddress})
    : _transport = _Nt4ClientTransport(serverAddress);

  Nt4Repository.withTransport(this._transport);

  @override
  Stream<bool> get connectionStatus => _transport.connectionStatus;

  @override
  bool get isConnected => _transport.isConnected;

  @override
  String get serverAddress => _transport.serverAddress;

  @override
  NtEntry<T> entry<T>(NtTopic<T> topic) {
    if (_disposed) throw StateError('Nt4Repository is disposed');
    final path = resolveNtTopicPath(topic.path);
    final ntType = ntTypeForValue(topic.testValue as Object);
    final existing = _entries[path];
    if (existing != null) {
      existing.validate(T, ntType, topic.interval);
      return existing as NtEntry<T>;
    }

    final created = _Nt4Entry<T>(
      transport: _transport,
      path: path,
      dartType: T,
      ntType: ntType,
      interval: topic.interval,
    );
    _entries[path] = created as _Nt4Entry<Object>;
    return created;
  }

  void reconnect(String address) {
    if (_disposed) throw StateError('Nt4Repository is disposed');
    if (address != serverAddress) _transport.reconnect(address);
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

final class _Nt4Entry<T> implements NtEntry<T> {
  final Nt4Transport transport;
  final String path;
  final Type dartType;
  final String ntType;
  final double interval;
  final StreamController<NtValue<T>> _controller = StreamController.broadcast();

  late final Object _subscription;
  Object? _publication;
  NtValue<T> _current = const NtValue.missing();
  bool _disposed = false;

  _Nt4Entry({
    required this.transport,
    required this.path,
    required this.dartType,
    required this.ntType,
    required this.interval,
  }) {
    _subscription = transport.subscribe(path, interval, _receive);
  }

  void validate(
    Type requestedType,
    String requestedNtType,
    double requestedInterval,
  ) {
    if (dartType != requestedType ||
        ntType != requestedNtType ||
        interval != requestedInterval) {
      throw StateError(
        'Conflicting declaration for $path: $dartType/$ntType/$interval vs '
        '$requestedType/$requestedNtType/$requestedInterval',
      );
    }
  }

  void _receive(Object? payload) {
    if (_disposed) return;
    final converted = convertNtPayload<T>(payload);
    if (converted == null) return;
    _current = NtValue.present(converted);
    _controller.add(_current);
  }

  @override
  NtValue<T> get current => _current;

  @override
  Stream<NtValue<T>> get values => _controller.stream;

  @override
  void set(T value) {
    if (_disposed) throw StateError('NtEntry is disposed');
    _publication ??= transport.publish(path, ntType);
    transport.addSample(_publication!, value as Object);
    _current = NtValue.present(value);
    _controller.add(_current);
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    transport.unsubscribe(_subscription);
    final publication = _publication;
    if (publication != null) transport.unpublish(publication);
    _controller.close();
  }
}

final class _Nt4ClientTransport implements Nt4Transport {
  late final NT4Client _client;
  bool _isConnected = false;

  _Nt4ClientTransport(String address) {
    _client = NT4Client(
      serverBaseAddress: address,
      onConnect: () => _isConnected = true,
      onDisconnect: () => _isConnected = false,
    );
  }

  @override
  Stream<bool> get connectionStatus => _client.connectionStatusStream();

  @override
  bool get isConnected => _isConnected;

  @override
  String get serverAddress => _client.serverBaseAddress;

  @override
  Object subscribe(
    String path,
    double interval,
    void Function(Object?) onValue,
  ) {
    final subscription = _client.subscribePeriodic(path, interval);
    subscription.listen(onValue);
    return subscription;
  }

  @override
  void unsubscribe(Object subscription) {
    _client.unSubscribe(subscription as NT4Subscription);
  }

  @override
  Object publish(String path, String ntType) {
    return _client.publishNewTopic(path, ntType);
  }

  @override
  void unpublish(Object publication) {
    _client.unpublishTopic(publication as NT4Topic);
  }

  @override
  void addSample(Object publication, Object value) {
    _client.addSample(publication as NT4Topic, value);
  }

  @override
  void reconnect(String serverAddress) {
    _client.setServerBaseAddress(serverAddress);
  }
}
