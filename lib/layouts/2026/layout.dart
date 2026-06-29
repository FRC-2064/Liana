import 'package:flutter/material.dart';
import 'package:liana/layouts/2026/topics.dart';
import 'package:liana/layouts/2026/values.dart';
import 'package:liana/utils/liana_colors.dart';
import 'package:liana/widgets/network_tables/nt_adjustment.dart';
import 'package:liana/widgets/network_tables/nt_bool.dart';
import 'package:liana/widgets/network_tables/selected_auto.dart';
import 'package:liana/widgets/network_tables/timer.dart';

/// A [Widget] layout for the 2026 mechanism prototype.
class PrototypeLayout extends StatelessWidget {
  final String gifBasePath;

  const PrototypeLayout({required this.gifBasePath, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LianaColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    const NtTimer(topic: PrototypeTopics.gameTime),
                    const SizedBox(height: 24),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NtBool(
                          name: 'At Position',
                          topic: PrototypeTopics.atPosition,
                        ),
                        SizedBox(width: 16),
                        NtBool(
                          name: 'Hopper Full',
                          topic: PrototypeTopics.hopperFull,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SelectedAuto(
                      availableAutosTopic: PrototypeTopics.availableAutos,
                      selectedAutoTopic: PrototypeTopics.selectedAuto,
                      gifBasePath: gifBasePath,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              const Expanded(
                child: Column(
                  children: [
                    NtAdjustment(
                      title: 'HOOD',
                      topic: PrototypeTopics.hoodAngle,
                      incrementAmount: PrototypeValues.hoodIncrement,
                      minValue: PrototypeValues.hoodMin,
                      maxValue: PrototypeValues.hoodMax,
                      titleFontSize: 28,
                      valueFontSize: 36,
                      negativeText: 'DOWN',
                      positiveText: 'UP',
                    ),
                    SizedBox(height: 16),
                    Divider(color: LianaColors.border),
                    SizedBox(height: 16),
                    NtAdjustment(
                      title: 'FLYWHEEL',
                      topic: PrototypeTopics.flywheelRpm,
                      incrementAmount: PrototypeValues.flywheelIncrement,
                      minValue: PrototypeValues.flywheelMin,
                      maxValue: PrototypeValues.flywheelMax,
                      titleFontSize: 28,
                      valueFontSize: 36,
                      negativeText: 'SLOWER',
                      positiveText: 'FASTER',
                    ),
                    SizedBox(height: 16),
                    Divider(color: LianaColors.border),
                    SizedBox(height: 16),
                    NtAdjustment(
                      title: 'TURRET',
                      topic: PrototypeTopics.turretAngle,
                      incrementAmount: PrototypeValues.turretIncrement,
                      minValue: PrototypeValues.turretMin,
                      maxValue: PrototypeValues.turretMax,
                      titleFontSize: 28,
                      valueFontSize: 36,
                      negativeText: 'LEFT',
                      positiveText: 'RIGHT',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
