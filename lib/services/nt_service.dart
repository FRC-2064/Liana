import 'dart:async';
import 'package:nt4/nt4.dart';

class NTService {
  static NTService? _instance;
  late NT4Client client;
  final String ip;
  bool _isConnected = false;
  int _retryCount = 0;
  final int maxRetries = 10;
  final Duration baseRetryDelay = const Duration(seconds: 2);

  NTService._internal(this.ip) {
    _attemptConnection();
  }

  static NTService getInstance(String ip) {
    _instance ??= NTService._internal(ip);
    return _instance!;
  }

  void _attemptConnection() {
    client = NT4Client(
      serverBaseAddress: ip,
      onConnect: () {
        print('Connected to $ip');
        _isConnected = true;
        _retryCount = 0; // Reset retries on success
      },
      onDisconnect: () {
        print('Disconnected from $ip');
        _isConnected = false;
        _scheduleReconnect();
      },
    );
  }

  void _scheduleReconnect() {
    if (_isConnected) return;

    _retryCount++;
    int delaySeconds = (baseRetryDelay.inSeconds * _retryCount).clamp(2, 30);
    Duration retryDelay = Duration(seconds: delaySeconds);

    print('Reconnecting in ${retryDelay.inSeconds} seconds...');
    Future.delayed(retryDelay, () {
      if (!_isConnected) {
        _attemptConnection();
      }
    });
  }

  NT4Topic createNTValue(String ntPath, String type) {
    return client.publishNewTopic(ntPath, type);
  }

  void postValue(NT4Topic topic, dynamic value) {
    client.addSample(topic, value);
  }
}
