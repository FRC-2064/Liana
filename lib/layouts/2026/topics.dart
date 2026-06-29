import 'package:liana/layouts/2026/values.dart';
import 'package:liana/services/network_tables/nt_topic.dart';

abstract final class PrototypeTopics {
  static const gameTime = NtTopic<double>(
    path: 'Robot/GameTime',
    testValue: 135,
  );
  static const atPosition = NtTopic<bool>(
    path: 'Robot/AtPosition',
    testValue: false,
  );
  static const hopperFull = NtTopic<bool>(
    path: 'Robot/HopperFull',
    testValue: false,
  );
  static const availableAutos = NtTopic<List<String>>(
    path: 'Robot/Autos',
    testValue: PrototypeValues.autoList,
  );
  static const selectedAuto = NtTopic<String>(
    path: 'SelectedAuto',
    testValue: 'pathplanner',
  );
  static const hoodAngle = NtTopic<double>(
    path: 'Robot/HoodAngle',
    testValue: 0,
  );
  static const flywheelRpm = NtTopic<double>(
    path: 'Robot/FlywheelRPM',
    testValue: 0,
  );
  static const turretAngle = NtTopic<double>(
    path: 'Robot/TurretAngle',
    testValue: 0,
  );
}
