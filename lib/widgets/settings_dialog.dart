import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../utils/liana_colors.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({
    required this.teamNumber,
    required this.isRobot,
    required this.gifBasePath,
    super.key,
  });

  final String teamNumber;
  final bool isRobot;
  final String gifBasePath;

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  final TextEditingController _teamNumberController = TextEditingController();
  final TextEditingController _gifPathController = TextEditingController();
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
    _gifPathController.text = widget.gifBasePath;
    _isRobot = widget.isRobot;
  }

  @override
  void dispose() {
    _teamNumberController.dispose();
    _gifPathController.dispose();
    super.dispose();
  }

  Future<void> _pickFolder() async {
    // Opens a folder selection dialog.
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      setState(() {
        _gifPathController.text = selectedDirectory;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: LianaColors.background,
      title: Text(
        "Settings",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: LianaColors.headerText,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _teamNumberController,
              style: TextStyle(color: LianaColors.buttonText),
              decoration: InputDecoration(
                labelText: "Team Number",
                labelStyle: TextStyle(color: LianaColors.headerText),
                hintStyle: TextStyle(color: LianaColors.buttonText),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: LianaColors.headerText),
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
                  color: LianaColors.buttonText,
                ),
              )
            else
              const SizedBox(height: 29),
            const SizedBox(height: 16),
            // Updated GIF path TextField with a folder icon
            TextField(
              controller: _gifPathController,
              style: TextStyle(color: LianaColors.buttonText),
              decoration: InputDecoration(
                labelText: "GIF Path",
                labelStyle: TextStyle(color: LianaColors.headerText),
                hintStyle: TextStyle(color: LianaColors.buttonText),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: LianaColors.headerText),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.folder, color: LianaColors.buttonText),
                  onPressed: _pickFolder,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            final ip = _isRobot ? _robotIp : "127.0.0.1";
            Navigator.of(context).pop({
              'ip': ip,
              'teamNumber': _teamNumberController.text,
              'isRobot': _isRobot,
              'gifPath': _gifPathController.text,
            });
          },
          child: Text(
            "Save",
            style: TextStyle(color: LianaColors.buttonText),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Cancel",
            style: TextStyle(color: LianaColors.buttonText),
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
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              border: Border.all(color: LianaColors.border),
              color: !_isRobot
                  ? LianaColors.statusSelected
                  : LianaColors.statusUnselected),
          child: TextButton(
            onPressed: () => setState(() {
              _isRobot = false;
              widget.onChange(false);
            }),
            child: Text(
              "Simulation",
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    !_isRobot ? LianaColors.background : LianaColors.buttonText,
              ),
            ),
          ),
        ),
        Container(
          height: 35,
          width: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              border: Border.all(color: LianaColors.border),
              color: _isRobot
                  ? LianaColors.statusSelected
                  : LianaColors.statusUnselected),
          child: TextButton(
            onPressed: () => setState(() {
              _isRobot = true;
              widget.onChange(true);
            }),
            child: Text(
              "Robot",
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    _isRobot ? LianaColors.background : LianaColors.buttonText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
