import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Timer extends StatefulWidget {
  const Timer({
    required this.timeListenable,
    super.key,
  });

  final Stream<String> timeListenable;

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  bool _isRed = false;
  int _lastSecond = -1;

  String _formatTime(String secondsString) {
    try {
      if (secondsString == '-1') {
        return '--:--';
      }
      double seconds = double.parse(secondsString);

      // Convert to M:SS format
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
    return StreamBuilder(
      stream: widget.timeListenable,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text('--:--');
        }

        String timeString = _formatTime(snapshot.data!);

        try {
          double seconds = double.parse(snapshot.data!);
          int currentSecond = seconds.floor();

          if (seconds <= 30 && seconds > 25 && currentSecond != _lastSecond) {
            _isRed = !_isRed;
            _lastSecond = currentSecond;
          } else if (seconds <= 25 || seconds > 30) {
            _isRed = false;
          }

          return Text(
            timeString,
            style: TextStyle(
              color: _isRed ? Colors.red : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 125,
            ),
          );
        } catch (e) {
          // Handle parsing errors
          return Text(
            timeString,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 125,
            ),
          );
        }
      },
    );
  }
}