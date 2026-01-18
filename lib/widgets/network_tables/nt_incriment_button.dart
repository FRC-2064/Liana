import 'package:flutter/material.dart';
import 'package:liana/services/network_tables/liana.dart';
import 'package:liana/services/network_tables/nt_entry.dart';
import 'package:provider/provider.dart';

class NtIncrimentButton extends StatefulWidget {
  const NtIncrimentButton({
    super.key,
    required this.topicName,
    required this.text,
    required this.incrimentAmount,
    required this.width,
    required this.height,
    required this.fontSize,
    required this.activeColor,
    required this.activeTextColor,
    required this.inactiveColor,
    required this.inactiveTextColor,
  });
  final String topicName;
  final String text;
  final double incrimentAmount;
  final double width;
  final double height;
  final double fontSize;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final Color activeColor;
  final Color inactiveColor;

  @override
  State<NtIncrimentButton> createState() => _NtIncrimentButtonState();
}

class _NtIncrimentButtonState extends State<NtIncrimentButton> {
  late final NtEntry<double> _entry;

  @override
  void initState() {
    super.initState();
    final liana = Provider.of<Liana>(context, listen: false);
    _entry = liana.getEntry(widget.topicName, defaultValue: 0);
  }

  void _onPress() {
    _entry.set(_entry.value! + widget.incrimentAmount);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _onPress,
      style: ButtonStyle(alignment: .center),
      child: Text(widget.text),
    );
  }
}
