import 'dart:io';

import 'package:flutter/material.dart';
import 'package:liana/services/network_tables/nt_entry.dart';
import 'package:liana/services/network_tables/nt_topic.dart';
import 'package:liana/utils/liana_colors.dart';
import 'package:liana/widgets/network_tables/nt_value_builder.dart';

/// A [Widget] to select the autonomous routine that
/// is going to be run that match. Options are read
/// from the robots available and the [NtEntry] is read
/// on the robot on autonomous init.
class SelectedAuto extends StatefulWidget {
  final NtTopic<List<String>> availableAutosTopic;
  final NtTopic<String> selectedAutoTopic;
  final String gifBasePath;

  const SelectedAuto({
    required this.availableAutosTopic,
    required this.selectedAutoTopic,
    required this.gifBasePath,
    super.key,
  });

  @override
  State<SelectedAuto> createState() => _SelectedAutoState();
}

class _SelectedAutoState extends State<SelectedAuto> {
  String? _scheduledSelection;

  void _repairSelection(
    List<String> autos,
    NtValue<String> selected,
    NtEntry<String> entry,
  ) {
    if (autos.isEmpty ||
        (selected.hasValue && autos.contains(selected.value))) {
      _scheduledSelection = null;
      return;
    }
    final replacement = autos.first;
    if (_scheduledSelection == replacement) return;
    _scheduledSelection = replacement;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _scheduledSelection != replacement) return;
      entry.set(replacement);
      _scheduledSelection = null;
    });
  }

  Widget _gif(String path) {
    Widget fallback() => Image.asset(
      'assets/gifs/default.gif',
      width: 480,
      height: 270,
      fit: BoxFit.cover,
    );
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        width: 480,
        height: 270,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback(),
      );
    }
    return Image.file(
      File(path),
      width: 480,
      height: 270,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => fallback(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NtValueBuilder<List<String>>(
      topic: widget.availableAutosTopic,
      builder: (context, available, availableEntry) {
        final autos = available.value ?? const <String>[];
        return NtValueBuilder<String>(
          topic: widget.selectedAutoTopic,
          builder: (context, selected, selectedEntry) {
            _repairSelection(autos, selected, selectedEntry);
            final current = selected.hasValue && autos.contains(selected.value)
                ? selected.value
                : autos.firstOrNull;
            final gifPath = '${widget.gifBasePath}/${current ?? 'default'}.gif';
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: LianaColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: LianaColors.border, width: 1.5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: current,
                      hint: const Text('No autos available'),
                      dropdownColor: LianaColors.surface,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: LianaColors.buttonText,
                      ),
                      items: autos
                          .map(
                            (auto) => DropdownMenuItem(
                              value: auto,
                              child: Text(auto),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: autos.isEmpty
                          ? null
                          : (value) {
                              if (value != null) selectedEntry.set(value);
                            },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(
                      color: LianaColors.border,
                      width: 1.5,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: SizedBox(
                    width: 480,
                    height: 270,
                    child: _gif(gifPath),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
