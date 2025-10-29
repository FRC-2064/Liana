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
  final StreamController<T> _streamController = StreamController<T>.broadcast();

  T? _lastValue;

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
    _sub.stream().where((data) => data is T).cast<T>().listen((data) {
      _lastValue = data;
      _streamController.add(data);
    });

    if (initialValue != null) {
      set(initialValue);
    }
  }

  Stream<T> stream() => _streamController.stream;
  T? get value => _lastValue;

  void set(T value) {
    _lastValue = value;
    _client.addSample(_topic, value);
  }
}
