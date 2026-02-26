import 'package:flutter/material.dart';
import 'package:liana/services/network_tables/liana.dart';
import 'package:liana/services/network_tables/nt_entry.dart';
import 'package:liana/utils/liana_colors.dart';
import 'package:provider/provider.dart';

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
  late final NtEntry<double> _entry;

  @override
  void initState() {
    super.initState();
    final liana = Provider.of<Liana>(context, listen: false);
    
    // Parse default value as double
    double initialValue = 160.0;
    try {
      initialValue = double.parse(widget.defaultValue);
    } catch (_) {}

    _entry = liana.getEntry<double>(
      widget.topicName,
      defaultValue: initialValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: _entry.stream(),
      initialData: _entry.value,
      builder: (context, snapshot) {
        double matchTime = snapshot.data ?? 160.0;

        return LayoutBuilder(
          builder: (context, constraints) {
            double totalWidth = constraints.maxWidth;
            double playheadPosition = _getTimelinePosition(matchTime, totalWidth);

            return Container(
              height: widget.height,
              decoration: BoxDecoration(
                color: LianaColors.cardBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: LianaColors.border,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
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

                  // Playhead Shadow (for better contrast)
                  Positioned(
                    left: playheadPosition - 4,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 8,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Playhead
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 100),
                    left: playheadPosition - 1.5,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 3,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.8),
                            blurRadius: 4,
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
    bool isActive = matchTime <= startTime && matchTime > (startTime - duration);
    bool isPassed = matchTime <= (startTime - duration);

    // Dynamic color based on state
    Color segmentColor = isPassed 
        ? color.withOpacity(0.15) 
        : isActive 
            ? color.withOpacity(0.7) 
            : color.withOpacity(0.35);

    return Expanded(
      flex: duration,
      child: Container(
        decoration: BoxDecoration(
          color: segmentColor,
          border: Border(
            right: BorderSide(
              color: LianaColors.border.withOpacity(0.4),
              width: 1,
            ),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive 
                  ? Colors.white 
                  : LianaColors.buttonText.withOpacity(isPassed ? 0.3 : 0.6),
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }

  double _getTimelinePosition(double matchTime, double totalWidth) {
    if (matchTime < 0) return totalWidth;
    if (matchTime > 160) return 0;

    double elapsed = 160 - matchTime;
    double percentage = elapsed / 160;

    return percentage * totalWidth;
  }
}
