import 'dart:async';

import 'package:flutter/material.dart';
import 'package:liana/services/network_tables/nt_entry.dart';
import 'package:liana/services/network_tables/nt_topic.dart';
import 'package:liana/utils/liana_colors.dart';
import 'package:liana/utils/nt_widget_size.dart';
import 'package:liana/widgets/network_tables/nt_value_builder.dart';

/// A [Widget] button that increments or decrements a Network Table
/// topic value when tapped, or continuously while held down.
class NtIncrementButton extends StatefulWidget {
  final NtTopic<double> topic;
  final String text;
  final double incrementAmount;
  final NtWidgetSize size;
  final double? width;
  final double? height;
  final double? fontSize;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final Color activeColor;
  final Color inactiveColor;
  final double minValue;
  final double maxValue;

  const NtIncrementButton({
    required this.topic,
    required this.text,
    required this.incrementAmount,
    this.size = NtWidgetSize.medium,
    this.width,
    this.height,
    this.fontSize,
    this.activeColor = LianaColors.cardBackground,
    this.activeTextColor = LianaColors.buttonText,
    this.inactiveColor = LianaColors.statusUnselected,
    this.inactiveTextColor = LianaColors.missing,
    this.minValue = -100,
    this.maxValue = 100,
    super.key,
  });

  @override
  State<NtIncrementButton> createState() => _NtIncrementButtonState();
}

class _NtIncrementButtonState extends State<NtIncrementButton> {
  Timer? _holdTimer;
  Timer? _flashTimer;
  NtEntry<double>? _entry;
  NtValue<double> _current = const NtValue.missing();
  bool _isFlashing = false;

  double get _width =>
      widget.width ??
      switch (widget.size) {
        NtWidgetSize.small => 70,
        NtWidgetSize.medium => 100,
        NtWidgetSize.large => 140,
      };

  double get _height =>
      widget.height ??
      switch (widget.size) {
        NtWidgetSize.small => 50,
        NtWidgetSize.medium => 70,
        NtWidgetSize.large => 90,
      };

  double get _fontSize =>
      widget.fontSize ??
      switch (widget.size) {
        NtWidgetSize.small => 16,
        NtWidgetSize.medium => 20,
        NtWidgetSize.large => 24,
      };

  void _increment() {
    if (!_current.hasValue || _entry == null) return;
    final value = (_current.value! + widget.incrementAmount)
        .clamp(widget.minValue, widget.maxValue)
        .toDouble();
    _entry!.set(value);
    _flashTimer?.cancel();
    setState(() => _isFlashing = true);
    _flashTimer = Timer(const Duration(milliseconds: 100), () {
      if (mounted) setState(() => _isFlashing = false);
    });
  }

  void _startHold(TapDownDetails _) {
    _stopHold();
    _increment();
    _holdTimer = Timer(const Duration(milliseconds: 500), () {
      _holdTimer = Timer.periodic(
        const Duration(milliseconds: 100),
        (_) => _increment(),
      );
    });
  }

  void _stopHold([Object? _]) {
    _holdTimer?.cancel();
    _holdTimer = null;
  }

  @override
  void dispose() {
    _stopHold();
    _flashTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NtValueBuilder<double>(
      topic: widget.topic,
      builder: (context, current, entry) {
        _entry = entry;
        _current = current;
        final active = current.hasValue;
        final background = _isFlashing
            ? LianaColors.primary
            : active
            ? widget.activeColor
            : widget.inactiveColor;
        return SizedBox(
          width: _width,
          height: _height,
          child: Material(
            color: background,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTapDown: active ? _startHold : null,
              onTapUp: active ? _stopHold : null,
              onTapCancel: active ? _stopHold : null,
              child: Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: _fontSize,
                    fontWeight: FontWeight.bold,
                    color: active
                        ? widget.activeTextColor
                        : widget.inactiveTextColor,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
