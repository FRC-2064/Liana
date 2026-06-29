import 'package:liana/layouts/example/values.dart';
import 'package:liana/services/network_tables/nt_topic.dart';

/// Typed topic declarations for this layout.
///
/// `testValue` seeds UI Test and declares wire type. Live NT4 sessions stay
/// missing until robot data or a local write arrives.
abstract final class ExampleTopics {
  static const matchTime = NtTopic<double>(
    path: 'Example/MatchTime',
    testValue: 135,
  );
  static const robotReady = NtTopic<bool>(
    path: 'Example/RobotReady',
    testValue: true,
  );
  static const hasGamePiece = NtTopic<bool>(
    path: 'Example/HasGamePiece',
    testValue: false,
  );
  static const mechanismEnabled = NtTopic<bool>(
    path: 'Example/MechanismEnabled',
    testValue: false,
  );
  static const shotOffset = NtTopic<double>(
    path: 'Example/ShotOffset',
    testValue: ExampleValues.offsetDefault,
  );
  static const scoringTarget = NtTopic<String>(
    path: 'Example/ScoringTarget',
    testValue: ExampleValues.targetCenter,
  );
  static const intakeMode = NtTopic<String>(
    path: 'Example/IntakeMode',
    testValue: ExampleValues.intakeOff,
  );
}
