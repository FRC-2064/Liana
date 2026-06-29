import 'package:flutter_test/flutter_test.dart';
import 'package:liana/layouts/2025/topics.dart';
import 'package:liana/layouts/2026/topics.dart';
import 'package:liana/layouts/example/topics.dart';
import 'package:liana/services/network_tables/nt_types.dart';

void main() {
  test('all migrated topics preserve legacy robot-visible paths', () {
    final contracts = <(String, String)>[
      (ReefscapeTopics.gameTime.path, 'Liana/Robot/GameTime'),
      (ReefscapeTopics.hasCoral.path, 'Liana/Robot/HasCoral'),
      (ReefscapeTopics.clamped.path, 'Liana/Robot/Clamped'),
      (ReefscapeTopics.availableAutos.path, 'Liana/Robot/Autos'),
      (ReefscapeTopics.selectedAuto.path, 'Liana/SelectedAuto'),
      (ReefscapeTopics.cage.path, 'Liana/Barge/Cage'),
      (ReefscapeTopics.feeder.path, 'Liana/Feeder'),
      (ReefscapeTopics.reefLevel.path, 'Liana/Reef/Level'),
      (ReefscapeTopics.scoreLocation.path, 'Liana/ScoreLocation'),
      (ReefscapeTopics.reefLocation.path, 'Liana/Reef/Location'),
      (PrototypeTopics.gameTime.path, 'Liana/Robot/GameTime'),
      (PrototypeTopics.atPosition.path, 'Liana/Robot/AtPosition'),
      (PrototypeTopics.hopperFull.path, 'Liana/Robot/HopperFull'),
      (PrototypeTopics.availableAutos.path, 'Liana/Robot/Autos'),
      (PrototypeTopics.selectedAuto.path, 'Liana/SelectedAuto'),
      (PrototypeTopics.hoodAngle.path, 'Liana/Robot/HoodAngle'),
      (PrototypeTopics.flywheelRpm.path, 'Liana/Robot/FlywheelRPM'),
      (PrototypeTopics.turretAngle.path, 'Liana/Robot/TurretAngle'),
      (ExampleTopics.matchTime.path, 'Liana/Example/MatchTime'),
      (ExampleTopics.robotReady.path, 'Liana/Example/RobotReady'),
      (ExampleTopics.hasGamePiece.path, 'Liana/Example/HasGamePiece'),
      (ExampleTopics.mechanismEnabled.path, 'Liana/Example/MechanismEnabled'),
      (ExampleTopics.shotOffset.path, 'Liana/Example/ShotOffset'),
      (ExampleTopics.scoringTarget.path, 'Liana/Example/ScoringTarget'),
      (ExampleTopics.intakeMode.path, 'Liana/Example/IntakeMode'),
    ];
    for (final (path, expected) in contracts) {
      expect(resolveNtTopicPath(path), expected);
    }
  });
}
