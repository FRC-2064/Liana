import 'package:liana/services/nt_entry.dart';
import 'package:liana/services/nt_factory.dart';
import 'package:nt4/nt4.dart';

/// Base class that stores the NT4 client and sets the prefix for all
/// NT4 Topics for the 'Liana' control board.
///
/// All topics are prefixed with '/Liana/' to keep them organized and
/// easily identifiable within the NT.
///
/// This takes in a serverBaseAddress as 'String' to create the NT4 client.
class Liana {
  late NT4Client _client;
  late NtFactory _factory;
  bool _isConnected = false;

  Liana({required String serverBaseAddress}) {
    _client = NT4Client(
        serverBaseAddress: serverBaseAddress,
        onConnect: () => _isConnected = true,
        onDisconnect: () => _isConnected = false);
    _factory = NtFactory(_client);
  }

  NT4Client getClient() => _client;
  String getServerAddress() => _client.serverBaseAddress;
  Stream<bool> connectionStatus() => _client.connectionStatusStream();
  bool get isConnected => _isConnected;

  NtEntry<T> getEntry<T>(
    String name, {
    required T defaultValue,
    double? interval,
  }) {
    return _factory.getEntry<T>(name,
        defaultValue: defaultValue, interval: interval);
  }
}
