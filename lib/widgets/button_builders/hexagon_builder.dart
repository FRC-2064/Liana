import 'package:control_board/utils/control_board_colors.dart';
import 'package:control_board/widgets/button_builders/nt_button_builder.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class HexagonBuilder extends NtButtonBuilder {
  final double borderWidth;
  final Color borderColor;

  const HexagonBuilder({
    this.borderWidth = 3.0,
    this.borderColor = ControlBoardColors.border,
  });

  @override
  Widget build(BuildContext context, bool isSelected, Color backgroundColor,
      VoidCallback onPress, Widget child) {
    return CustomPaint(
      painter: HexagonPainter(
        color: backgroundColor,
        borderColor: borderColor,
        borderWidth: borderWidth,
      ),
      child: SizedBox.expand(
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            shape: const CircleBorder(),
          ),
          onPressed: onPress,
          child: child,
        ),
      ),
    );
  }
}

class HexagonPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;

  HexagonPainter({
    required this.color,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final path = _createHexagonPath(size);
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  Path _createHexagonPath(Size size) {
    final double w = size.width;
    final double h = size.height;
    final double centerX = w / 2;
    final double centerY = h / 2;
    final double radius = min(w, h) / 2 - (borderWidth / 2);
    final Path path = Path();
    for (int i = 0; i < 6; i++) {
      final double angle = (pi / 3 * i);
      final double x = centerX + radius * cos(angle);
      final double y = centerY + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(HexagonPainter oldDelegate) {
    return color != oldDelegate.color ||
        borderColor != oldDelegate.borderColor ||
        borderWidth != oldDelegate.borderWidth;
  }
}
