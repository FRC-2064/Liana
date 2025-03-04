import 'package:control_board/utils/control_board_colors.dart';
import 'package:control_board/utils/value_lists.dart';
import 'package:flutter/material.dart';

class SelectedAuto extends StatefulWidget {
  const SelectedAuto({
    required this.setFunction,
    required this.autoList,
    required this.gifBasePath,
    super.key,
  });

  final void Function(String) setFunction;
  final List<String> autoList;
  final String gifBasePath;

  @override
  State<SelectedAuto> createState() => _SelectedAutoState();
}

class _SelectedAutoState extends State<SelectedAuto> {
  late String _selectedAuto;

  @override
  void initState() {
    super.initState();
    _selectedAuto = widget.autoList.first;
  }

  @override
  void didUpdateWidget(covariant SelectedAuto oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.autoList.contains(_selectedAuto)) {
      setState(() {
        _selectedAuto = widget.autoList.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Column with dropdown and GIF viewer integrated
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton<String>(
          value: _selectedAuto,
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
              setState(() {
                _selectedAuto = value;
              });
              widget.setFunction(value);
            }
          },
        ),
        const SizedBox(height: 16),
        // GIF Viewer based on the selected auto
        Image.asset(
          '${widget.gifBasePath}/$_selectedAuto.gif',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
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
