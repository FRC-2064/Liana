import 'package:control_board/layout/2025_layout.dart';
import 'package:control_board/layout/example_layout.dart';
import 'package:control_board/layout/hex_stack_layout.dart';
import 'package:control_board/utils/controlboard_colors.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
      
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ControlBoardColors.background,
      body: ExampleLayout(
        serverAddress: '127.0.0.1',
      ),
    );
  }
}

