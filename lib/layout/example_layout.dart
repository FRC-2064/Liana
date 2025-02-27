import 'package:control_board/utils/controlboard_colors.dart';
import 'package:flutter/material.dart';

import '../services/control_board.dart';
import '../utils/value_lists.dart';
import '../widgets/bool_indicator.dart';
import '../widgets/hexagon_stack.dart';
import '../widgets/status_button.dart';
import '../widgets/timer.dart';

class ExampleLayout extends StatefulWidget {
  final ControlBoard controlBoard;

  ExampleLayout({super.key, required String serverAddress})
      : controlBoard = ControlBoard(serverBaseAddress: serverAddress);

  @override
  State<ExampleLayout> createState() => _ExampleLayoutState();
}

class _ExampleLayoutState extends State<ExampleLayout> {
  final List<String> autoList = ['bigbrain3', 'Auto2', 'Auto3'];
  String? selectedAuto;

  @override
  void initState() {
    super.initState();
    selectedAuto = autoList.first;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ControlBoardColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Column 1: Timer, Bool Indicators, Dropdown & GIF Player
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timer at the top left
                  Timer(timeListenable: widget.controlBoard.clock()),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      BoolIndicator(
                        name: 'has Algae',
                        boolListenable: widget.controlBoard.hasAlgae(),
                      ),
                      const SizedBox(width: 2),
                      BoolIndicator(
                        name: 'has Coral',
                        boolListenable: widget.controlBoard.hasCoral(),
                      ),
                      const SizedBox(width: 2),
                      BoolIndicator(
                        name: 'Clamped',
                        boolListenable: widget.controlBoard.hasClamped(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: selectedAuto,
                    dropdownColor: ControlBoardColors.cardBackground,
                    style: TextStyle(color: ControlBoardColors.buttonText),
                    onChanged: (value) {
                      setState(() {
                        selectedAuto = value;
                      });
                    },
                    items: autoList
                        .map(
                          (auto) => DropdownMenuItem(
                        value: auto,
                        child: Text(auto),
                      ),
                    )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/gifs/$selectedAuto.gif',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/gifs/default.gif',
                            fit: BoxFit.contain,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Column 2: Cage Settings (in a row), Hexagon, Feeders
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Cage',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ControlBoardColors.buttonText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (String location in ValueLists.cageLocations)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: StatusButton(
                            name: location,
                            setFunction: () =>
                                widget.controlBoard.setCageLocation(location),
                            listenable: widget.controlBoard.cageLocation(),
                            setVal: location,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Center(
                      child: HexagonStack(
                        controlBoard: widget.controlBoard,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (String location in ValueLists.feederLocations)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: StatusButton(
                            name: location,
                            setFunction: () =>
                                widget.controlBoard.setFeederLocation(location),
                            listenable: widget.controlBoard.feederLocation(),
                            setVal: location,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Column 3: Level selection
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Level',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ControlBoardColors.buttonText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      for (int level in ValueLists.reefLevels)
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: StatusButton(
                            name: switch (level) {
                              0 => 'Remove Algae',
                              1 => 'Level 1 (Trough)',
                              _ => 'Level $level',
                            },
                            setFunction: () => widget.controlBoard.setReefLevel(level),
                            listenable: widget.controlBoard.reefLevel(),
                            setVal: level)
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}