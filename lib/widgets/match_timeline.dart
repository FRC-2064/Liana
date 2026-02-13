import 'package:flutter/material.dart';
import 'package:liana/services/network_tables/liana.dart';
import 'package:liana/services/network_tables/nt_entry.dart';
import 'package:liana/utils/liana_colors.dart';
import 'package:provider/provider.dart';

/// Timeline widget showing match phases and hub shifts for 2026 REBUILT
class MatchTimeline extends StatefulWidget {
  const MatchTimeline({
    super.key,
    required this.topicName,
    this.defaultValue = '160',
    this.height = 60.0,
  });

  final String topicName;
  final String defaultValue;
  final double height;

  @override
  State<MatchTimeline> createState() => _MatchTimelineState();
}

class _MatchTimelineState extends State<MatchTimeline> {
  late final NtEntry<String> _entry;

  @override
  void initState() {
    super.initState();
    final liana = Provider.of<Liana>(context, listen: false);
    _entry = liana.getEntry<String>(
      widget.topicName,
      defaultValue: widget.defaultValue,
    );
  }

  double _getMatchTime(String timeString) {
    try {
      return double.parse(timeString);
    } catch (e) {
      return -1;
    }
  }

  // Returns the current phase name and if hub is active
  Map<String, dynamic> _getCurrentPhase(double matchTime) {
    // Match runs from 160 seconds down to 0
    double elapsed = 160 - matchTime;

    if (matchTime < 0) {
      return {'name': 'PRE-MATCH', 'active': 'both', 'color': LianaColors.missing};
    }

    // Auto: 0-20 seconds (both hubs active)
    if (elapsed >= 0 && elapsed < 20) {
      return {'name': 'AUTO', 'active': 'both', 'color': LianaColors.boolTrue};
    }

    // Transition: 20-30 seconds (both hubs active)
    if (elapsed >= 20 && elapsed < 30) {
      return {'name': 'TRANSITION', 'active': 'both', 'color': LianaColors.headerText};
    }

    // Teleop Phases: 30-130 seconds (4 shifts, 25 sec each = 100 seconds)
    // Total match is 20 + 10 + 100 + 30 = 160 seconds
    if (elapsed >= 30 && elapsed < 130) {
      double teleopTime = elapsed - 30;
      int phaseIndex = (teleopTime / 25).floor();

      // Phases 0-3 (4 total phases of 25 seconds each = 100 seconds)
      // Each alliance gets 2 shifts (alternating)
      if (phaseIndex < 4) {
        // Alternate between red and blue based on auto winner
        // For now, we'll show which alliance's hub is active
        bool isEvenPhase = phaseIndex % 2 == 0;
        return {
          'name': 'SHIFT ${phaseIndex + 1}',
          'active': isEvenPhase ? 'red' : 'blue',
          'color': LianaColors.cardBackground,
        };
      }
    }

    // Endgame: last 30 seconds (both hubs active)
    if (matchTime <= 30) {
      return {'name': 'ENDGAME', 'active': 'both', 'color': LianaColors.headerText};
    }

    return {'name': 'UNKNOWN', 'active': 'none', 'color': LianaColors.missing};
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: _entry.stream(),
      initialData: _entry.value,
      builder: (context, snapshot) {
        String data = snapshot.data ?? widget.defaultValue;
        double matchTime = _getMatchTime(data);
        Map<String, dynamic> phaseInfo = _getCurrentPhase(matchTime);

        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: LianaColors.cardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: LianaColors.border,
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              // Timeline segments
              Row(
                children: [
                  _buildSegment('AUTO', 20, LianaColors.boolTrue, matchTime, 160),
                  _buildSegment('TRANS', 10, LianaColors.headerText, matchTime, 140),
                  _buildSegment('S1', 25, LianaColors.cardBackground, matchTime, 130),
                  _buildSegment('S2', 25, LianaColors.cardBackground, matchTime, 105),
                  _buildSegment('S3', 25, LianaColors.cardBackground, matchTime, 80),
                  _buildSegment('S4', 25, LianaColors.cardBackground, matchTime, 55),
                  _buildSegment('END', 30, LianaColors.headerText, matchTime, 30),
                ],
              ),

              // Current phase indicator
              Positioned(
                left: _getTimelinePosition(matchTime),
                top: 0,
                bottom: 0,
                child: Container(
                  width: 3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSegment(
    String label,
    int duration,
    Color color,
    double matchTime,
    double startTime,
  ) {
    // Calculate if this segment is currently active
    bool isActive = matchTime <= startTime && matchTime > (startTime - duration);

    return Expanded(
      flex: duration,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isActive ? color : color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isActive ? Colors.white : LianaColors.border,
            width: isActive ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? LianaColors.buttonText : LianaColors.missing,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  double _getTimelinePosition(double matchTime) {
    if (matchTime < 0) return 0;
    if (matchTime > 160) return 0;

    // Calculate position based on elapsed time (0 to 160)
    double elapsed = 160 - matchTime;
    double percentage = elapsed / 160;

    // Get the width of the screen (approximate)
    return percentage * MediaQuery.of(context).size.width;
  }
}
