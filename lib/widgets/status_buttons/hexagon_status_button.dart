import 'dart:math';

import 'package:flutter/material.dart';

import '../../utils/control_board_colors.dart';

class HexagonStatusButton extends StatefulWidget {
  const HexagonStatusButton({
    super.key,
    required this.name,
    required this.setFunction,
    required this.setVal,
    required this.locationListenable,
    required this.height,
    required this.width,
    required this.fontSize,
  });

  final String name;
  final VoidCallback setFunction;
  final Stream<String> locationListenable;
  final String setVal;
  final double height;
  final double width;
  final double fontSize;

  @override
  State<HexagonStatusButton> createState() => _HexagonStatusButtonState();
}

class _HexagonStatusButtonState extends State<HexagonStatusButton> {
  @override
  void didUpdateWidget(HexagonStatusButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: widget.locationListenable,
        initialData: '',
        builder: (context, snapshot) {
          final isSelected = snapshot.hasData && snapshot.data == widget.setVal;
          return CustomPaint(
            painter: HexagonPainter(
              color: isSelected
                  ? ControlBoardColors.statusSelected
                  : ControlBoardColors.statusUnselected,
              borderColor: ControlBoardColors.border,
            ),
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                ),
                onPressed: widget.setFunction,
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        widget.name,
                        style: TextStyle(
                          fontSize: widget.fontSize,
                          fontWeight: FontWeight.bold,
                          color: ControlBoardColors.buttonText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class HexagonPainter extends CustomPainter {
  final Color color;
  final Color borderColor;

  HexagonPainter({
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

    // Draw fill
    canvas.drawPath(path, fillPaint);
    // Draw border
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
  bool shouldRepaint(HexagonPainter oldDelegate) {
    return color != oldDelegate.color || borderColor != oldDelegate.borderColor;
  }
}
