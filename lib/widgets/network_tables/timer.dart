import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:liana/services/network_tables/liana.dart';
import 'package:liana/services/network_tables/nt_entry.dart';

/// [Widget] to display the remaining match time.
class NtTimer extends StatefulWidget {
  const NtTimer({
    super.key,
    required this.topicName,
    this.defaultValue = '-1',
    this.fontSize = 125.0,
    this.defaultColor = Colors.white,
    this.flashColor = Colors.red,
    this.flashStartTime = 30.0,
    this.flashEndTime = 25.0,
  });

  final String topicName;
  final String defaultValue;
  final double fontSize;
  final Color defaultColor;
  final Color flashColor;
  final double flashStartTime;
  final double flashEndTime;

  @override
  State<NtTimer> createState() => _NtTimerState();
}

class _NtTimerState extends State<NtTimer> {
  late final NtEntry<double> _entry;
  bool _isRed = false;
  int _lastSecond = -1;

  @override
  void initState() {
    super.initState();
    final liana = Provider.of<Liana>(context, listen: false);
    
    double initialValue = -1.0;
    try {
      initialValue = double.parse(widget.defaultValue);
    } catch (_) {}

    _entry = liana.getEntry<double>(
      widget.topicName,
      defaultValue: initialValue,
    );
  }

  String _formatTime(double seconds) {
    if (seconds < 0) {
      return '--:--';
    }
    int totalSeconds = seconds.floor();
    int minutes = totalSeconds ~/ 60;
    int remainingSeconds = totalSeconds % 60;

    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: _entry.stream(),
      initialData: _entry.value,
      builder: (context, snapshot) {
        double seconds = snapshot.data ?? -1.0;
        String timeString = _formatTime(seconds);

        int currentSecond = seconds.floor();

        if (seconds <= widget.flashStartTime &&
            seconds > widget.flashEndTime &&
            currentSecond != _lastSecond) {
          _isRed = !_isRed;
          _lastSecond = currentSecond;
        } else if (seconds <= widget.flashEndTime ||
            seconds > widget.flashStartTime) {
          _isRed = false;
        }

        return Text(
          timeString,
          style: TextStyle(
            color: _isRed ? widget.flashColor : widget.defaultColor,
            fontWeight: FontWeight.bold,
            fontSize: widget.fontSize,
          ),
        );
      },
    );
  }
}
