import 'package:liana/services/network_tables/liana.dart';
import 'package:liana/services/network_tables/nt_entry.dart';
import 'package:liana/utils/liana_colors.dart';
import 'package:flutter/material.dart';
import 'package:liana/widgets/network_tables/nt_increment_button.dart';
import 'package:provider/provider.dart';

class NtAdjustment extends StatefulWidget {
  const NtAdjustment({
    super.key,
    required this.topicName,
    required this.incrementAmount,
    required this.defaultValue,
    required this.title,
    this.positiveText = '+',
    this.negativeText = '-',
    this.width = 60.0,
    this.height = 60.0,
    this.titleFontSize = 24.0,
    this.valueFontSize = 32.0,
    this.positiveColor = LianaColors.boolTrue,
    this.negativeColor = LianaColors.boolFalse,
  });

  final String topicName;
  final double incrementAmount;
  final double defaultValue;
  final String title;
  final String positiveText;
  final String negativeText;
  final double width;
  final double height;
  final double titleFontSize;
  final double valueFontSize;
  final Color positiveColor;
  final Color negativeColor;

  @override
  State<NtAdjustment> createState() => _NtAdjustmentState();
}

class _NtAdjustmentState extends State<NtAdjustment> {
  late final NtEntry<double> _entry;

  @override
  void initState() {
    super.initState();
    final liana = Provider.of<Liana>(context, listen: false);
    _entry = liana.getEntry(
      widget.topicName,
      defaultValue: widget.defaultValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: _entry.stream(),
      initialData: _entry.value,
      builder: (context, snapshot) {
        final currentValue = snapshot.data ?? widget.defaultValue;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: widget.titleFontSize,
                fontWeight: FontWeight.bold,
                color: LianaColors.headerText,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NtIncrementButton(
                  text: widget.negativeText,
                  incrementAmount: widget.incrementAmount * -1,
                  topicName: widget.topicName,
                  activeColor: widget.negativeColor,
                  inactiveColor: LianaColors.missing,
                  inactiveTextColor: LianaColors.buttonText,
                  activeTextColor: LianaColors.buttonText,
                  fontSize: 24,
                  height: widget.height,
                  width: widget.width,
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 100,
                  child: Center(
                    child: Text(
                      currentValue.toStringAsFixed(1),
                      key: ValueKey(currentValue),
                      style: TextStyle(
                        fontSize: widget.valueFontSize,
                        fontWeight: FontWeight.bold,
                        color: LianaColors.headerText,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                NtIncrementButton(
                  text: widget.positiveText,
                  incrementAmount: widget.incrementAmount,
                  topicName: widget.topicName,
                  activeColor: widget.positiveColor,
                  inactiveColor: LianaColors.missing,
                  inactiveTextColor: LianaColors.buttonText,
                  activeTextColor: LianaColors.buttonText,
                  fontSize: 24,
                  height: widget.height,
                  width: widget.width,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
