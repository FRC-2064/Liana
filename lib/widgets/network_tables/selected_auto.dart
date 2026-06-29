import 'dart:io';
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
  Widget _buildGif(String path, double width, double height) {
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            '${widget.gifBasePath}/default.gif',
            width: width,
            height: height,
            fit: BoxFit.cover,
          );
        },
      );
    } else {
      return Image.file(
        File(path),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.file(
            File('${widget.gifBasePath}/default.gif'),
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/gifs/default.gif',
                width: width,
                height: height,
                fit: BoxFit.cover,
              );
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? currentValue =
        widget.selectedAuto != null &&
                widget.selectedAuto!.isNotEmpty &&
                widget.autoList.contains(widget.selectedAuto)
            ? widget.selectedAuto
            : (widget.autoList.isNotEmpty ? widget.autoList.first : null);

    final String gifPath =
        '${widget.gifBasePath}/${currentValue ?? 'default'}.gif';

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
          items: widget.autoList.isNotEmpty
              ? widget.autoList
                  .map(
                      (auto) => DropdownMenuItem(value: auto, child: Text(auto)))
                  .toList()
              : [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('No autos available'),
                  )
                ],
          onChanged: (value) {
            if (value != null) {
              widget.setFunction(value);
            }
          },
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 480,
            height: 270,
            child: _buildGif(gifPath, 480, 270),
          ),
        ),
      ],
    );
  }
}
