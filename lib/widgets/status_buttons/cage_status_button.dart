import 'package:control_board/widgets/status_buttons/status_button.dart';
import 'package:flutter/material.dart';

import '../../utils/control_board_colors.dart';

class CageStatusButton extends StatusButton {
  const CageStatusButton(
      {super.key,
        required super.name,
        required super.setFunction,
        required super.listenable,
        required super.setVal});

  @override
  State<CageStatusButton> createState() => _CageStatusButtonState();
}

class _CageStatusButtonState extends State<CageStatusButton> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.listenable,
        builder: (context, snapshot) {
          bool isSelected = snapshot.data == widget.setVal;
          return Container(
            height: 50,
            width: 115,
            decoration: BoxDecoration(
              color: switch (snapshot.data) {
                null => ControlBoardColors.background,
                _ => isSelected
                    ? ControlBoardColors.statusSelected
                    : ControlBoardColors.statusUnselected,
              },
              borderRadius: BorderRadius.circular(10),
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
                  fontSize: 20,
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
