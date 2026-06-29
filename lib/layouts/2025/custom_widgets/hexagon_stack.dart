import 'dart:math';

import 'package:flutter/material.dart';
import 'package:liana/utils/liana_colors.dart';

/// Presentation-only geometry for twelve already-built option widgets.
class HexagonButtonLayout extends StatelessWidget {
  final List<Widget> children;
  final double scale;

  const HexagonButtonLayout({
    required this.children,
    this.scale = 0.75,
    super.key,
  }) : assert(children.length == 12);

  @override
  Widget build(BuildContext context) {
    final centerRadius = 200 * scale;
    final outerRadius = 50 * scale * 1.25;
    final hexHeight = outerRadius * 1.75;
    final distance =
        (centerRadius + outerRadius * 0.25) * 0.96 + outerRadius * 0.5;
    final margin = outerRadius * 0.5;
    final centers = List.generate(12, (index) {
      final angle = 135 * pi / 180 + index * (2 * pi / 12);
      return Offset(distance * cos(angle), distance * sin(angle));
    });

    var minX = -centerRadius;
    var maxX = centerRadius;
    var minY = -centerRadius;
    var maxY = centerRadius;
    for (final center in centers) {
      minX = min(minX, center.dx - outerRadius);
      maxX = max(maxX, center.dx + outerRadius);
      minY = min(minY, center.dy - hexHeight / 2);
      maxY = max(maxY, center.dy + hexHeight / 2);
    }
    minX -= margin;
    maxX += margin;
    minY -= margin;
    maxY += margin;
    final origin = Offset(-minX, -minY);

    return SizedBox(
      width: maxX - minX,
      height: maxY - minY,
      child: Stack(
        children: [
          Positioned(
            left: origin.dx - centerRadius,
            top: origin.dy - centerRadius,
            child: CustomPaint(
              painter: const LargeHexagonPainter(),
              child: SizedBox.square(dimension: centerRadius * 2),
            ),
          ),
          for (var index = 0; index < children.length; index++)
            Positioned(
              left: origin.dx + centers[index].dx - outerRadius,
              top: origin.dy + centers[index].dy - hexHeight / 2,
              width: outerRadius * 2,
              height: hexHeight,
              child: children[index],
            ),
        ],
      ),
    );
  }
}

class LargeHexagonPainter extends CustomPainter {
  const LargeHexagonPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    for (var index = 0; index < 6; index++) {
      final point = Offset(
        center.dx + radius * cos(pi / 3 * index),
        center.dy + radius * sin(pi / 3 * index),
      );
      index == 0
          ? path.moveTo(point.dx, point.dy)
          : path.lineTo(point.dx, point.dy);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = LianaColors.cardBackground);
    canvas.drawPath(
      path,
      Paint()
        ..color = LianaColors.border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
