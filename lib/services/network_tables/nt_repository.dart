import 'package:liana/services/network_tables/nt_entry.dart';
import 'package:liana/services/network_tables/nt_topic.dart';

abstract interface class NtRepository {
  NtEntry<T> entry<T>(NtTopic<T> topic);
  Stream<bool> get connectionStatus;
  bool get isConnected;
  String? get serverAddress;
  void dispose();
}
