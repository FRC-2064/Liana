import 'package:nt4/nt4.dart';

String resolveNtTopicPath(String path) {
  final withoutLeadingSlash = path.startsWith('/') ? path.substring(1) : path;
  if (withoutLeadingSlash.isEmpty) {
    throw ArgumentError.value(path, 'path', 'Topic path must not be empty');
  }
  return 'Liana/$withoutLeadingSlash';
}

String ntTypeForValue(Object value) {
  if (value is bool) return NT4TypeStr.typeBool;
  if (value is int) return NT4TypeStr.typeInt;
  if (value is double) return NT4TypeStr.typeFloat64;
  if (value is String) return NT4TypeStr.typeStr;
  if (value is List<bool>) return NT4TypeStr.typeBoolArr;
  if (value is List<int>) return NT4TypeStr.typeIntArr;
  if (value is List<double>) return NT4TypeStr.typeFloat64Arr;
  if (value is List<String>) return NT4TypeStr.typeStrArr;
  throw ArgumentError.value(value, 'value', 'Unsupported NetworkTables type');
}

T? convertNtPayload<T>(Object? payload) {
  if (payload == null) return null;
  if (T == double && payload is num) return payload.toDouble() as T;
  if (T == int && payload is num) return payload.toInt() as T;
  if (T == bool && payload is bool) return payload as T;
  if (T == String && payload is String) return payload as T;
  if (payload is List) {
    try {
      if (T == List<String>) {
        return payload.map((value) => value.toString()).toList(growable: false)
            as T;
      }
      if (T == List<int>) {
        if (payload.any((value) => value is! num)) return null;
        return payload
                .map((value) => (value as num).toInt())
                .toList(growable: false)
            as T;
      }
      if (T == List<double>) {
        if (payload.any((value) => value is! num)) return null;
        return payload
                .map((value) => (value as num).toDouble())
                .toList(growable: false)
            as T;
      }
      if (T == List<bool>) {
        if (payload.any((value) => value is! bool)) return null;
        return payload.cast<bool>().toList(growable: false) as T;
      }
    } on TypeError {
      return null;
    }
  }
  return payload is T ? payload as T : null;
}
