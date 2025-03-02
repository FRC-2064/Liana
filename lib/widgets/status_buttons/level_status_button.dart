import 'package:control_board/widgets/status_buttons/status_button.dart';
import 'package:flutter/material.dart';

import '../../utils/control_board_colors.dart';

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
          return Container(
              height: 75,
              width: 150,
              decoration: BoxDecoration(
                color: switch (snapshot.data) {
                  null => ControlBoardColors.background,
                  _ => isSelected
                      ? ControlBoardColors.statusSelected
                      : ControlBoardColors.statusUnselected,
                },
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  width: 4,
                  color: ControlBoardColors.border,
                )
              ),
              child: TextButton(
              onPressed: widget.setFunction,
              child: Text(
              widget.name,
              style: TextStyle(
                fontSize: isSelected
                    ? 24
                    : 20,
                fontWeight: FontWeight.bold,
                color: switch (snapshot.data) {
                  null => ControlBoardColors.missing,
                  _ => isSelected
                      ? ControlBoardColors.background
                      : ControlBoardColors.buttonText,
                },
              ),
              textAlign: TextAlign.center,
            ),
            ),
          );
        });
  }
}
