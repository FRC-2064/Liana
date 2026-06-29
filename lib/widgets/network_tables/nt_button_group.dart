import 'package:flutter/material.dart';
import 'package:liana/services/network_tables/nt_topic.dart';
import 'package:liana/utils/liana_colors.dart';
import 'package:liana/widgets/network_tables/button_builders/m3_expressive_button_builder.dart';
import 'package:liana/widgets/network_tables/nt_value_builder.dart';

final class NtButtonOption<T> {
  final T value;
  final Widget child;

  const NtButtonOption({required this.value, required this.child});
}

final class NtButtonItemState {
  final bool isSelected;
  final bool isMissing;
  final VoidCallback onPressed;

  const NtButtonItemState({
    required this.isSelected,
    required this.isMissing,
    required this.onPressed,
  });
}

typedef NtButtonItemBuilder<T> =
    Widget Function(
      BuildContext context,
      NtButtonOption<T> option,
      NtButtonItemState state,
    );

typedef NtButtonGroupLayoutBuilder =
    Widget Function(BuildContext context, List<Widget> children);

/// A [Widget] that groups multiple buttons to select and write
/// a single value to a Network Table topic.
class NtButtonGroup<T> extends StatelessWidget {
  final NtTopic<T> topic;
  final List<NtButtonOption<T>> options;
  final NtButtonItemBuilder<T>? itemBuilder;
  final NtButtonGroupLayoutBuilder? layoutBuilder;
  final double spacing;
  final double runSpacing;
  final WrapAlignment alignment;

  NtButtonGroup({
    required this.topic,
    required this.options,
    this.itemBuilder,
    this.layoutBuilder,
    this.spacing = 8,
    this.runSpacing = 8,
    this.alignment = WrapAlignment.center,
    super.key,
  }) {
    final values = <T>{};
    for (final option in options) {
      if (!values.add(option.value)) {
        throw ArgumentError.value(
          option.value,
          'options',
          'Duplicate option value',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NtValueBuilder<T>(
      topic: topic,
      builder: (context, current, entry) {
        final children = options
            .map((option) {
              final state = NtButtonItemState(
                isSelected: current.hasValue && current.value == option.value,
                isMissing: !current.hasValue,
                onPressed: () => entry.set(option.value),
              );
              return itemBuilder?.call(context, option, state) ??
                  _defaultItemBuilder(context, option, state);
            })
            .toList(growable: false);

        return layoutBuilder?.call(context, children) ??
            Wrap(
              spacing: spacing,
              runSpacing: runSpacing,
              alignment: alignment,
              children: children,
            );
      },
    );
  }

  Widget _defaultItemBuilder(
    BuildContext context,
    NtButtonOption<T> option,
    NtButtonItemState state,
  ) {
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
      width: 150,
      height: 75,
      child: const M3ExpressiveButtonBuilder().build(
        context,
        isSelected: state.isSelected,
        isMissing: state.isMissing,
        backgroundColor: background,
        onPressed: state.onPressed,
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: foreground,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          child: option.child,
        ),
      ),
    );
  }
}
