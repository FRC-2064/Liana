import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liana/app/app_settings.dart';
import 'package:liana/app/layout_definition.dart';
import 'package:liana/utils/liana_colors.dart';
import 'package:liana/utils/liana_connection_mode.dart';

/// [Widget] to display settings as a modal. This includes
/// the team number, which builds the robot ip, whether we are
/// looking at the robot or a sim, and where the GIFs for
/// the auto routines are stored.
class SettingsDialog extends StatefulWidget {
  final AppSettings settings;
  final List<LayoutDefinition> layouts;

  const SettingsDialog({
    required this.settings,
    required this.layouts,
    super.key,
  });

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late final TextEditingController _teamController;
  late final TextEditingController _gifController;
  late LianaConnectionMode _mode;
  late String _layoutId;

  int? get _team => int.tryParse(_teamController.text);
  bool get _teamValid => AppSettings.isValidTeamNumber(_team);
  bool get _gifValid => _gifController.text.trim().isNotEmpty;
  bool get _valid => _teamValid && _gifValid;

  @override
  void initState() {
    super.initState();
    _teamController = TextEditingController(
      text: widget.settings.teamNumber.toString(),
    );
    _gifController = TextEditingController(text: widget.settings.gifBasePath);
    _mode = widget.settings.mode;
    _layoutId = widget.settings.layoutId;
    _teamController.addListener(_refresh);
    _gifController.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _teamController.removeListener(_refresh);
    _gifController.removeListener(_refresh);
    _teamController.dispose();
    _gifController.dispose();
    super.dispose();
  }

  Future<void> _pickFolder() async {
    final path = await FilePicker.getDirectoryPath();
    if (path != null) _gifController.text = path;
  }

  void _save() {
    if (!_valid) return;
    Navigator.of(context).pop(
      AppSettings(
        teamNumber: _team!,
        mode: _mode,
        gifBasePath: _gifController.text.trim(),
        layoutId: _layoutId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: LianaColors.surface,
      title: const Text(
        'Settings',
        style: TextStyle(color: LianaColors.headerText),
      ),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const Key('team-number-field'),
                controller: _teamController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                style: const TextStyle(color: LianaColors.onSurface),
                decoration: InputDecoration(
                  labelText: 'Team number',
                  errorText: _teamValid
                      ? null
                      : 'Enter a valid team number (1–25599)',
                  helperText: _teamValid
                      ? 'Robot address: ${AppSettings.robotAddressForTeam(_team!)}'
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              SegmentedButton<LianaConnectionMode>(
                key: const Key('connection-mode-field'),
                segments: const [
                  ButtonSegment(
                    value: LianaConnectionMode.robot,
                    label: Text('Robot'),
                  ),
                  ButtonSegment(
                    value: LianaConnectionMode.simulation,
                    label: Text('Simulation'),
                  ),
                  ButtonSegment(
                    value: LianaConnectionMode.uiTest,
                    label: Text('UI Test'),
                  ),
                ],
                selected: {_mode},
                onSelectionChanged: (selection) =>
                    setState(() => _mode = selection.single),
              ),
              if (_mode != widget.settings.mode) ...[
                const SizedBox(height: 8),
                const Text(
                  'Connection mode changes take effect after restart.',
                  key: Key('restart-required-message'),
                  style: TextStyle(color: LianaColors.tertiary),
                ),
              ],
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                key: const Key('layout-field'),
                initialValue: _layoutId,
                decoration: const InputDecoration(labelText: 'Active layout'),
                dropdownColor: LianaColors.surface,
                items: widget.layouts
                    .map(
                      (layout) => DropdownMenuItem(
                        value: layout.id,
                        child: Text(layout.name),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (value) {
                  if (value != null) setState(() => _layoutId = value);
                },
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('gif-path-field'),
                controller: _gifController,
                style: const TextStyle(color: LianaColors.onSurface),
                decoration: InputDecoration(
                  labelText: 'GIF directory',
                  errorText: _gifValid ? null : 'GIF directory is required',
                  suffixIcon: IconButton(
                    onPressed: _pickFolder,
                    icon: const Icon(Icons.folder_open),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          key: const Key('cancel-settings'),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: const Key('save-settings'),
          onPressed: _valid ? _save : null,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
