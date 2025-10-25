import 'package:control_board/utils/control_board_colors.dart';
import 'package:control_board/widgets/button_builders/nt_button_builder.dart';
import 'package:flutter/material.dart';

class RectangleBuilder extends NtButtonBuilder {
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;

  const RectangleBuilder({
    this.borderRadius = 10.0,
    this.borderWidth = 4.0,
    this.borderColor = ControlBoardColors.border,
  });

  @override
  Widget build(
    BuildContext context,
    bool isSelected,
    Color backgroundColor,
    VoidCallback onPress,
    Widget child,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          width: borderWidth,
          color: borderColor,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: TextButton(
          onPressed: onPress,
          child: child,
        ),
      ),
    );
  }
}
