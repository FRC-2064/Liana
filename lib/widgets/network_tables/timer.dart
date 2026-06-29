import 'package:flutter/material.dart';
import 'package:liana/services/network_tables/nt_topic.dart';
import 'package:liana/utils/liana_colors.dart';
import 'package:liana/widgets/network_tables/nt_value_builder.dart';

/// [Widget] to display the remaining match time.
class NtTimer extends StatelessWidget {
  final NtTopic<double> topic;
  final double fontSize;
  final Color defaultColor;
  final Color flashColor;
  final double flashStartTime;
  final double flashEndTime;

  const NtTimer({
    required this.topic,
    this.fontSize = 100,
    this.defaultColor = Colors.white,
    this.flashColor = LianaColors.statusSelected,
    this.flashStartTime = 30,
    this.flashEndTime = 25,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return NtValueBuilder<double>(
      topic: topic,
      builder: (context, value, entry) => _FlashingTime(
        seconds: value.value,
        fontSize: fontSize,
        defaultColor: defaultColor,
        flashColor: flashColor,
        flashStartTime: flashStartTime,
        flashEndTime: flashEndTime,
      ),
    );
  }
}

class _FlashingTime extends StatefulWidget {
  final double? seconds;
  final double fontSize;
  final Color defaultColor;
  final Color flashColor;
  final double flashStartTime;
  final double flashEndTime;

  const _FlashingTime({
    required this.seconds,
    required this.fontSize,
    required this.defaultColor,
    required this.flashColor,
    required this.flashStartTime,
    required this.flashEndTime,
  });

  @override
  State<_FlashingTime> createState() => _FlashingTimeState();
}

class _FlashingTimeState extends State<_FlashingTime> {
  bool _flash = false;
  int? _lastSecond;

  @override
  void didUpdateWidget(covariant _FlashingTime oldWidget) {
    super.didUpdateWidget(oldWidget);
    final seconds = widget.seconds;
    if (seconds == null) {
      _flash = false;
      _lastSecond = null;
      return;
    }
    final second = seconds.floor();
    if (seconds <= widget.flashStartTime &&
        seconds > widget.flashEndTime &&
        second != _lastSecond) {
      _flash = !_flash;
    } else if (seconds <= widget.flashEndTime ||
        seconds > widget.flashStartTime) {
      _flash = false;
    }
    _lastSecond = second;
  }

  String _format(double? seconds) {
    if (seconds == null || seconds < 0) return '--:--';
    final total = seconds.floor();
    return '${total ~/ 60}:${(total % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _format(widget.seconds),
        style: TextStyle(
          color: _flash ? widget.flashColor : widget.defaultColor,
          fontWeight: FontWeight.w800,
          fontSize: widget.fontSize,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
