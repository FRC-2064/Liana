import 'dart:async';
import 'package:flutter/material.dart';
import 'package:liana/services/network_tables/liana.dart';
import 'package:liana/services/network_tables/nt_entry.dart';
import 'package:liana/utils/liana_colors.dart';
import 'package:provider/provider.dart';

class NtIncrementButton extends StatefulWidget {
  const NtIncrementButton({
    super.key,
    required this.topicName,
    required this.text,
    required this.incrementAmount,
    required this.width,
    required this.height,
    required this.fontSize,
    required this.activeColor,
    required this.activeTextColor,
    required this.inactiveColor,
    required this.inactiveTextColor,
    this.minValue = -100.0,
    this.maxValue = 100.0,
  });

  final String topicName;
  final String text;
  final double incrementAmount;
  final double width;
  final double height;
  final double fontSize;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final Color activeColor;
  final Color inactiveColor;
  final double minValue;
  final double maxValue;

  @override
  State<NtIncrementButton> createState() => _NtIncrementButtonState();
}

class _NtIncrementButtonState extends State<NtIncrementButton> {
  late final NtEntry<double> _entry;
  late final Liana _liana;
  Timer? _holdTimer;
  Timer? _flashTimer;
  bool _isFlashing = false;

  @override
  void initState() {
    super.initState();
    _liana = Provider.of<Liana>(context, listen: false);
    _entry = _liana.getEntry(widget.topicName, defaultValue: 0);
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _flashTimer?.cancel();
    super.dispose();
  }

  void _increment() {
    final double currentValue = _entry.value ?? 0;
    final double newValue = (currentValue + widget.incrementAmount).clamp(
      widget.minValue,
      widget.maxValue,
    );
    _entry.set(newValue);
    _triggerFlash();
  }

  void _triggerFlash() {
    if (mounted) {
      setState(() => _isFlashing = true);
      _flashTimer?.cancel();
      _flashTimer = Timer(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() => _isFlashing = false);
        }
      });
    }
  }

  void _onTapDown(TapDownDetails details) {
    _increment();

    _holdTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        _holdTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
          _increment();
        });
      }
    });
  }

  void _onTapUp(TapUpDetails details) {
    _stopHolding();
  }

  void _onTapCancel() {
    _stopHolding();
  }

  void _stopHolding() {
    _holdTimer?.cancel();
    _holdTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _liana.connectionStatus(),
      initialData: _liana.isConnected,
      builder: (context, snapshot) {
        final bool isConnected = snapshot.data ?? false;
        final backgroundColor = _isFlashing
            ? LianaColors.statusSelected
            : (isConnected ? widget.activeColor : widget.inactiveColor);

        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.bold,
                    color: isConnected ? widget.activeTextColor : widget.inactiveTextColor,
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
