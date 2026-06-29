import 'package:flutter/material.dart';
import 'package:liana/services/network_tables/nt_topic.dart';
import 'package:liana/utils/liana_colors.dart';
import 'package:liana/utils/nt_widget_size.dart';
import 'package:liana/widgets/network_tables/nt_increment_button.dart';
import 'package:liana/widgets/network_tables/nt_value_builder.dart';

/// A [Widget] to display and adjust a numerical value from
/// a Network Table topic using increment and decrement buttons.
class NtAdjustment extends StatelessWidget {
  final NtTopic<double> topic;
  final double incrementAmount;
  final String title;
  final NtWidgetSize size;
  final String positiveText;
  final String negativeText;
  final double? width;
  final double? height;
  final double? titleFontSize;
  final double? valueFontSize;
  final Color positiveColor;
  final Color negativeColor;
  final double minValue;
  final double maxValue;

  const NtAdjustment({
    required this.topic,
    required this.incrementAmount,
    required this.title,
    this.size = NtWidgetSize.medium,
    this.positiveText = '+',
    this.negativeText = '-',
    this.width,
    this.height,
    this.titleFontSize,
    this.valueFontSize,
    this.positiveColor = LianaColors.cardBackground,
    this.negativeColor = LianaColors.cardBackground,
    this.minValue = -100,
    this.maxValue = 100,
    super.key,
  });

  double get _buttonWidth =>
      width ??
      switch (size) {
        NtWidgetSize.small => 70,
        NtWidgetSize.medium => 100,
        NtWidgetSize.large => 130,
      };

  double get _buttonHeight =>
      height ??
      switch (size) {
        NtWidgetSize.small => 50,
        NtWidgetSize.medium => 70,
        NtWidgetSize.large => 90,
      };

  double get _titleSize =>
      titleFontSize ??
      switch (size) {
        NtWidgetSize.small => 18,
        NtWidgetSize.medium => 24,
        NtWidgetSize.large => 30,
      };

  double get _valueSize =>
      valueFontSize ??
      switch (size) {
        NtWidgetSize.small => 24,
        NtWidgetSize.medium => 32,
        NtWidgetSize.large => 40,
      };

  @override
  Widget build(BuildContext context) {
    return NtValueBuilder<double>(
      topic: topic,
      builder: (context, current, entry) {
        final value = current.value;
        final normalized = value == null
            ? 0.0
            : (value / maxValue.abs()).clamp(-1.0, 1.0);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: _titleSize,
                fontWeight: FontWeight.bold,
                color: current.hasValue
                    ? LianaColors.buttonText
                    : LianaColors.missing,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NtIncrementButton(
                  topic: topic,
                  text: negativeText,
                  incrementAmount: -incrementAmount,
                  size: size,
                  activeColor: negativeColor,
                  width: _buttonWidth,
                  height: _buttonHeight,
                  minValue: minValue,
                  maxValue: maxValue,
                ),
                const SizedBox(width: 24),
                Column(
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(
                        value?.toStringAsFixed(1) ?? '--',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _valueSize,
                          fontWeight: FontWeight.bold,
                          color: current.hasValue
                              ? LianaColors.buttonText
                              : LianaColors.missing,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 200,
                      height: 12,
                      child: CustomPaint(
                        painter: _ProgressBarPainter(
                          value: normalized,
                          hasValue: current.hasValue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                NtIncrementButton(
                  topic: topic,
                  text: positiveText,
                  incrementAmount: incrementAmount,
                  size: size,
                  activeColor: positiveColor,
                  width: _buttonWidth,
                  height: _buttonHeight,
                  minValue: minValue,
                  maxValue: maxValue,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ProgressBarPainter extends CustomPainter {
  final double value;
  final bool hasValue;

  const _ProgressBarPainter({required this.value, required this.hasValue});

  @override
  void paint(Canvas canvas, Size size) {
    final background = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(6),
    );
    canvas.drawRRect(background, Paint()..color = LianaColors.background);
    canvas.drawRRect(
      background,
      Paint()
        ..color = LianaColors.border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    if (!hasValue || value == 0) return;
    final center = size.width / 2;
    final width = center * value.abs();
    final rect = value > 0
        ? Rect.fromLTWH(center, 0, width, size.height)
        : Rect.fromLTWH(center - width, 0, width, size.height);
    canvas.drawRect(rect, Paint()..color = LianaColors.headerText);
  }

  @override
  bool shouldRepaint(covariant _ProgressBarPainter oldDelegate) {
    return value != oldDelegate.value || hasValue != oldDelegate.hasValue;
  }
}
