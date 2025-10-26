import 'package:liana/services/network_tables/liana.dart';
import 'package:liana/services/network_tables/nt_entry.dart';
import 'package:liana/utils/liana_colors.dart';
import 'package:liana/widgets/network_tables/button_builders/nt_button_builder.dart';
import 'package:liana/widgets/network_tables/button_builders/rectangle_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NtStatusButton<T> extends StatefulWidget {
  const NtStatusButton({
    super.key,
    required this.topicName,
    required this.valueToSet,
    required this.defaultValue,
    required this.text,
    this.width = 150.0,
    this.height = 75.0,
    this.fontSize = 20.0,
    this.builder = const RectangleBuilder(),
    this.selectedColor = LianaColors.statusSelected,
    this.unselectedColor = LianaColors.statusUnselected,
    this.selectedTextColor = LianaColors.background,
    this.unselectedTextColor = LianaColors.buttonText,
    this.missingDataColor = LianaColors.background,
    this.missingDataTextColor = LianaColors.missing,
  });
  final String topicName;
  final T valueToSet;
  final T defaultValue;
  final String text;
  final double width;
  final double height;
  final double fontSize;
  final NtButtonBuilder builder;
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final Color missingDataColor;
  final Color missingDataTextColor;

  @override
  State<NtStatusButton> createState() => _NtStatusButtonState();
}

class _NtStatusButtonState<T> extends State<NtStatusButton<T>> {
  late final NtEntry<T> _entry;

  @override
  void initState() {
    super.initState();
    final liana = Provider.of<Liana>(context, listen: false);
    _entry = liana.getEntry(
      widget.topicName,
      defaultValue: widget.defaultValue,
    );
  }

  void _onPress() {
    _entry.set(widget.valueToSet);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: _entry.stream(),
      initialData: _entry.value,
      builder: (context, snapshot) {
        final bool hasData = snapshot.data != null;
        final bool isSelected = hasData && snapshot.data == widget.valueToSet;
        final Color bgColor = !hasData
            ? widget.missingDataColor
            : (isSelected ? widget.selectedColor : widget.unselectedColor);
        final Color textColor = !hasData
            ? widget.missingDataTextColor
            : (isSelected
                ? widget.selectedTextColor
                : widget.unselectedTextColor);
        final Widget child = Text(
          widget.text,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          textAlign: TextAlign.center,
        );
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: widget.builder.build(
            context,
            isSelected,
            bgColor,
            _onPress,
            child,
          ),
        );
      },
    );
  }
}
