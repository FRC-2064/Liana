import 'package:flutter/material.dart';
import 'package:liana/services/network_tables/liana.dart';
import 'package:liana/services/network_tables/nt_entry.dart';
import 'package:provider/provider.dart';

class NtIncrementButton extends StatefulWidget {
  const NtIncrementButton({
    super.key,
    required this.topicName,
    required this.text,
    required this.incrementAmount,
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
  final double incrementAmount;
  final double width;
  final double height;
  final double fontSize;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final Color activeColor;
  final Color inactiveColor;

  @override
  State<NtIncrementButton> createState() => _NtIncrementButtonState();
}

class _NtIncrementButtonState extends State<NtIncrementButton> {
  late final NtEntry<double> _entry;
  late final Liana _liana;

  @override
  void initState() {
    super.initState();
    _liana = Provider.of<Liana>(context, listen: false);
    _entry = _liana.getEntry(widget.topicName, defaultValue: 0);
  }

  void _onPress() {
    _entry.set((_entry.value ?? 0) + widget.incrementAmount);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _liana.connectionStatus(),
      initialData: _liana.isConnected,
      builder: (context, snapshot) {
        final bool isConnected = snapshot.data ?? false;
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: ElevatedButton(
            onPressed: _onPress,
            style: ElevatedButton.styleFrom(
              backgroundColor: isConnected ? widget.activeColor : widget.inactiveColor,
              foregroundColor: isConnected ? widget.activeTextColor : widget.inactiveTextColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
