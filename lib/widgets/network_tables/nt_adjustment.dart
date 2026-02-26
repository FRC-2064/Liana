import 'package:liana/services/network_tables/liana.dart';
import 'package:liana/services/network_tables/nt_entry.dart';
import 'package:liana/utils/liana_colors.dart';
import 'package:flutter/material.dart';
import 'package:liana/widgets/network_tables/nt_increment_button.dart';
import 'package:provider/provider.dart';

class NtAdjustment extends StatefulWidget {
  const NtAdjustment({
    super.key,
    required this.topicName,
    required this.incrementAmount,
    required this.defaultValue,
    required this.title,
    this.positiveText = '+',
    this.negativeText = '-',
    this.width = 120.0,
    this.height = 70.0,
    this.titleFontSize = 24.0,
    this.valueFontSize = 32.0,
    this.positiveColor = LianaColors.cardBackground,
    this.negativeColor = LianaColors.cardBackground,
    this.minValue = -100.0,
    this.maxValue = 100.0,
  });

  final String topicName;
  final double incrementAmount;
  final double defaultValue;
  final String title;
  final String positiveText;
  final String negativeText;
  final double width;
  final double height;
  final double titleFontSize;
  final double valueFontSize;
  final Color positiveColor;
  final Color negativeColor;
  final double minValue;
  final double maxValue;

  @override
  State<NtAdjustment> createState() => _NtAdjustmentState();
}

class _NtAdjustmentState extends State<NtAdjustment> {
  late final NtEntry<double> _entry;
  late final Liana _liana;

  @override
  void initState() {
    super.initState();
    _liana = Provider.of<Liana>(context, listen: false);
    _entry = _liana.getEntry(
      widget.topicName,
      defaultValue: widget.defaultValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _liana.connectionStatus(),
      initialData: _liana.isConnected,
      builder: (context, connectionSnapshot) {
        final bool isConnected = connectionSnapshot.data ?? false;

        return StreamBuilder<double>(
          stream: _entry.stream(),
          initialData: _entry.value,
          builder: (context, snapshot) {
            // Only show robot value when connected, otherwise show default
            final currentValue = isConnected
                ? (snapshot.data ?? widget.defaultValue)
                : widget.defaultValue;

            // Calculate progress bar percentage (-1 to 1 range)
            final double normalizedValue = currentValue / widget.maxValue.abs();
            final double clampedNormalized = normalizedValue.clamp(-1.0, 1.0);

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: widget.titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: isConnected
                        ? LianaColors.buttonText
                        : LianaColors.missing,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NtIncrementButton(
                      text: widget.negativeText,
                      incrementAmount: widget.incrementAmount * -1,
                      topicName: widget.topicName,
                      activeColor: widget.negativeColor,
                      inactiveColor: LianaColors.missing,
                      inactiveTextColor: LianaColors.buttonText,
                      activeTextColor: LianaColors.buttonText,
                      fontSize: 18,
                      height: widget.height,
                      width: widget.width,
                      minValue: widget.minValue,
                      maxValue: widget.maxValue,
                    ),
                    const SizedBox(width: 24),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Center(
                            child: Text(
                              currentValue.toStringAsFixed(1),
                              key: ValueKey(currentValue),
                              style: TextStyle(
                                fontSize: widget.valueFontSize,
                                fontWeight: FontWeight.bold,
                                color: isConnected
                                    ? LianaColors.buttonText
                                    : LianaColors.missing,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Progress bar
                        SizedBox(
                          width: 200,
                          height: 12,
                          child: CustomPaint(
                            painter: _ProgressBarPainter(
                              value: clampedNormalized,
                              positiveColor: widget.positiveColor,
                              negativeColor: widget.negativeColor,
                              backgroundColor: LianaColors.background,
                              borderColor: LianaColors.border,
                              isConnected: isConnected,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    NtIncrementButton(
                      text: widget.positiveText,
                      incrementAmount: widget.incrementAmount,
                      topicName: widget.topicName,
                      activeColor: widget.positiveColor,
                      inactiveColor: LianaColors.missing,
                      inactiveTextColor: LianaColors.buttonText,
                      activeTextColor: LianaColors.buttonText,
                      fontSize: 18,
                      height: widget.height,
                      width: widget.width,
                      minValue: widget.minValue,
                      maxValue: widget.maxValue,
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _ProgressBarPainter extends CustomPainter {
  final double value; // -1 to 1
  final Color positiveColor;
  final Color negativeColor;
  final Color backgroundColor;
  final Color borderColor;
  final bool isConnected;

  _ProgressBarPainter({
    required this.value,
    required this.positiveColor,
    required this.negativeColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.isConnected,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = borderColor;

    final centerX = size.width / 2;
    final radius = 6.0;

    // Draw background with rounded corners
    paint.color = backgroundColor;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    canvas.drawRRect(rrect, paint);

    if (isConnected) {
      // Draw filled portion - use red accent color for both directions
      paint.color = LianaColors.headerText; // Red accent color

      if (value > 0) {
        // Fill to the right - sharp edge at center, rounded on right
        final fillWidth = (size.width / 2) * value;

        final path = Path()
          ..moveTo(centerX, 0)
          ..lineTo(centerX + fillWidth - radius, 0)
          ..arcToPoint(
            Offset(centerX + fillWidth, radius),
            radius: Radius.circular(radius),
          )
          ..lineTo(centerX + fillWidth, size.height - radius)
          ..arcToPoint(
            Offset(centerX + fillWidth - radius, size.height),
            radius: Radius.circular(radius),
          )
          ..lineTo(centerX, size.height)
          ..close();

        canvas.drawPath(path, paint);
      } else if (value < 0) {
        // Fill to the left - sharp edge at center, rounded on left
        final fillWidth = (size.width / 2) * value.abs();

        final path = Path()
          ..moveTo(centerX, 0)
          ..lineTo(centerX - fillWidth + radius, 0)
          ..arcToPoint(
            Offset(centerX - fillWidth, radius),
            radius: Radius.circular(radius),
            clockwise: false,
          )
          ..lineTo(centerX - fillWidth, size.height - radius)
          ..arcToPoint(
            Offset(centerX - fillWidth + radius, size.height),
            radius: Radius.circular(radius),
            clockwise: false,
          )
          ..lineTo(centerX, size.height)
          ..close();

        canvas.drawPath(path, paint);
      }
    }

    // Draw center line (thicker and more defined)
    paint.color = borderColor;
    paint.strokeWidth = 3;
    paint.style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(centerX, 0),
      Offset(centerX, size.height),
      paint,
    );

    // Draw border
    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(_ProgressBarPainter oldDelegate) {
    return oldDelegate.value != value ||
           oldDelegate.isConnected != isConnected;
  }
}
