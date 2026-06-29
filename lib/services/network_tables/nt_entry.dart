import 'package:liana/services/network_tables/nt_topic.dart';

abstract interface class NtEntry<T> {
  NtValue<T> get current;
  Stream<NtValue<T>> get values;
  void set(T value);
}
