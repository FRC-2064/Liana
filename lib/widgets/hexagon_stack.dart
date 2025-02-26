import 'dart:math';
import 'package:control_board/services/control_board.dart';
import 'package:control_board/utils.dart';
import 'package:control_board/widgets/hexagon_button.dart';
import 'package:flutter/material.dart';

class HexagonStack extends StatefulWidget {
  const HexagonStack({
    required this.controlBoard,
    this.scale = 1.0, // Default scale factor
    super.key,
  });

  final ControlBoard controlBoard;
  final double scale;

  @override
  State<HexagonStack> createState() => _HexagonStackState();
}

class _HexagonStackState extends State<HexagonStack> {
  @override
  Widget build(BuildContext context) {
    // Scaled dimensions.
    final double centerHexRadius = 200.0 * widget.scale;
    final double outerHexRadius = 50.0 * widget.scale;
    final double hexHeight = outerHexRadius * 1.75;

    // Spacing constants.
    final double distanceFromCenter = centerHexRadius + outerHexRadius * .25;
    final double edgeAdjustment = outerHexRadius * 0.5; // adjustment along the radial direction
    // Effective distance for placing outer hexagon centers.
    final double effectiveDistance = distanceFromCenter + edgeAdjustment;
    final double margin = outerHexRadius * 0.5;

    // Define the angles for the 12 outer hexagons.
    // We start at 135° so that the first (i.e. 'A') appears in the bottom left, then go counterclockwise.
    final double initialAngle = 135 * pi / 180;

    // Compute global bounds. We'll consider both the outer hexagon bounding boxes and the center hexagon.
    double globalMinX = -centerHexRadius;
    double globalMaxX = centerHexRadius;
    double globalMinY = -centerHexRadius;
    double globalMaxY = centerHexRadius;

    // List to hold computed centers for outer hexagons.
    List<Offset> outerCenters = [];
    for (int i = 0; i < 12; i++) {
      double angle = initialAngle + i * (2 * pi / 12);
      // The effective center for this outer hexagon.
      double cx = effectiveDistance * cos(angle);
      double cy = effectiveDistance * sin(angle);
      outerCenters.add(Offset(cx, cy));
      // Its bounding box (we assume the widget's drawn size is 2*outerHexRadius wide and hexHeight tall).
      double left = cx - outerHexRadius;
      double right = cx + outerHexRadius;
      double top = cy - hexHeight / 2;
      double bottom = cy + hexHeight / 2;
      if (left < globalMinX) globalMinX = left;
      if (right > globalMaxX) globalMaxX = right;
      if (top < globalMinY) globalMinY = top;
      if (bottom > globalMaxY) globalMaxY = bottom;
    }

    // Add extra margin.
    globalMinX -= margin;
    globalMaxX += margin;
    globalMinY -= margin;
    globalMaxY += margin;

    // Overall canvas dimensions.
    final double overallWidth = globalMaxX - globalMinX;
    final double overallHeight = globalMaxY - globalMinY;
    // Offset to shift everything so that globalMin becomes (0,0).
    final Offset offsetOrigin = Offset(-globalMinX, -globalMinY);

    return SizedBox(
      width: overallWidth,
      height: overallHeight,
      child: Stack(
        children: [
          // Center hexagon placed at the computed center of the canvas.
          Positioned(
            left: offsetOrigin.dx,
            top: offsetOrigin.dy,
            child: Transform.translate(
              offset: Offset(-centerHexRadius, -centerHexRadius),
              child: CustomPaint(
                painter: LargeHexagonPainter(
                  color: Colors.grey[800]!,
                  borderColor: Colors.grey,
                ),
                child: SizedBox(
                  width: centerHexRadius * 2,
                  height: centerHexRadius * 2,
                ),
              ),
            ),
          ),
          // Outer hexagon buttons.
          for (int i = 0; i < outerCenters.length; i++)
            Positioned(
              left: offsetOrigin.dx + outerCenters[i].dx,
              top: offsetOrigin.dy + outerCenters[i].dy,
              child: Transform.translate(
                offset: Offset(-outerHexRadius, -hexHeight / 2),
                child: HexagonButton(
                  name: Utils.reefLocations[i],
                  setFunction: () =>
                      widget.controlBoard.setReefLocation(Utils.reefLocations[i]),
                  setVal: Utils.reefLocations[i],
                  locationListenable: widget.controlBoard.reefLocation(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// The custom painter for the larger center hexagon remains unchanged.
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
