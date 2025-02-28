import 'package:control_board/utils/control_board_colors.dart';
import 'package:control_board/utils/value_lists.dart';
import 'package:flutter/material.dart';

class SelectedAuto extends StatefulWidget {
  const SelectedAuto({
    required this.setFunction,
    super.key
  });

  final void Function(String) setFunction;

  @override
  State<SelectedAuto> createState() => _SelectedAutoState();
}

class _SelectedAutoState extends State<SelectedAuto> {
  String _selectedAuto = ValueLists.autoList.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedAuto,
      dropdownColor: ControlBoardColors.cardBackground,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: ControlBoardColors.buttonText,
      ),
      items: ValueLists.autoList
      .map((auto) => DropdownMenuItem(
        value: auto,
        child: Text(auto)
      )).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedAuto = value;
          });
          widget.setFunction(value);
        }
      },
    );
  }
}
