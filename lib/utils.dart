
class Utils {
  static Map<String, String> ntPosts = {
    'ReefLocation': 'ControlBoard/Reef/Location',
    'Level': 'ControlBoard/Reef/Level',
    'ScoreLocation': 'ControlBoard/ScoreLocation',
    'Feeder': 'ControlBoard/Feeder',
    'Cage': 'ControlBoard/Barge/Cage',
  };

  static Map<String, String> ntReads = {
    'Auto': 'ControlBoard/Robot/SelectedAuto',
    'HasScored': 'ControlBoard/Robot/HasScored',
    'HasAlgae': 'ControlBoard/Robot/HasAlgae',
    'HasCoral': 'ControlBoard/Robot/HasCoral',
    'Clamped': 'ControlBoard/Robot/Clamped',
    'Climbed': 'ControlBoard/Robot/Climbed'
  };

  static List<String> reefLocations = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
  ];

  static List<int> reefLevels = [
      1,
      2,
      3,
      4,
  ];

  static List<String> feederLocations = [
      'LEFT',
      'RIGHT',
  ];

  
  static List<String> cageLocations = [
      'LEFT',
      'CENTER',
      'RIGHT',
  ];

  static List<String> scoreLocations = [
      'REEF',
      'PROCESSOR',
  ];


}