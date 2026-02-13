import 'dart:async';

import 'package:nt4/nt4.dart';

/// A class that represents a Network Table Item. This
/// stores the the [_type] of value, then [_subInterval] in which
/// to update the stream, and the [_topic](writer)
/// and [_sub](reader) for each item
class NtEntry<T> {
  final NT4Client _client;
  final String _fullTopicName;
  final String _type;
  final double _subInterval;

  late final NT4Topic _topic;
  late final NT4Subscription _sub;
  StreamSubscription? _subscription;
  final StreamController<T> _streamController = StreamController<T>.broadcast();

  T? _lastValue;
  bool _isDisposed = false;

  NtEntry({
    required NT4Client client,
    required String fullTopicName,
    required String type,
    required double interval,
    T? initialValue,
  })  : _client = client,
        _fullTopicName = fullTopicName,
        _type = type,
        _subInterval = interval,
        _lastValue = initialValue {
    _topic = _client.publishNewTopic(_fullTopicName, _type);
    _sub = _client.subscribePeriodic(_fullTopicName, _subInterval);
    _subscription =
        _sub.stream().where((data) => data is T).cast<T>().listen((data) {
      if (_isDisposed) return;
      try {
        _lastValue = data;
        if (!_streamController.isClosed) {
          _streamController.add(data);
        }
      } catch (e) {
        // Ignore errors during disposal
      }
    }, onError: (_) {});

    if (initialValue != null) {
      set(initialValue);
    }
  }

  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    _subscription?.cancel();
    _subscription = null;
    try {
      _client.unSubscribe(_sub);
      _client.unpublishTopic(_topic);
    } catch (_) {}
    _streamController.close();
  }

  Stream<T> stream() => _streamController.stream;
  T? get value => _lastValue;
  bool get isDisposed => _isDisposed;

  void set(T value) {
    if (_isDisposed) return;
    _lastValue = value;
    try {
      _client.addSample(_topic, value);
      if (!_streamController.isClosed) {
        _streamController.add(value);
      }
    } catch (e) {
      // Silently fail if we try to set on a disposed or invalid entry
      // during layout transitions.
    }
  }
}
