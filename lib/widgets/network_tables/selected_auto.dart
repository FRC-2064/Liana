import 'package:control_board/utils/control_board_colors.dart';
import 'package:flutter/material.dart';

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
          dropdownColor: ControlBoardColors.cardBackground,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ControlBoardColors.buttonText,
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
        Image.asset(
          '${widget.gifBasePath}/${currentValue ?? 'default'}.gif',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback GIF
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
