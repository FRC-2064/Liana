import 'package:flutter/material.dart';
import 'package:liana/layouts/2025/custom_widgets/hexagon_stack.dart';
import 'package:liana/layouts/2025/topics.dart';
import 'package:liana/layouts/2025/values.dart';
import 'package:liana/utils/liana_colors.dart';
import 'package:liana/widgets/network_tables/button_builders/hexagon_builder.dart';
import 'package:liana/widgets/network_tables/button_builders/m3_expressive_button_builder.dart';
import 'package:liana/widgets/network_tables/button_builders/nt_button_builder.dart';
import 'package:liana/widgets/network_tables/nt_bool.dart';
import 'package:liana/widgets/network_tables/nt_button_group.dart';
import 'package:liana/widgets/network_tables/selected_auto.dart';
import 'package:liana/widgets/network_tables/timer.dart';

/// A [Widget] layout for the 2025 Reefscape competition season.
class ReefscapeLayout extends StatelessWidget {
  final String gifBasePath;

  const ReefscapeLayout({required this.gifBasePath, super.key});

  Widget _button<T>(
    BuildContext context,
    NtButtonOption<T> option,
    NtButtonItemState state, {
    double width = 150,
    double height = 75,
    double fontSize = 18,
    NtButtonBuilder builder = const M3ExpressiveButtonBuilder(),
  }) {
    final background = state.isMissing
        ? LianaColors.background
        : state.isSelected
        ? LianaColors.statusSelected
        : LianaColors.statusUnselected;
    final foreground = state.isMissing
        ? LianaColors.missing
        : state.isSelected
        ? LianaColors.background
        : LianaColors.buttonText;
    return SizedBox(
      width: width,
      height: height,
      child: builder.build(
        context,
        isSelected: state.isSelected,
        isMissing: state.isMissing,
        backgroundColor: background,
        onPressed: state.onPressed,
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: foreground,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          child: option.child,
        ),
      ),
    );
  }

  Widget _heading(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: LianaColors.headerText,
    ),
  );

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
                    const NtTimer(topic: ReefscapeTopics.gameTime),
                    const SizedBox(height: 32),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NtBool(name: 'Coral', topic: ReefscapeTopics.hasCoral),
                        SizedBox(width: 16),
                        NtBool(name: 'Clamped', topic: ReefscapeTopics.clamped),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SelectedAuto(
                      availableAutosTopic: ReefscapeTopics.availableAutos,
                      selectedAutoTopic: ReefscapeTopics.selectedAuto,
                      gifBasePath: gifBasePath,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _heading('Cage'),
                    const SizedBox(height: 16),
                    NtButtonGroup<String>(
                      topic: ReefscapeTopics.cage,
                      options: ReefscapeValues.cageLocations
                          .map(
                            (value) => NtButtonOption(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                      itemBuilder: (context, option, state) => _button(
                        context,
                        option,
                        state,
                        width: 110,
                        height: 50,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 24),
                    NtButtonGroup<String>(
                      topic: ReefscapeTopics.reefLocation,
                      options: ReefscapeValues.reefLocations
                          .map(
                            (value) => NtButtonOption(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                      itemBuilder: (context, option, state) => _button(
                        context,
                        option,
                        state,
                        width: double.infinity,
                        height: double.infinity,
                        fontSize: 22.5,
                        builder: const HexagonBuilder(),
                      ),
                      layoutBuilder: (context, children) =>
                          HexagonButtonLayout(children: children),
                    ),
                    const SizedBox(height: 24),
                    _heading('Feeder'),
                    const SizedBox(height: 16),
                    NtButtonGroup<String>(
                      topic: ReefscapeTopics.feeder,
                      options: ReefscapeValues.feederLocations
                          .map(
                            (value) => NtButtonOption(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _heading('Level'),
                    const SizedBox(height: 16),
                    NtButtonGroup<int>(
                      topic: ReefscapeTopics.reefLevel,
                      options: ReefscapeValues.reefLevels
                          .map(
                            (level) => NtButtonOption(
                              value: level,
                              child: Text(switch (level) {
                                0 => 'Remove Algae',
                                1 => 'Level 1 (Trough)',
                                _ => 'Level $level',
                              }),
                            ),
                          )
                          .toList(),
                      layoutBuilder: (context, children) =>
                          Column(spacing: 12, children: children),
                    ),
                    const SizedBox(height: 24),
                    _heading('Score'),
                    const SizedBox(height: 16),
                    NtButtonGroup<String>(
                      topic: ReefscapeTopics.scoreLocation,
                      options: ReefscapeValues.scoreLocations
                          .map(
                            (value) => NtButtonOption(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                      layoutBuilder: (context, children) =>
                          Column(spacing: 12, children: children),
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
