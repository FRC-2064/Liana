import 'package:liana/utils/liana_colors.dart';
import 'package:liana/widgets/network_tables/button_builders/nt_button_builder.dart';
import 'package:flutter/material.dart';

/// a [NtButtonBuilder] that draws a rectangle.
class RectangleBuilder extends NtButtonBuilder {
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;

  const RectangleBuilder({
    this.borderRadius = 16.0,
    this.borderWidth = 1.5,
    this.borderColor = LianaColors.border,
  });

  @override
  Widget build(
    BuildContext context, {
    required bool isSelected,
    required bool isMissing,
    required Color backgroundColor,
    required VoidCallback onPressed,
    required Widget child,
  }) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        hoverColor: LianaColors.primary.withValues(alpha: 0.08),
        splashColor: LianaColors.primary.withValues(alpha: 0.16),
        highlightColor: LianaColors.primary.withValues(alpha: 0.12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              width: borderWidth,
              color: isSelected ? Colors.transparent : borderColor,
            ),
          ),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
