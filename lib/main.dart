import 'package:control_board/layout/2025_layout.dart';
import 'package:flutter/material.dart';
import 'package:control_board/services/nt_service.dart';
import 'package:nt4/nt4.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control Board',
      home: const MyHomePage(title: 'Control Board'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final NTService client = NTService.getInstance('10.20.64.2');
  late Map<String, NT4Topic> ntTopics;

  @override
  void initState() {
    super.initState();
    ntTopics = {
      'Level': client.createNTValue("Dashboard/ControlBoard/Reef/Level", NT4TypeStr.typeInt),
      'Auto': client.createNTValue("Dashboard/ControlBoard/Robot/SelectedAuto", NT4TypeStr.typeStr),
      'Cage': client.createNTValue("Dashboard/ControlBoard/Barge/Cage", NT4TypeStr.typeStr),
      'Feeder': client.createNTValue("Dashboard/ControlBoard/Feeder", NT4TypeStr.typeStr),
      'ScoreLocation': client.createNTValue("Dashboard/ControlBoard/ScoreLocation", NT4TypeStr.typeStr),
      'HasScored': client.createNTValue('Dashboard/ControlBoard/RobotHasScored', NT4TypeStr.typeBool),
      'HasAlgae': client.createNTValue('Dashboard/ControlBoard/Robot/HasAlgae', NT4TypeStr.typeBool),
      'HasCoral': client.createNTValue('Dashboard/ControlBoard/Robot/HasCoral', NT4TypeStr.typeBool),
      'Clamped': client.createNTValue('Dashboard/ControlBoard/Robot/Clamped', NT4TypeStr.typeBool),
      'Climbed': client.createNTValue('Dashboard/ControlBoard/Robot/IsClimbed', NT4TypeStr.typeBool)
    };
      
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: MainLayout(client: client, ntTopics: ntTopics),
    );
  }
}
