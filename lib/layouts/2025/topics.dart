import 'package:liana/layouts/2025/values.dart';
import 'package:liana/services/network_tables/nt_topic.dart';

abstract final class ReefscapeTopics {
  static const gameTime = NtTopic<double>(
    path: '/Robot/GameTime',
    testValue: 135,
  );
  static const hasCoral = NtTopic<bool>(
    path: '/Robot/HasCoral',
    testValue: false,
  );
  static const clamped = NtTopic<bool>(
    path: '/Robot/Clamped',
    testValue: false,
  );
  static const availableAutos = NtTopic<List<String>>(
    path: 'Robot/Autos',
    testValue: ReefscapeValues.autoList,
  );
  static const selectedAuto = NtTopic<String>(
    path: 'SelectedAuto',
    testValue: 'Left Start',
  );
  static const cage = NtTopic<String>(path: 'Barge/Cage', testValue: 'LEFT');
  static const feeder = NtTopic<String>(path: 'Feeder', testValue: 'LEFT');
  static const reefLevel = NtTopic<int>(path: 'Reef/Level', testValue: 3);
  static const scoreLocation = NtTopic<String>(
    path: 'ScoreLocation',
    testValue: 'REEF',
  );
  static const reefLocation = NtTopic<String>(
    path: 'Reef/Location',
    testValue: 'L',
  );
}
