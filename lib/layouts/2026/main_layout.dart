import 'dart:async';
import 'package:liana/utils/liana_colors.dart';
import 'package:liana/widgets/network_tables/nt_adjustment.dart';
import 'package:liana/widgets/network_tables/nt_bool.dart';
import 'package:liana/widgets/network_tables/selected_auto.dart';
import 'package:liana/widgets/network_tables/timer.dart';
import 'package:liana/widgets/match_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:liana/services/network_tables/liana.dart';
import 'package:liana/services/network_tables/nt_entry.dart';
import 'package:liana/layouts/2026/value_lists_2026.dart';

class MainLayout2026 extends StatefulWidget {
  final String gifBasePath;
  const MainLayout2026({super.key, this.gifBasePath = 'assets/gifs'});

  @override
  State<MainLayout2026> createState() => _MainLayout2026State();
}

class _MainLayout2026State extends State<MainLayout2026> {
  late final Liana _liana;
  late final NtEntry<List<String>> _autosEntry;
  late final NtEntry<String> _selectedAutoEntry;

  String? selectedAuto;
  List<String> autoList = ValueLists2026.autoList;

  StreamSubscription? _autosSubscription;
  StreamSubscription? _selectedAutoSubscription;

  @override
  void initState() {
    super.initState();
    _liana = Provider.of<Liana>(context, listen: false);

    _autosEntry = _liana.getEntry<List<String>>(
      '/Robot/Autos',
      defaultValue: ValueLists2026.autoList,
    );

    autoList = _autosEntry.value ?? ValueLists2026.autoList;
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
      body: Column(
        children: [
          // Timeline at the top
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: MatchTimeline(
              topicName: '/Robot/GameTime',
              defaultValue: '160',
              height: 60,
            ),
          ),
          // Main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column - Timer and Auto Selector
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const NtTimer(
                          topicName: '/Robot/GameTime',
                          defaultValue: '135',
                        ),
                        const SizedBox(height: 32),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            NtBool(
                              name: 'At Position',
                              topicName: '/Robot/AtPosition',
                              defaultValue: false,
                            ),
                            SizedBox(width: 8),
                            NtBool(
                              name: 'Hopper Full',
                              topicName: '/Robot/HopperFull',
                              defaultValue: false,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Expanded(
                          child: SelectedAuto(
                            selectedAuto: selectedAuto,
                            setFunction: (a) {
                              _selectedAutoEntry.set(a);
                            },
                            autoList: autoList.isNotEmpty
                                ? autoList
                                : ['Default Auto'],
                            gifBasePath: widget.gifBasePath,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),

                  // Right Column - Adjustments
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        NtAdjustment(
                          title: 'HOOD',
                          topicName: '/Robot/HoodAngle',
                          incrementAmount: ValueLists2026.hoodIncrement,
                          defaultValue: ValueLists2026.hoodDefault,
                          minValue: ValueLists2026.hoodMin,
                          maxValue: ValueLists2026.hoodMax,
                          titleFontSize: 32,
                          valueFontSize: 48,
                          negativeText: 'DOWN',
                          positiveText: 'UP',
                          positiveColor: LianaColors.cardBackground,
                          negativeColor: LianaColors.cardBackground,
                        ),
                        SizedBox(height: 24),
                        Divider(
                          color: LianaColors.border,
                          thickness: 2,
                          indent: 40,
                          endIndent: 40,
                        ),
                        SizedBox(height: 24),
                        NtAdjustment(
                          title: 'FLYWHEEL',
                          topicName: '/Robot/FlywheelRPM',
                          incrementAmount: ValueLists2026.flywheelIncrement,
                          defaultValue: ValueLists2026.flywheelDefault,
                          minValue: ValueLists2026.flywheelMin,
                          maxValue: ValueLists2026.flywheelMax,
                          titleFontSize: 32,
                          valueFontSize: 48,
                          negativeText: 'SLOWER',
                          positiveText: 'FASTER',
                          positiveColor: LianaColors.cardBackground,
                          negativeColor: LianaColors.cardBackground,
                        ),
                        SizedBox(height: 24),
                        Divider(
                          color: LianaColors.border,
                          thickness: 2,
                          indent: 40,
                          endIndent: 40,
                        ),
                        SizedBox(height: 24),
                        NtAdjustment(
                          title: 'TURRET',
                          topicName: '/Robot/TurretAngle',
                          incrementAmount: ValueLists2026.turretIncrement,
                          defaultValue: ValueLists2026.turretDefault,
                          minValue: ValueLists2026.turretMin,
                          maxValue: ValueLists2026.turretMax,
                          titleFontSize: 32,
                          valueFontSize: 48,
                          negativeText: 'LEFT',
                          positiveText: 'RIGHT',
                          positiveColor: LianaColors.cardBackground,
                          negativeColor: LianaColors.cardBackground,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
