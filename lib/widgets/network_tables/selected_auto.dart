import 'package:liana/services/network_tables/nt_entry.dart';
import 'package:liana/utils/liana_colors.dart';
import 'package:flutter/material.dart';

/// A [Widget] to select the autonomous routine that
/// is going to be run that match. Options are read
/// from the robots available and the [NtEntry] is read
/// on the robot on autonomous init.
class SelectedAuto extends StatefulWidget {
  const SelectedAuto({
    required this.setFunction,
    required this.autoList,
    required this.gifBasePath,
    required this.selectedAuto,
    super.key,
  });

  final void Function(String) setFunction;
  final List<String> autoList;
  final String gifBasePath;
  final String? selectedAuto;

  @override
  State<SelectedAuto> createState() => _SelectedAutoState();
}

class _SelectedAutoState extends State<SelectedAuto> {
  @override
  Widget build(BuildContext context) {
    final String? currentValue = widget.selectedAuto != null &&
            widget.autoList.contains(widget.selectedAuto)
        ? widget.selectedAuto
        : (widget.autoList.isNotEmpty ? widget.autoList.first : null);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton<String>(
          value: currentValue,
          dropdownColor: LianaColors.cardBackground,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: LianaColors.buttonText,
          ),
          items: widget.autoList
              .map((auto) => DropdownMenuItem(
                    value: auto,
                    child: Text(auto),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              widget.setFunction(value);
            }
          },
        ),
        const SizedBox(height: 16),
        // if there is no value for the current auto then
        // return the default gif.
        Image.asset(
          '${widget.gifBasePath}/${currentValue ?? 'default'}.gif',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // if the path DNE for that auto, or if there is
            // some other error, return the default gif.
            return Image.asset(
              '${widget.gifBasePath}/default.gif',
              fit: BoxFit.contain,
            );
          },
        ),
      ],
    );
  }
}
