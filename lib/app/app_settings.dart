import 'package:liana/utils/liana_connection_mode.dart';

final class AppSettings {
  static const int defaultTeamNumber = 2064;
  static const String defaultGifBasePath = 'assets/gifs';
  static const String defaultLayoutId = 'reefscape-2025';

  final int teamNumber;
  final LianaConnectionMode mode;
  final String gifBasePath;
  final String layoutId;

  const AppSettings({
    this.teamNumber = defaultTeamNumber,
    this.mode = LianaConnectionMode.robot,
    this.gifBasePath = defaultGifBasePath,
    this.layoutId = defaultLayoutId,
  }) : assert(teamNumber > 0 && teamNumber ~/ 100 <= 255),
       assert(gifBasePath != ''),
       assert(layoutId != '');

  static bool isValidTeamNumber(int? teamNumber) {
    if (teamNumber == null || teamNumber <= 0) return false;
    return teamNumber ~/ 100 <= 255 && teamNumber % 100 <= 255;
  }

  static String robotAddressForTeam(int teamNumber) {
    if (!isValidTeamNumber(teamNumber)) {
      throw ArgumentError.value(
        teamNumber,
        'teamNumber',
        'Invalid FRC team number',
      );
    }
    return '10.${teamNumber ~/ 100}.${teamNumber % 100}.2';
  }

  String? get serverAddress => switch (mode) {
    LianaConnectionMode.robot => robotAddressForTeam(teamNumber),
    LianaConnectionMode.simulation => '127.0.0.1',
    LianaConnectionMode.uiTest => null,
  };

  AppSettings copyWith({
    int? teamNumber,
    LianaConnectionMode? mode,
    String? gifBasePath,
    String? layoutId,
  }) {
    return AppSettings(
      teamNumber: teamNumber ?? this.teamNumber,
      mode: mode ?? this.mode,
      gifBasePath: gifBasePath ?? this.gifBasePath,
      layoutId: layoutId ?? this.layoutId,
    );
  }

  Map<String, Object> toJson() => {
    'teamNumber': teamNumber,
    'mode': mode.name,
    'gifBasePath': gifBasePath,
    'layoutId': layoutId,
  };

  factory AppSettings.fromJson(Map<String, Object?> json) {
    final rawTeam = json['teamNumber'];
    final parsedTeam = rawTeam is int
        ? rawTeam
        : rawTeam is String
        ? int.tryParse(rawTeam)
        : null;
    final modeName = json['mode'];
    final parsedMode = modeName is String
        ? LianaConnectionMode.values
              .where((value) => value.name == modeName)
              .firstOrNull
        : null;
    final gifPath = json['gifBasePath'];
    final layoutId = json['layoutId'];

    return AppSettings(
      teamNumber: isValidTeamNumber(parsedTeam)
          ? parsedTeam!
          : defaultTeamNumber,
      mode: parsedMode ?? LianaConnectionMode.robot,
      gifBasePath: gifPath is String && gifPath.trim().isNotEmpty
          ? gifPath
          : defaultGifBasePath,
      layoutId: layoutId is String && layoutId.trim().isNotEmpty
          ? layoutId
          : defaultLayoutId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AppSettings &&
        other.teamNumber == teamNumber &&
        other.mode == mode &&
        other.gifBasePath == gifBasePath &&
        other.layoutId == layoutId;
  }

  @override
  int get hashCode => Object.hash(teamNumber, mode, gifBasePath, layoutId);
}
