import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:liana/services/network_tables/liana.dart';
import 'package:liana/services/network_tables/nt_entry.dart';

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
  late final NtEntry<String> _entry;
  bool _isRed = false;
  int _lastSecond = -1;

  @override
  void initState() {
    super.initState();
    final liana = Provider.of<Liana>(context, listen: false);
    _entry = liana.getEntry<String>(
      widget.topicName,
      defaultValue: widget.defaultValue,
    );
  }

  String _formatTime(String secondsString) {
    try {
      if (secondsString == '-1') {
        return '--:--';
      }
      double seconds = double.parse(secondsString);
      int totalSeconds = seconds.floor();
      int minutes = totalSeconds ~/ 60;
      int remainingSeconds = totalSeconds % 60;

      return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
    } catch (e) {
      return '--:--';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: _entry.stream(),
      initialData: _entry.value,
      builder: (context, snapshot) {
        String data = snapshot.data ?? widget.defaultValue;
        String timeString = _formatTime(data);

        try {
          double seconds = double.parse(data);
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
        } catch (e) {
          return Text(
            timeString,
            style: TextStyle(
              color: widget.defaultColor,
              fontWeight: FontWeight.bold,
              fontSize: widget.fontSize,
            ),
          );
        }
      },
    );
  }
}
