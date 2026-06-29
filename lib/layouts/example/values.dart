/// Robot-visible values and tuning constants used by the student example.
///
/// Keep values here immutable so layout code stays focused on composition.
abstract final class ExampleValues {
  static const targetLeft = 'LEFT';
  static const targetCenter = 'CENTER';
  static const targetRight = 'RIGHT';
  static const targets = <String>[targetLeft, targetCenter, targetRight];

  static const intakeOff = 'OFF';
  static const intakeCollect = 'COLLECT';
  static const intakeEject = 'EJECT';
  static const intakeModes = <String>[intakeOff, intakeCollect, intakeEject];

  static const offsetDefault = 0.0;
  static const offsetIncrement = 0.5;
  static const offsetMin = -10.0;
  static const offsetMax = 10.0;
}
