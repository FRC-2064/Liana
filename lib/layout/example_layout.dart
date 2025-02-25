import 'dart:math' as math;
import 'package:flutter/material.dart';

class MyLayoutExample extends StatelessWidget {
  const MyLayoutExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Make the background dark like in your screenshot
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT SIDE: Timer + colored boxes
            _buildLeftPanel(),

            // CENTER: Climb row, Processor/Ring/Clean row, Feeder row
            Expanded(
              flex: 3,
              child: _buildCenterPanel(),
            ),

            // RIGHT SIDE: Levels
            _buildRightPanel(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------
  // 1) LEFT SIDE: Timer at top + colored boxes
  // ---------------------------------------------
  Widget _buildLeftPanel() {
    return Container(
      width: 150, // adjust as needed
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Big Timer
          Text(
            '2:30',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          // Colored boxes
          _RectBox(label: 'CORAL', color: Colors.green),
          const SizedBox(height: 8),
          _RectBox(label: 'ALGAE', color: Colors.red),
          const SizedBox(height: 8),
          _RectBox(label: 'FINGERS', color: Colors.blue),
        ],
      ),
    );
  }

  // ---------------------------------------------
  // 2) CENTER PANEL: Top Climb row, middle ring row, bottom Feeder row
  // ---------------------------------------------
  Widget _buildCenterPanel() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // --- (A) Top row of climb buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _RectBox(label: 'LEFT CLIMB', color: Colors.lightGreen),
            SizedBox(width: 16),
            _RectBox(label: 'CENTER CLIMB', color: Colors.lightGreen),
            SizedBox(width: 16),
            _RectBox(label: 'RIGHT CLIMB', color: Colors.lightGreen),
          ],
        ),

        // --- (B) Middle row with "Processor" / ring / "Clean Algae"
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Processor box on the left
              const _RectBox(label: 'Processor', color: Colors.orange),

              // The ring of hexagons in the center
              _HexRingWidget(),

              // Clean Algae box on the right
              const _RectBox(label: 'Clean Algae', color: Colors.orange),
            ],
          ),
        ),

        // --- (C) Bottom row of feeder buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _RectBox(label: 'LEFT FEEDER', color: Colors.pink),
            SizedBox(width: 16),
            _RectBox(label: 'RIGHT FEEDER', color: Colors.pink),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // ---------------------------------------------
  // 3) RIGHT SIDE: Level boxes (Level 4 -> Level 1)
  // ---------------------------------------------
  Widget _buildRightPanel() {
    return Container(
      width: 120, // adjust as needed
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          _RectBox(label: 'LEVEL 4', color: Colors.purple),
          SizedBox(height: 12),
          _RectBox(label: 'LEVEL 3', color: Colors.purple),
          SizedBox(height: 12),
          _RectBox(label: 'LEVEL 2', color: Colors.purple),
          SizedBox(height: 12),
          _RectBox(label: 'LEVEL 1', color: Colors.purple),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------
// A simple rectangular box with a label, used for CORAL/ALGAE/FINGERS etc.
// ----------------------------------------------------------------------
class _RectBox extends StatelessWidget {
  final String label;
  final Color color;

  const _RectBox({
    Key? key,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: color,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// A widget that shows a center hex labeled "A" plus a ring of hexagons.
// ----------------------------------------------------------------------
class _HexRingWidget extends StatelessWidget {
  // You can adjust these to change ring size, number of hexes, etc.
  final int count;
  final double ringRadius;
  final double hexSize;
  final double centerHexSize;

  const _HexRingWidget({
    Key? key,
    this.count = 12,          // 12 outer hexes
    this.ringRadius = 100,    // distance from center
    this.hexSize = 60,        // outer hex width/height
    this.centerHexSize = 80,  // center hex width/height
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // We’ll build a Stack that’s big enough for the ring
        final double size = (ringRadius * 2) + (centerHexSize * 2);
        final center = size / 2;

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: [
              // Center hex
              Positioned(
                left: center - (centerHexSize / 2),
                top: center - (centerHexSize / 2),
                child: HexButton(
                  width: centerHexSize,
                  height: centerHexSize,
                  label: 'A',
                  color: Colors.green,
                ),
              ),

              // Outer hexes
              for (int i = 0; i < count; i++)
                _buildPositionedHex(i, count, center, hexSize),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPositionedHex(int i, int total, double center, double hexW) {
    // Angle for this hex in the ring
    final angle = 2 * math.pi * i / total;

    // We want them at `ringRadius` from the center
    final offsetX = center + ringRadius * math.cos(angle);
    final offsetY = center + ringRadius * math.sin(angle);

    return Positioned(
      left: offsetX - (hexW / 2),
      top: offsetY - (hexW / 2),
      child: HexButton(
        width: hexW,
        height: hexW,
        label: 'H$i',
        color: Colors.red,
      ),
    );
  }
}

// ----------------------------------------------------------------------
// A reusable widget that clips its child into a hex shape via ClipPath.
// ----------------------------------------------------------------------
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
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// Clipper that creates a regular hexagon path.
// ----------------------------------------------------------------------
class HexClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path()
      // Move to top-left corner of the flat top
      ..moveTo(w * 0.25, 0)
      // Top edge (flat)
      ..lineTo(w * 0.75, 0)
      // Top-right corner
      ..lineTo(w, h * 0.5)
      // Bottom-right corner (flat side)
      ..lineTo(w * 0.75, h)
      // Bottom-left corner (flat side)
      ..lineTo(w * 0.25, h)
      // Left corner
      ..lineTo(0, h * 0.5)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

