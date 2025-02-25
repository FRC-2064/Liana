import 'package:control_board/services/control_board.dart';
import 'package:control_board/utils.dart';
import 'package:control_board/widgets/bool_indicator.dart';
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
    return Center(
      child: Row(children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Coral Level'),
          // Coral Levels
          for (int level in Utils.reefLevels)
            TextButton(
              child: Text('Level $level'),
              onPressed: () => widget.controlBoard.setReefLevel(level),
            ),
        ]),
        Column(
          children: [
            Text('Reef Location'),
            // Reef Location
            for (String location in Utils.reefLocations)
              HexagonButton(
                name: location,
                setFunction: () => widget.controlBoard.setReefLocation(location),
                setVal: location,
                locationListenable: widget.controlBoard.reefLocation(),
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
                onPressed: () => widget.controlBoard.setCageLocation(location),
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
                onPressed: () => widget.controlBoard.setScoreLocation(location),
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
                onPressed: () => widget.controlBoard.setFeederLocation(location),
              )
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
        StreamBuilder(
          stream: widget.controlBoard.clock(),
          builder: (context, snapshot) {
            return Text(
              switch (snapshot.data) {
                null => '',
                '-1.0' => 'STOPPED',
                _ => snapshot.data!.toString()
              },
            );
          },
        )
      ]),
    );
  }
}
