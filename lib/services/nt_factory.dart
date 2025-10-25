import 'package:control_board/services/nt_entry.dart';
import 'package:nt4/nt4.dart';

class NtFactory {
  final NT4Client _client;
  final String _prefix = 'Liana/';

  static const double _defaultSubInterval = 0.033;

  final Map<String, NtEntry> _entries = {};

  NtFactory(this._client);

  NtEntry<T> getEntry<T>(
    String name, {
    required T defaultValue,
    double? interval,
  }) {
    final fullTopicName = _fullTopic(name);

    if (_entries.containsKey(fullTopicName)) {
      return _entries[fullTopicName] as NtEntry<T>;
    }

    final type = _getTypeFromValue(defaultValue);
    final newEntry = NtEntry<T>(
      client: _client,
      fullTopicName: fullTopicName,
      type: type,
      initialValue: defaultValue,
      interval: interval ?? _defaultSubInterval,
    );

    _entries[fullTopicName] = newEntry;
    return newEntry;
  }

  String _fullTopic(String name) {
    if (name.startsWith('/')) {
      name = name.substring(1);
    }
    return '$_prefix/$name';
  }

  String _getTypeFromValue<T>(T value) {
    if (value is bool) return NT4TypeStr.typeBool;
    if (value is int) return NT4TypeStr.typeInt;
    if (value is double) return NT4TypeStr.typeFloat64;
    if (value is String) return NT4TypeStr.typeStr;
    if (value is List<bool>) return NT4TypeStr.typeBoolArr;
    if (value is List<int>) return NT4TypeStr.typeIntArr;
    if (value is List<double>) return NT4TypeStr.typeFloat64Arr;
    if (value is List<String>) return NT4TypeStr.typeStrArr;
    throw ArgumentError('Unsupported type: $value');
  }
}
