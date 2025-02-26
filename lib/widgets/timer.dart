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
      // Parse the seconds value, which is in 0.000 format
      double seconds = double.parse(secondsString);

      // Convert to M:SS format
      int totalSeconds = seconds.floor();
      int minutes = totalSeconds ~/ 60;
      int remainingSeconds = totalSeconds % 60;

      return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Invalid Time';
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

        // Check if we need to toggle color (between 30 and 25 seconds)
        try {
          double seconds = double.parse(snapshot.data!);
          int currentSecond = seconds.floor();

          // Toggle color when second changes and within the range
          if (seconds <= 30 && seconds > 25 && currentSecond != _lastSecond) {
            _isRed = !_isRed;
            _lastSecond = currentSecond;
          } else if (seconds <= 25 || seconds > 30) {
            _isRed = false;
          }

          return Text(
            timeString,
            style: TextStyle(
              color: _isRed ? Colors.red : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          );
        } catch (e) {
          // Handle parsing errors
          return Text(
            timeString,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          );
        }
      },
    );
  }
}