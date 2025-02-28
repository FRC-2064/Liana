import 'package:flutter/material.dart';

import '../utils/control_board_colors.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  final TextEditingController _teamNumberController = TextEditingController();
  bool _isRobot = false;

  String get _robotIp {
    final team = _teamNumberController.text;
    if (team.length == 4) {
      final firstTwo = team.substring(0, 2);
      final lastTwo = team.substring(2, 4);
      return "10.$firstTwo.$lastTwo.2";
    }
    return "Invalid team number";
  }

  @override
  void dispose() {
    _teamNumberController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ControlBoardColors.background,
      title: Text(
        "Settings",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: ControlBoardColors.headerText,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _teamNumberController,
            style: TextStyle(color: ControlBoardColors.buttonText),
            decoration: InputDecoration(
              labelText: "Team Number",
              labelStyle:
              TextStyle(color: ControlBoardColors.headerText),
              hintText: "Enter 4-digit team number",
              hintStyle: TextStyle(
                  color: ControlBoardColors.buttonText),
              border: OutlineInputBorder(
                borderSide:
                BorderSide(color: ControlBoardColors.headerText),
              ),
            ),
            keyboardType: TextInputType.number,
            maxLength: 4,
          ),
          const SizedBox(height: 16),
          // Lever-style toggle row.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Simulation",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ControlBoardColors.buttonText,
                ),
              ),
              const SizedBox(width: 10),
              LeverSwitch(
                value: _isRobot,
                onChanged: (value) {
                  setState(() {
                    _isRobot = value;
                  });
                },
              ),
              const SizedBox(width: 10),
              Text(
                "Robot",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ControlBoardColors.buttonText,
                ),
              ),
            ],
          ),
          // Show computed robot IP when in Robot mode with a valid team number.
          if (_isRobot && _teamNumberController.text.length == 4)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Robot IP: $_robotIp",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ControlBoardColors.buttonText,
                ),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // If in Robot mode, use the computed IP; otherwise use simulation IP.
            final ip = _isRobot ? _robotIp : "127.0.0.1";
            Navigator.of(context).pop({
              'ip': ip,
              'teamNumber': _teamNumberController.text,
              'isSimulation': !_isRobot,
            });
          },
          child: Text(
            "Save",
            style: TextStyle(color: ControlBoardColors.buttonText),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Cancel",
            style: TextStyle(color: ControlBoardColors.buttonText),
          ),
        ),
      ],
    );
  }
}


class LeverSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const LeverSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        height: 40,
        decoration: BoxDecoration(
          color: value
              ? ControlBoardColors.statusSelected
              : ControlBoardColors.statusUnselected,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              alignment:
              value ? Alignment.centerRight : Alignment.centerLeft,
              duration: const Duration(milliseconds: 200),
              child: Container(
                margin: const EdgeInsets.all(4),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: ControlBoardColors.buttonText,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}