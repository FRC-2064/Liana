import 'package:flutter/material.dart';

import '../utils/controlboard_colors.dart';

class BoolIndicator extends StatefulWidget {
  const BoolIndicator(
      {super.key, required this.name, required this.boolListenable});
  final String name;
  final Stream<bool> boolListenable;
  @override
  State<BoolIndicator> createState() => _BoolIndicatorState();
}

class _BoolIndicatorState extends State<BoolIndicator> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.boolListenable,
      builder: (context, snapshot) => Padding(
        padding: const EdgeInsets.all(8.0), // Padding around the Card
        child: Card(
          color: ControlBoardColors.cardBackground, // Set background color
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ControlBoardColors.buttonText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10), // Space between text and box
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: switch (snapshot.data) {
                      true => ControlBoardColors.boolTrue,
                      false => ControlBoardColors.boolFalse,
                      null => ControlBoardColors.missing,
                    },
                    borderRadius: BorderRadius.circular(8), // Optional rounded edges
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
