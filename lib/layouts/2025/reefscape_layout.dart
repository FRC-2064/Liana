import 'dart:async';
import 'package:liana/widgets/network_tables/button_builders/rectangle_builder.dart';
import 'package:liana/widgets/network_tables/nt_bool_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:liana/widgets/network_tables/nt_status_button.dart';
import 'package:liana/services/network_tables/liana.dart';
import 'package:liana/services/network_tables/nt_entry.dart';
import 'package:liana/layouts/2025/reefscape_value_lists.dart';
import 'package:liana/utils/liana_colors.dart';
import 'package:liana/layouts/2025/custom_widgets/hexagon_stack.dart';
import 'package:liana/widgets/network_tables/selected_auto.dart';
import 'package:liana/widgets/network_tables/timer.dart';

class MainLayout extends StatefulWidget {
  final String gifBasePath;
  const MainLayout({super.key, required this.gifBasePath});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late final Liana _liana;
  late final NtEntry<List<String>> _autosEntry;
  late final NtEntry<String> _selectedAutoEntry;

  String? selectedAuto;
  List<String> autoList = ValueLists.autoList;

  StreamSubscription? _autosSubscription;
  StreamSubscription? _selectedAutoSubscription;

  @override
  void initState() {
    super.initState();
    _liana = Provider.of<Liana>(context, listen: false);

    _autosEntry = _liana.getEntry<List<String>>('/Robot/Autos',
        defaultValue: ValueLists.autoList);

    autoList = _autosEntry.value ?? ValueLists.autoList;
    _selectedAutoEntry = _liana.getEntry<String>(
      'SelectedAuto',
      defaultValue: autoList.isNotEmpty ? autoList.first : 'Default Auto',
    );
    selectedAuto = _selectedAutoEntry.value;

    _autosSubscription = _autosEntry.stream().listen((autos) {
      if (autos.isNotEmpty) {
        setState(() {
          autoList = autos;
          if (!autoList.contains(selectedAuto)) {
            selectedAuto = autoList.first;
            _selectedAutoEntry.set(selectedAuto!);
          }
        });
      }
    });

    _selectedAutoSubscription = _selectedAutoEntry.stream().listen((newAuto) {
      if (newAuto != selectedAuto) {
        setState(() {
          selectedAuto = newAuto;
        });
      }
    });
  }

  @override
  void dispose() {
    _autosSubscription?.cancel();
    _selectedAutoSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LianaColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  NtTimer(
                    topicName: '/Robot/GameTime',
                    defaultValue: '135',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 2),
                      NtBoolIndicator(
                        name: 'Coral',
                        topicName: '/Robot/HasCoral',
                        defaultValue: false,
                      ),
                      const SizedBox(width: 2),
                      NtBoolIndicator(
                        name: 'Clamped',
                        topicName: '/Robot/Clamped',
                        defaultValue: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SelectedAuto(
                    selectedAuto: selectedAuto,
                    setFunction: (a) {
                      _selectedAutoEntry.set(a);
                    },
                    autoList: autoList.isNotEmpty ? autoList : ['Default Auto'],
                    gifBasePath: widget.gifBasePath,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Cage',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: LianaColors.headerText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (String location in ValueLists.cageLocations)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: NtStatusButton<String>(
                            text: location,
                            topicName: "Barge/Cage",
                            defaultValue: ValueLists.cageLocations.first,
                            valueToSet: location,
                            width: 115,
                            height: 50,
                            builder: const RectangleBuilder(borderRadius: 10.0),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Center(
                      child: HexagonStack(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Feeder',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: LianaColors.headerText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (String location in ValueLists.feederLocations)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: NtStatusButton<String>(
                            text: location,
                            topicName: "Feeder",
                            defaultValue: ValueLists.feederLocations.first,
                            valueToSet: location,
                            width: 150,
                            height: 75,
                            builder: const RectangleBuilder(borderRadius: 10.0),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),

            // Column 3: Level selection
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Level',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: LianaColors.headerText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      for (int level in ValueLists.reefLevels)
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: NtStatusButton<int>(
                              text: switch (level) {
                                0 => 'Remove Algae',
                                1 => 'Level 1 (Trough)',
                                _ => 'Level $level',
                              },
                              topicName: "Reef/Level",
                              defaultValue: ValueLists.reefLevels.first,
                              valueToSet: level,
                              width: 150,
                              height: 75,
                              builder:
                                  const RectangleBuilder(borderRadius: 20.0),
                            )),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Score',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: LianaColors.headerText,
                    ),
                  ),
                  Column(
                    children: [
                      for (String loc in ValueLists.scoreLocations)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: NtStatusButton<String>(
                            text: loc,
                            topicName: "ScoreLocation",
                            defaultValue: ValueLists.scoreLocations.first,
                            valueToSet: loc,
                            width: 150,
                            height: 75,
                            builder: const RectangleBuilder(borderRadius: 20.0),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
