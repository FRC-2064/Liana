import 'dart:math' as math;
import 'package:flutter/material.dart';

class HexStackLayout extends StatelessWidget {
  const HexStackLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // LayoutBuilder lets us size the "board" based on available space.
        child: LayoutBuilder(
          builder: (context, constraints) {
            // We'll pick a size based on the shortest side of the screen,
            // so this looks decent in both portrait and landscape.
            final size = constraints.biggest.shortestSide * 0.8;
            final centerX = size / 2;
            final centerY = size / 2;

            // Number of hexes in the ring (2 per side * 6 sides = 12).
            final count = 12;

            // Distance from center to place outer hexes.
            // Adjust as needed for spacing.
            final radius = (size / 2) - 60;

            return Container(
              width: size,
              height: size,
              color: Colors.black87, // background so we can see our board
              child: Stack(
                children: [
                  // 1) Large center hex
                  Positioned(
                    left: centerX - 80, // half of the hex width
                    top: centerY - 80,  // half of the hex height
                    child: HexButton(
                      width: 160,
                      height: 160,
                      label: 'CENTER',
                      color: Colors.green,
                    ),
                  ),

                  // 2) 12 hexes around the center (2 per side of a hex)
                  for (int i = 0; i < count; i++)
                    _buildHexPositioned(i, count, radius, centerX, centerY),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Positions each of the 12 outer hexes at a unique angle around the center.
  Widget _buildHexPositioned(
    int index,
    int total,
    double radius,
    double centerX,
    double centerY,
  ) {
    // Each hex is spaced at 2π/12 = 30° increments around the circle
    final angle = 2 * math.pi * index / total;
    final offsetX = centerX + radius * math.cos(angle);
    final offsetY = centerY + radius * math.sin(angle);

    return Positioned(
      left: offsetX - 40,  // half the width of the small hex
      top: offsetY - 40,   // half the height of the small hex
      child: HexButton(
        width: 80,
        height: 80,
        label: 'Hex $index',
        color: Colors.red,
      ),
    );
  }
}

/// A widget that clips its child into a hexagon shape using [HexClipper].
class HexButton extends StatelessWidget {
  final double width;
  final double height;
  final String label;
  final Color color;

  const HexButton({
    Key? key,
    required this.width,
    required this.height,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HexClipper(),
      child: Container(
        width: width,
        height: height,
        color: color,
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

/// Clips its child into a regular hexagon.
class HexClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;

    // Define the 6 corners of a regular hex
    final path = Path()
      ..moveTo(w * 0.5, 0)
      ..lineTo(w, h * 0.25)
      ..lineTo(w, h * 0.75)
      ..lineTo(w * 0.5, h)
      ..lineTo(0, h * 0.75)
      ..lineTo(0, h * 0.25)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(HexClipper oldClipper) => false;
}
