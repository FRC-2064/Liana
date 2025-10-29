import 'package:liana/utils/liana_colors.dart';
import 'package:liana/widgets/network_tables/button_builders/nt_button_builder.dart';
import 'package:flutter/material.dart';

/// a [NtButtonBuilder] that draws a rectangle.
class RectangleBuilder extends NtButtonBuilder {
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;

  const RectangleBuilder({
    this.borderRadius = 10.0,
    this.borderWidth = 4.0,
    this.borderColor = LianaColors.border,
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
