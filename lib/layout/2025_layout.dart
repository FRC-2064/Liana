import 'package:control_board/services/control_board.dart';
import 'package:control_board/utils/value_lists.dart';
import 'package:control_board/widgets/bool_indicator.dart';
import 'package:control_board/widgets/hexagon_stack.dart';
import 'package:control_board/widgets/selected_auto.dart';
import 'package:control_board/widgets/status_buttons/cage_status_button.dart';
import 'package:control_board/widgets/status_buttons/feeder_status_button.dart';
import 'package:control_board/widgets/status_buttons/level_status_button.dart';
import 'package:control_board/widgets/timer.dart';
import 'package:flutter/material.dart';

import '../utils/control_board_colors.dart';

class MainLayout extends StatefulWidget {
  final ControlBoard controlBoard;

  const MainLayout({super.key, required this.controlBoard});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  String? selectedAuto;

  @override
  void initState() {
    super.initState();
    selectedAuto = ValueLists.autoList.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ControlBoardColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Column 1: Timer, Bool Indicators, Dropdown & GIF Player
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Timer(timeListenable: widget.controlBoard.clock()),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BoolIndicator(
                        name: 'Algae',
                        boolListenable: widget.controlBoard.hasAlgae(),
                      ),
                      const SizedBox(width: 2),
                      BoolIndicator(
                        name: 'Coral',
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
                  SelectedAuto(
                      setFunction: (a) => widget.controlBoard.setAuto(a)),
                  const SizedBox(height: 16),
                  StreamBuilder(
                      stream: widget.controlBoard.selectedAuto(),
                      builder: (context, snapshot) {
                        selectedAuto = snapshot.data;
                        String assetString = switch (selectedAuto) {
                          null => 'assets/gifs/default.gif',
                          _ => 'assets/gifs/$selectedAuto.gif'
                        };
                        return Expanded(
                          child: Center(
                            child: Image.asset(
                              assetString,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/gifs/default.gif',
                                  fit: BoxFit.contain,
                                );
                              },
                            ),
                          ),
                        );
                      }),
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
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: ControlBoardColors.headerText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (String location in ValueLists.cageLocations)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: CageStatusButton(
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
                  Text(
                    'Feeder',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: ControlBoardColors.headerText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (String location in ValueLists.feederLocations)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: FeederStatusButton(
                            name: location,
                            setFunction: () =>
                                widget.controlBoard.setFeederLocation(location),
                            listenable: widget.controlBoard.feederLocation(),
                            setVal: location,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 50),
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
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: ControlBoardColors.headerText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      for (int level in ValueLists.reefLevels)
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: LevelStatusButton(
                                name: switch (level) {
                                  0 => 'Remove Algae',
                                  1 => 'Level 1 (Trough)',
                                  _ => 'Level $level',
                                },
                                setFunction: () =>
                                    widget.controlBoard.setReefLevel(level),
                                listenable: widget.controlBoard.reefLevel(),
                                setVal: level)),
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
