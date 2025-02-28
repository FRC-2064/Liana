import 'package:flutter/material.dart';

import '../utils/control_board_colors.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog(
      {required this.teamNumber, required this.isRobot, super.key});

  final String teamNumber;
  final bool isRobot;

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
  void initState() {
    super.initState();
    _teamNumberController.text = widget.teamNumber;
    _isRobot = widget.isRobot;
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
              labelStyle: TextStyle(color: ControlBoardColors.headerText),
              hintStyle: TextStyle(color: ControlBoardColors.buttonText),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: ControlBoardColors.headerText),
              ),
            ),
            keyboardType: TextInputType.number,
            maxLength: 4,
          ),
          const SizedBox(height: 16),
          RadioToggleSwitch(
            isRobot: _isRobot,
            onChange: (value) {
              setState(() {
                _isRobot = value;
              });
            },
          ),
          const SizedBox(height: 16),
          if (_isRobot && _teamNumberController.text.length == 4)
            Text(
              "Robot IP: $_robotIp",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ControlBoardColors.buttonText,
              ),
            )
          else
            const SizedBox(
              height: 29,
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final ip = _isRobot ? _robotIp : "127.0.0.1";
            Navigator.of(context).pop({
              'ip': ip,
              'teamNumber': _teamNumberController.text,
              'isRobot': _isRobot,
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

class RadioToggleSwitch extends StatefulWidget {
  final bool isRobot;
  final ValueChanged<bool> onChange;

  const RadioToggleSwitch({
    super.key,
    required this.isRobot,
    required this.onChange,
  });

  @override
  State<RadioToggleSwitch> createState() => _RadioToggleSwitchState();
}

class _RadioToggleSwitchState extends State<RadioToggleSwitch> {
  late bool _isRobot;

  @override
  void initState() {
    super.initState();
    _isRobot = widget.isRobot;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 35,
          width: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              border: Border.all(color: ControlBoardColors.border),
              color: !_isRobot
                  ? ControlBoardColors.statusSelected
                  : ControlBoardColors.statusUnselected),
          child: TextButton(
              onPressed: () => setState(() {
                    _isRobot = false;
                    widget.onChange(false);
                  }),
              child: Text(
                "Simulation",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: !_isRobot
                        ? ControlBoardColors.background
                        : ControlBoardColors.buttonText),
              )),
        ),
        Container(
          height: 35,
          width: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              border: Border.all(color: ControlBoardColors.border),
              color: _isRobot
                  ? ControlBoardColors.statusSelected
                  : ControlBoardColors.statusUnselected),
          child: TextButton(
              onPressed: () => setState(() {
                    _isRobot = true;
                    widget.onChange(true);
                  }),
              child: Text(
                "Robot",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: _isRobot
                        ? ControlBoardColors.background
                        : ControlBoardColors.buttonText),
              )),
        ),
      ],
    );
  }
}
