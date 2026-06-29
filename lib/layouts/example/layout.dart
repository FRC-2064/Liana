import 'package:flutter/material.dart';
import 'package:liana/layouts/example/topics.dart';
import 'package:liana/layouts/example/values.dart';
import 'package:liana/utils/liana_colors.dart';
import 'package:liana/widgets/network_tables/nt_adjustment.dart';
import 'package:liana/widgets/network_tables/nt_bool.dart';
import 'package:liana/widgets/network_tables/nt_button_group.dart';
import 'package:liana/widgets/network_tables/timer.dart';

/// A [Widget] layout that serves as a copy-and-edit starter layout for students.
class ExampleLayout extends StatelessWidget {
  const ExampleLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LianaColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 1100;
            final panels = <Widget>[const _MatchPanel(), const _ControlPanel()];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Student Control Board',
                    style: TextStyle(
                      color: LianaColors.headerText,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Edit topics.dart, values.dart, and layout.dart to build your board.',
                    style: TextStyle(color: LianaColors.missing, fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  if (wide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: panels[0]),
                        const SizedBox(width: 24),
                        Expanded(child: panels[1]),
                      ],
                    )
                  else
                    Column(spacing: 24, children: panels),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MatchPanel extends StatelessWidget {
  const _MatchPanel();

  @override
  Widget build(BuildContext context) {
    return const _ExampleSection(
      title: 'Match status',
      child: Column(
        children: [
          NtTimer(topic: ExampleTopics.matchTime, fontSize: 72),
          SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              NtBool(name: 'Robot Ready', topic: ExampleTopics.robotReady),
              NtBool(name: 'Has Piece', topic: ExampleTopics.hasGamePiece),
              NtBool(
                name: 'Mechanism',
                topic: ExampleTopics.mechanismEnabled,
                isSwitch: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ControlPanel extends StatelessWidget {
  const _ControlPanel();

  @override
  Widget build(BuildContext context) {
    return _ExampleSection(
      title: 'Operator controls',
      child: Column(
        children: [
          const NtAdjustment(
            title: 'Shot Offset',
            topic: ExampleTopics.shotOffset,
            incrementAmount: ExampleValues.offsetIncrement,
            minValue: ExampleValues.offsetMin,
            maxValue: ExampleValues.offsetMax,
          ),
          const SizedBox(height: 28),
          const _ControlLabel('Scoring target'),
          const SizedBox(height: 12),
          NtButtonGroup<String>(
            topic: ExampleTopics.scoringTarget,
            options: ExampleValues.targets
                .map(
                  (target) => NtButtonOption(
                    value: target,
                    child: Text(_titleCase(target)),
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 28),
          const _ControlLabel('Intake mode'),
          const SizedBox(height: 12),
          NtButtonGroup<String>(
            topic: ExampleTopics.intakeMode,
            options: ExampleValues.intakeModes
                .map(
                  (mode) => NtButtonOption(
                    value: mode,
                    child: Text(_titleCase(mode)),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _ExampleSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _ExampleSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: LianaColors.headerText,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _ControlLabel extends StatelessWidget {
  final String text;

  const _ControlLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: LianaColors.buttonText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

String _titleCase(String value) {
  final lower = value.toLowerCase();
  return '${lower[0].toUpperCase()}${lower.substring(1)}';
}
