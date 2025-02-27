import 'package:control_board/widgets/status_button.dart';
import 'package:flutter/material.dart';

import '../utils/controlboard_colors.dart';

class LevelStatusButton extends StatusButton {
  const LevelStatusButton(
      {super.key,
      required super.name,
      required super.setFunction,
      required super.listenable,
      required super.setVal});

  @override
  State<LevelStatusButton> createState() => _LevelStatusButtonState();
}

class _LevelStatusButtonState extends State<LevelStatusButton> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.listenable,
        builder: (context, snapshot) {
          bool isSelected = snapshot.data == widget.setVal;
          return Card(
            color: switch (snapshot.data) {
              null => ControlBoardColors.missing,
              _ => isSelected ? ControlBoardColors.statusSelected : ControlBoardColors.statusUnselected,
            },
            child: TextButton(
                onPressed: widget.setFunction, child: Text(
              widget.name,
              style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ControlBoardColors.buttonText,
            ),
              textAlign: TextAlign.center,)),
          );
        });
  }
}
