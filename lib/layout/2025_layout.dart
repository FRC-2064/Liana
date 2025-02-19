import 'package:control_board/services/control_board.dart';
import 'package:control_board/utils.dart';
import 'package:control_board/widgets/bool_indicator.dart';
import 'package:flutter/material.dart';
import 'package:control_board/widgets/hexagon_button.dart';

class MainLayout extends StatelessWidget {
  final ControlBoard controlBoard;

  MainLayout({super.key, required String serverAddress})
      : controlBoard = ControlBoard(serverBaseAddress: serverAddress);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Coral Level'),
          // Coral Levels
          for (int level in Utils.reefLevels)
            TextButton(
              child: Text('Level $level'),
              onPressed: () => controlBoard.setReefLevel(level),
            ),
        ]),
        Column(
          children: [
            Text('Reef Location'),
            // Reef Location
            for (String location in Utils.reefLocations)
              HexagonButton(
                  name: location,
                  setFunction: () => controlBoard.setReefLocation(location),
              setVal: location,
              locationListenable: controlBoard.reefLocation(),
                key: Key(location),
              )
          ],
        ),
        Column(
          children: [
            Text('Cage Location'),
            // Test button
            for (String location in Utils.cageLocations)
              TextButton(
                child: Text('Cage $location'),
                onPressed: () => controlBoard.setCageLocation(location),
              )
          ],
        ),
        Column(
          children: [
            Text('Score Location'),
            // Test button
            for (String location in Utils.scoreLocations)
              TextButton(
                child: Text('Score $location'),
                onPressed: () => controlBoard.setScoreLocation(location),
              )
          ],
        ),
        Column(
          children: [
            Text('Feeder Location'),
            // Test button
            for (String location in Utils.feederLocations)
              TextButton(
                child: Text('Feeder $location'),
                onPressed: () => controlBoard.setFeederLocation(location),
              )
          ],
        ),
        Column(
          children: [
            BoolIndicator(
              name: 'has Algae',
              boolListenable: controlBoard.hasAlgae(),
              
            ),
            BoolIndicator(
              name: 'has Coral',
              boolListenable: controlBoard.hasCoral(),
            ),
            BoolIndicator(
              name: 'Clamped',
              boolListenable: controlBoard.hasClamped(),
            ),
          ],
        )
      ]),
    );
  }
}
