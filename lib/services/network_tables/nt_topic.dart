final class NtTopic<T> {
  final String path;
  final T testValue;
  final double interval;

  const NtTopic({
    required this.path,
    required this.testValue,
    this.interval = 0.033,
  }) : assert(path != ''),
       assert(interval > 0);
}

final class NtValue<T> {
  final T? value;
  final bool hasValue;

  const NtValue.missing() : value = null, hasValue = false;
  const NtValue.present(T this.value) : hasValue = true;

  @override
  bool operator ==(Object other) {
    return other is NtValue<T> &&
        other.hasValue == hasValue &&
        other.value == value;
  }

  @override
  int get hashCode => Object.hash(value, hasValue);
}
