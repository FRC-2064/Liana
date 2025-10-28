import 'package:liana/services/network_tables/liana.dart';
import 'package:liana/services/network_tables/nt_entry.dart';
import 'package:liana/utils/liana_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NtBool extends StatefulWidget {
  const NtBool({
    super.key,
    required this.name,
    required this.topicName,
    this.defaultValue = false,
    this.isSwitch = false,
    this.trueColor = LianaColors.boolTrue,
    this.falseColor = LianaColors.boolFalse,
    this.missingColor = LianaColors.missing,
    this.textColor = LianaColors.buttonText,
    this.bgColor = LianaColors.cardBackground,
    this.indicatorBorderColor = LianaColors.border,
    this.indicatorHeight = 75.0,
    this.indicatorWidth = 100.0,
    this.indicatorBorderRadius = 8.0,
    this.indicatorBorderWidth = 0.5,
  });
  final String name;
  final String topicName;
  final bool defaultValue;
  final bool isSwitch;
  final Color trueColor;
  final Color falseColor;
  final Color missingColor;
  final Color textColor;
  final Color bgColor;
  final Color indicatorBorderColor;
  final double indicatorHeight;
  final double indicatorWidth;
  final double indicatorBorderRadius;
  final double indicatorBorderWidth;

  @override
  State<NtBool> createState() => _NtBoolState();
}

class _NtBoolState extends State<NtBool> {
  late final NtEntry<bool> _entry;

  @override
  void initState() {
    super.initState();
    final liana = Provider.of<Liana>(context, listen: false);

    _entry = liana.getEntry<bool>(
      widget.topicName,
      defaultValue: widget.defaultValue,
    );
  }

  void _onTap(bool? currentValue) {
    if (widget.isSwitch && currentValue != null) {
      _entry.set(!currentValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _entry.stream(),
        initialData: _entry.value,
        builder: (context, snapshot) {
          final bool? currentValue = snapshot.data;
          final Color indicatorColor = switch (currentValue) {
            true => widget.trueColor,
            false => widget.falseColor,
            null => widget.missingColor,
          };

          final Widget indicatorCard = Card(
            color: widget.bgColor,
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
                top: 2,
                left: 10,
                right: 10,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: widget.indicatorHeight,
                    width: widget.indicatorWidth,
                    decoration: BoxDecoration(
                      color: indicatorColor,
                      borderRadius:
                          BorderRadius.circular(widget.indicatorBorderRadius),
                      border: widget.indicatorBorderWidth > 0
                          ? Border.all(
                              width: widget.indicatorBorderWidth,
                              color: widget.indicatorBorderColor,
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          );

          if (widget.isSwitch) {
            return GestureDetector(
              onTap: () => _onTap(currentValue),
              child: indicatorCard,
            );
          }

          return indicatorCard;
        });
  }
}
