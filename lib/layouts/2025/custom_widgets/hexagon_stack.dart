import 'dart:math';
import 'package:liana/widgets/network_tables/button_builders/hexagon_builder.dart';
import 'package:flutter/material.dart';
import 'package:liana/widgets/network_tables/nt_status_button.dart';

import 'package:liana/utils/control_board_colors.dart';
import 'package:liana/layouts/2025/Reefscape_value_lists.dart';

class HexagonStack extends StatefulWidget {
  const HexagonStack({
    this.scale = 0.75, // Overall scale factor
    this.centerHexSizeMultiplier = 1.0, // Center hexagon size multiplier
    this.outerHexSizeMultiplier = 1.25, // Outer hexagons size multiplier
    this.distanceMultiplier =
        0.96, // Controls distance between center and outer hexagons
    this.buttonHeightRatio =
        1.75, // Controls the height of button hexagons (height-to-width ratio)
    this.marginMultiplier = 0.5, // Controls the margin around the entire widget
    this.baseFontSize = 24.0,
    super.key,
  });

  // Notice: 'Liana controlBoard' parameter is removed.

  final double scale;
  final double centerHexSizeMultiplier;
  final double outerHexSizeMultiplier;
  final double distanceMultiplier;
  final double buttonHeightRatio;
  final double marginMultiplier;
  final double baseFontSize;

  @override
  State<HexagonStack> createState() => _HexagonStackState();
}

class _HexagonStackState extends State<HexagonStack> {
  @override
  Widget build(BuildContext context) {
    final double centerHexRadius =
        200.0 * widget.scale * widget.centerHexSizeMultiplier;
    final double outerHexRadius =
        50.0 * widget.scale * widget.outerHexSizeMultiplier;
    final double hexHeight = outerHexRadius * widget.buttonHeightRatio;

    final double baseDistance = centerHexRadius + outerHexRadius * 0.25;
    final double distanceFromCenter = baseDistance * widget.distanceMultiplier;
    final double edgeAdjustment = outerHexRadius * 0.5;
    final double effectiveDistance = distanceFromCenter + edgeAdjustment;

    final double margin = outerHexRadius * widget.marginMultiplier;

    final double initialAngle = 135 * pi / 180;

    List<Offset> outerCenters = [];
    for (int i = 0; i < 12; i++) {
      double angle = initialAngle + i * (2 * pi / 12);
      double cx = effectiveDistance * cos(angle);
      double cy = effectiveDistance * sin(angle);
      outerCenters.add(Offset(cx, cy));
    }

    double globalMinX = double.infinity;
    double globalMaxX = double.negativeInfinity;
    double globalMinY = double.infinity;
    double globalMaxY = double.negativeInfinity;

    globalMinX = min(globalMinX, -centerHexRadius);
    globalMaxX = max(globalMaxX, centerHexRadius);
    globalMinY = min(globalMinY, -centerHexRadius);
    globalMaxY = max(globalMaxY, centerHexRadius);

    for (final Offset center in outerCenters) {
      double left = center.dx - outerHexRadius;
      double right = center.dx + outerHexRadius;
      double top = center.dy - hexHeight / 2;
      double bottom = center.dy + hexHeight / 2;

      globalMinX = min(globalMinX, left);
      globalMaxX = max(globalMaxX, right);
      globalMinY = min(globalMinY, top);
      globalMaxY = max(globalMaxY, bottom);
    }

    globalMinX -= margin;
    globalMaxX += margin;
    globalMinY -= margin;
    globalMaxY += margin;

    final double overallWidth = globalMaxX - globalMinX;
    final double overallHeight = globalMaxY - globalMinY;

    final Offset centerPoint = Offset(
      -globalMinX,
      -globalMinY,
    );

    final double scaledFontSize =
        widget.baseFontSize * widget.scale * widget.outerHexSizeMultiplier;

    return SizedBox(
      width: overallWidth,
      height: overallHeight,
      child: Stack(
        children: [
          Positioned(
            left: centerPoint.dx - centerHexRadius,
            top: centerPoint.dy - centerHexRadius,
            child: CustomPaint(
              painter: LargeHexagonPainter(
                color: ControlBoardColors.cardBackground,
                borderColor: ControlBoardColors.border,
              ),
              child: SizedBox(
                width: centerHexRadius * 2,
                height: centerHexRadius * 2,
              ),
            ),
          ),
          for (int i = 0; i < outerCenters.length; i++)
            Positioned(
              left: centerPoint.dx + outerCenters[i].dx - outerHexRadius,
              top: centerPoint.dy + outerCenters[i].dy - hexHeight / 2,
              child: NtStatusButton<String>(
                topicName: "Reef/Location",
                defaultValue: ValueLists.reefLocations.first,
                valueToSet: ValueLists.reefLocations[i],
                text: ValueLists.reefLocations[i],
                width: outerHexRadius * 2,
                height: hexHeight,
                fontSize: scaledFontSize,
                builder: const HexagonBuilder(),
              ),
            ),
        ],
      ),
    );
  }
}

class LargeHexagonPainter extends CustomPainter {
  final Color color;
  final Color borderColor;

  LargeHexagonPainter({
    required this.color,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final path = _createHexagonPath(size);
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  Path _createHexagonPath(Size size) {
    final double w = size.width;
    final double h = size.height;
    final double centerX = w / 2;
    final double centerY = h / 2;
    final double radius = min(w, h) / 2;
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
  bool shouldRepaint(LargeHexagonPainter oldDelegate) {
    return color != oldDelegate.color || borderColor != oldDelegate.borderColor;
  }
}
