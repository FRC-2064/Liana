import 'package:control_board/layout/2025_layout.dart';
import 'package:control_board/layout/2026_layout.dart';
import 'package:control_board/services/liana.dart';
import 'package:control_board/utils/control_board_colors.dart';
import 'package:control_board/widgets/settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liana',
      home: const MyHomePage(title: 'Liana'),
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
  String _ip = '127.0.0.1';
  String _teamNumber = '2064';
  String _baseGifPath = 'assets/gifs';
  bool _isRobot = true;

  late final Liana _liana;

  void _openSettings() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => SettingsDialog(
        isRobot: _isRobot,
        teamNumber: _teamNumber,
        gifBasePath: _baseGifPath,
      ),
    );

    if (result != null) {
      setState(() {
        _ip = result['ip'];
        _teamNumber = result['teamNumber'];
        _isRobot = result['isRobot'];
        _baseGifPath = result['gifPath'];
      });
      _liana.getClient().setServerBaseAddress(_ip);
    }
  }

  @override
  void initState() {
    super.initState();
    _liana = Liana(serverBaseAddress: _ip);
  }

  @override
  Widget build(BuildContext context) {
    return Provider<Liana>(
      create: (_) => _liana,
      child: Scaffold(
        backgroundColor: ControlBoardColors.background,
        body: MainLayout(gifBasePath: _baseGifPath),
        floatingActionButton: FloatingActionButton(
          onPressed: _openSettings,
          backgroundColor: ControlBoardColors.cardBackground,
          child: Icon(
            Icons.settings,
            color: ControlBoardColors.statusSelected,
          ),
        ),
      ),
    );
  }
}
