import 'package:liana/services/network_tables/liana.dart';
import 'package:liana/services/network_tables/nt_entry.dart';
import 'package:liana/utils/liana_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NtBoolIndicator extends StatefulWidget {
  const NtBoolIndicator({
    super.key,
    required this.name,
    required this.topicName,
    this.defaultValue = false,
  });
  final String name;
  final String topicName;
  final bool defaultValue;

  @override
  State<NtBoolIndicator> createState() => _NtBoolIndicatorState();
}

class _NtBoolIndicatorState extends State<NtBoolIndicator> {
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _entry.stream(),
      initialData: _entry.value,
      builder: (context, snapshot) => Card(
        color: LianaColors.cardBackground,
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
                  color: LianaColors.buttonText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Container(
                height: 75,
                width: 100,
                decoration: BoxDecoration(
                  color: switch (snapshot.data) {
                    true => LianaColors.boolTrue,
                    false => LianaColors.boolFalse,
                    null => LianaColors.missing,
                  },
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
