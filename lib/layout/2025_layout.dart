import 'package:control_board/services/control_board.dart';
import 'package:control_board/utils/value_lists.dart';
import 'package:control_board/widgets/bool_indicator.dart';
import 'package:control_board/widgets/hexagon_stack.dart';
import 'package:control_board/widgets/status_button.dart';
import 'package:control_board/widgets/timer.dart';
import 'package:flutter/material.dart';
import 'package:control_board/widgets/hexagon_button.dart';

class MainLayout extends StatefulWidget {
  final ControlBoard controlBoard;

  MainLayout({super.key, required String serverAddress})
      : controlBoard = ControlBoard(serverBaseAddress: serverAddress);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return Row(
          children: [

        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Timer(timeListenable: widget.controlBoard.clock()),
          // Coral Levels
          for (int level in ValueLists.reefLevels)
            StatusButton(
                name: switch (level) {
                  0 => 'Remove Algae',
                  1 => 'Level 1 (Trough)',
                  _ => 'Level $level',
                },
                setFunction: () => widget.controlBoard.setReefLevel(level),
                listenable: widget.controlBoard.reefLevel(),
                setVal: level)
        ]
        ),
            // Reef Location
            HexagonStack(controlBoard: widget.controlBoard),

        Column(
          children: [
            // Test button
            for (String location in ValueLists.cageLocations)
              StatusButton(
                  name: location,
                  setFunction: () => widget.controlBoard.setCageLocation(location),
                  listenable: widget.controlBoard.cageLocation(),
                  setVal: location)
          ],
        ),
        Column(
          children: [
            // Test button
            for (String location in ValueLists.scoreLocations)
              StatusButton(
                  name: location,
                  setFunction: () => widget.controlBoard.setScoreLocation(location),
                  listenable: widget.controlBoard.scoreLocation(),
                  setVal: location)
          ],
        ),
        Column(
          children: [
            // Test button
            for (String location in ValueLists.feederLocations)
              StatusButton(
                  name: location,
                  setFunction: () => widget.controlBoard.setFeederLocation(location),
                  listenable: widget.controlBoard.feederLocation(),
                  setVal: location)
          ],
        ),
        Column(
          children: [
            BoolIndicator(
              name: 'has Algae',
              boolListenable: widget.controlBoard.hasAlgae(),
            ),
            BoolIndicator(
              name: 'has Coral',
              boolListenable: widget.controlBoard.hasCoral(),
            ),
            BoolIndicator(
              name: 'Clamped',
              boolListenable: widget.controlBoard.hasClamped(),
            ),
          ],
        ),
      ]);
  }
}
