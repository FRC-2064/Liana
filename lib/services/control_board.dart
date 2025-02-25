
import 'package:nt4/nt4.dart';

class ControlBoard {
  late NT4Client _client;

  late NT4Subscription _clock;
  late NT4Subscription _hasCoral;
  late NT4Subscription _hasAlgae;
  late NT4Subscription _hasScored;
  late NT4Subscription _clamped;
  late NT4Subscription _selectedAuto;
  late NT4Subscription _reefLocationSub;

  late NT4Topic _reefLocation;
  late NT4Topic _reefLevel;
  late NT4Topic _cageLocation;
  late NT4Topic _feederLocation;
  late NT4Topic _scoreLocation;

  bool _isConnected = false;

  static const subscriberInterval = 0.033;

  ControlBoard({required String serverBaseAddress}) {
    _client = NT4Client(
      serverBaseAddress: serverBaseAddress,
      onConnect: () => _isConnected = true,
      onDisconnect: () => _isConnected = false);

      _clock = _client.subscribePeriodic('/ControlBoard/GameTime', subscriberInterval);
      _hasCoral = _client.subscribePeriodic('/ControlBoard/Robot/HasCoral', subscriberInterval);
      _hasAlgae = _client.subscribePeriodic('/ControlBoard/Robot/HasAlgae', subscriberInterval);
      _hasScored = _client.subscribePeriodic('/ControlBoard/Robot/HasScored', subscriberInterval);
      _clamped = _client.subscribePeriodic('/ControlBoard/Robot/Clamped', subscriberInterval);
      _selectedAuto = _client.subscribePeriodic('/ControlBoard/Robot/SelectedAuto', subscriberInterval);
      _reefLocationSub = _client.subscribePeriodic('/ControlBoard/Reef/Location', subscriberInterval);

      _reefLocation = _client.publishNewTopic('/ControlBoard/Reef/Location', NT4TypeStr.typeStr);
      _reefLevel = _client.publishNewTopic('/ControlBoard/Reef/Level', NT4TypeStr.typeInt);
      _cageLocation = _client.publishNewTopic('/ControlBoard/Barge/Cage', NT4TypeStr.typeStr);
      _feederLocation = _client.publishNewTopic('/ControlBoard/Feeder', NT4TypeStr.typeStr);
      _scoreLocation = _client.publishNewTopic('/ControlBoard/ScoreLocation', NT4TypeStr.typeStr);
  }

  void setServerAddress(String serverAddress) {
    _client.setServerBaseAddress(serverAddress);
  }

  NT4Client getClient() {
    return _client;
  }

  String getServerAddress() {
    return _client.serverBaseAddress;
  }

  void setReefLocation(String rl) {
    _client.addSample(_reefLocation, rl);
  }

  void setReefLevel(int rl) {
    _client.addSample(_reefLevel, rl);
  }

  void setCageLocation(String cl) {
    _client.addSample(_cageLocation, cl);
  }

  void setFeederLocation(String fl) {
    _client.addSample(_feederLocation, fl);
  }

  void setScoreLocation(String sl) {
    _client.addSample(_scoreLocation, sl);
  }
  
  Stream<bool> hasClamped() {
    return _clamped.stream().map((clamped) => clamped as bool);
  } 
  
  Stream<bool> hasAlgae() {
    return _hasAlgae.stream().map((clamped) => clamped is bool);
  } 

    Stream<bool> hasCoral() {
    return _hasCoral.stream().map((clamped) => clamped is bool);
  } 

    Stream<bool> hasScored() {
    return _hasScored.stream().map((clamped) => clamped is bool);
  }

  Stream<String> clock() {
    return _clock.stream().map((time) => time.toString());
  }

  Stream<String> selectedAuto() {
    return _selectedAuto.stream().map((auto) => auto as String);
  }

  Stream<String> reefLocation() {
    return _reefLocationSub.stream().map((loc) => loc as String);
  }


  Stream<bool> connectionStatus() {
    return _client.connectionStatusStream();
  }

  bool get isConnected => _isConnected;

}