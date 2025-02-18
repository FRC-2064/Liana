import 'dart:math';

import 'package:flutter/material.dart';

class HexagonButton extends StatefulWidget {
  const HexagonButton({
    super.key,
    required this.name,
    required this.setFunction,
    required this.setVal,
    required this.locationListenable,
  });

  final String name;
  final VoidCallback setFunction;
  final Stream<String> locationListenable;
  final String setVal;

  @override
  State<HexagonButton> createState() => _HexagonButtonState();
}

class _HexagonButtonState extends State<HexagonButton> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.locationListenable,
        builder: (context, snapshot) => GestureDetector(
              onTap: () => widget.setFunction,
              child: CustomPaint(
                painter:
                    HexagonPainter(isSelected: snapshot.data == widget.setVal),
                child: SizedBox(
                  width: 100,
                  height: 110,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}

class HexagonPainter extends CustomPainter {
  final bool isSelected;
  HexagonPainter({required this.isSelected});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint borderPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final Paint fillPaint = Paint()
      ..color = isSelected ? Colors.green[700]! : Colors.transparent
      ..style = PaintingStyle.fill;

    final Path hexagonPath = Path();
    final double w = size.width;
    final double h = size.height;
    final double a = w / 2;
    final double b = h / 2;
    final double r = b / cos(pi / 6);

    hexagonPath.moveTo(a, 0);
    hexagonPath.lineTo(w, b / 2);
    hexagonPath.lineTo(w, b + b / 2);
    hexagonPath.lineTo(a, h);
    hexagonPath.lineTo(0, b + b / 2);
    hexagonPath.lineTo(0, b / 2);
    hexagonPath.close();

    canvas.drawPath(hexagonPath, fillPaint);
    canvas.drawPath(hexagonPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
