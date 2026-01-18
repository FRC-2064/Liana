import 'package:liana/services/network_tables/liana.dart';
import 'package:liana/services/network_tables/nt_entry.dart';
import 'package:liana/utils/liana_colors.dart';
import 'package:flutter/material.dart';
import 'package:liana/widgets/network_tables/nt_incriment_button.dart';
import 'package:provider/provider.dart';

class NtAdjustment extends StatefulWidget {
  const NtAdjustment({
    super.key,
    required this.topicName,
    required this.valueToIncriment,
    required this.defaultValue,
    required this.title,
    this.positiveText = '+',
    this.negativeText = '-',
    this.width = 150.0,
    this.height = 75.0,
    this.titleFontSize = 20.0,
    this.valueFontSize = 10.0,
    this.positiveColor = LianaColors.boolTrue,
    this.negativeColor = LianaColors.boolFalse,
  });
  final String topicName;
  final double valueToIncriment;
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
        return Row(
          mainAxisAlignment: .center,
          children: [
            NtIncrimentButton(
              text: widget.negativeText,
              incrimentAmount: widget.valueToIncriment * -1,
              topicName: widget.topicName,
              activeColor: widget.negativeColor,
            ),
            NtIncrimentButton(
              text: widget.positiveText,
              incrimentAmount: widget.valueToIncriment,
              topicName: widget.topicName,
              activeColor: widget.positiveColor,
            ),
          ],
        );
      },
    );
  }
}
