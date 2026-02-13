import 'package:liana/utils/liana_colors.dart';
import 'package:liana/widgets/network_tables/nt_adjustment.dart';
import 'package:flutter/material.dart';

class MainLayout2026 extends StatefulWidget {
  const MainLayout2026({super.key});

  @override
  State<MainLayout2026> createState() => _MainLayout2026State();
}

class _MainLayout2026State extends State<MainLayout2026> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            LianaColors.background,
            LianaColors.cardBackground,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: LianaColors.border.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Wrap(
                        spacing: 60,
                        runSpacing: 40,
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: const [
                          NtAdjustment(
                            title: 'HOOD',
                            topicName: '/Robot/HoodAngle',
                            incrementAmount: 1.0,
                            defaultValue: 0.0,
                          ),
                          NtAdjustment(
                            title: 'FLYWHEEL',
                            topicName: '/Robot/FlywheelRPM',
                            incrementAmount: 1.0,
                            defaultValue: 0.0,
                          ),
                          NtAdjustment(
                            title: 'TURRET',
                            topicName: '/Robot/TurretAngle',
                            incrementAmount: 1.0,
                            defaultValue: 0.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
