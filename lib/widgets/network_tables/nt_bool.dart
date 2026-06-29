import 'package:flutter/material.dart';
import 'package:liana/services/network_tables/nt_topic.dart';
import 'package:liana/utils/liana_colors.dart';
import 'package:liana/utils/nt_widget_size.dart';
import 'package:liana/widgets/network_tables/nt_value_builder.dart';

/// a [Widget] that focuses on [bool]s. Contains an indicator
/// and an optional [isSwitch] that allows for bool control
/// rather than just viewing.
class NtBool extends StatelessWidget {
  final String name;
  final NtTopic<bool> topic;
  final bool isSwitch;
  final NtWidgetSize size;
  final Color trueColor;
  final Color falseColor;
  final Color missingColor;
  final Color textColor;
  final Color bgColor;
  final Color indicatorBorderColor;
  final double? indicatorHeight;
  final double? indicatorWidth;
  final double indicatorBorderRadius;
  final double indicatorBorderWidth;

  const NtBool({
    required this.name,
    required this.topic,
    this.isSwitch = false,
    this.size = NtWidgetSize.medium,
    this.trueColor = LianaColors.boolTrue,
    this.falseColor = LianaColors.boolFalse,
    this.missingColor = LianaColors.missing,
    this.textColor = LianaColors.buttonText,
    this.bgColor = LianaColors.cardBackground,
    this.indicatorBorderColor = LianaColors.border,
    this.indicatorHeight,
    this.indicatorWidth,
    this.indicatorBorderRadius = 12,
    this.indicatorBorderWidth = 1,
    super.key,
  });

  double get _width =>
      indicatorWidth ??
      switch (size) {
        NtWidgetSize.small => 70,
        NtWidgetSize.medium => 100,
        NtWidgetSize.large => 140,
      };

  double get _height =>
      indicatorHeight ??
      switch (size) {
        NtWidgetSize.small => 50,
        NtWidgetSize.medium => 75,
        NtWidgetSize.large => 100,
      };

  double get _fontSize => switch (size) {
    NtWidgetSize.small => 14,
    NtWidgetSize.medium => 18,
    NtWidgetSize.large => 22,
  };

  @override
  Widget build(BuildContext context) {
    return NtValueBuilder<bool>(
      topic: topic,
      builder: (context, current, entry) {
        final color = !current.hasValue
            ? missingColor
            : current.value!
            ? trueColor
            : falseColor;
        final card = Card(
          color: bgColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: _fontSize,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: _height,
                  width: _width,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(indicatorBorderRadius),
                    border: indicatorBorderWidth > 0
                        ? Border.all(
                            width: indicatorBorderWidth,
                            color: indicatorBorderColor,
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        );

        if (!isSwitch) return card;
        return InkWell(
          onTap: current.hasValue ? () => entry.set(!current.value!) : null,
          borderRadius: BorderRadius.circular(16),
          child: card,
        );
      },
    );
  }
}
