import 'package:flutter/material.dart';
import 'package:liana/app/app_controller.dart';
import 'package:liana/app/app_settings.dart';
import 'package:liana/services/network_tables/nt_repository.dart';
import 'package:liana/services/updater/update.dart';
import 'package:liana/utils/liana_colors.dart';
import 'package:liana/utils/liana_connection_mode.dart';
import 'package:liana/widgets/settings_dialog.dart';
import 'package:liana/widgets/update_toast.dart';
import 'package:provider/provider.dart';

class LianaApp extends StatefulWidget {
  final AppController controller;
  final bool startUpdater;

  const LianaApp({
    required this.controller,
    this.startUpdater = true,
    super.key,
  });

  @override
  State<LianaApp> createState() => _LianaAppState();
}

class _LianaAppState extends State<LianaApp> {
  late final Update _updater;

  @override
  void initState() {
    super.initState();
    _updater = Update();
    if (widget.startUpdater) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _updater.startPeriodicCheck((update) {
          if (mounted) {
            UpdateToastManager.showUpdateToast(context, update, _updater);
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _updater.stopPeriodicCheck();
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppController>.value(
      value: widget.controller,
      child: MaterialApp(
        title: 'Liana',
        theme: ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: LianaColors.background,
          colorScheme: ColorScheme.fromSeed(
            seedColor: LianaColors.primary,
            brightness: Brightness.dark,
          ),
        ),
        home: const _AppShell(),
      ),
    );
  }
}

class _AppShell extends StatelessWidget {
  const _AppShell();

  Future<void> _openSettings(
    BuildContext context,
    AppController controller,
  ) async {
    final previousMode = controller.settings.mode;
    final result = await showDialog(
      context: context,
      builder: (context) => SettingsDialog(
        settings: controller.settings,
        layouts: controller.layouts,
      ),
    );
    if (result is! AppSettings) return;
    await controller.applySettings(result);
    if (context.mounted && result.mode != previousMode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Restart required to change connection mode.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final repository = controller.repository;
    final layout = controller.selectedLayout;
    final isUiTest = controller.activeMode == LianaConnectionMode.uiTest;

    return Provider<NtRepository>.value(
      value: repository,
      child: Scaffold(
        backgroundColor: LianaColors.background,
        body: StreamBuilder<bool>(
          stream: repository.connectionStatus,
          initialData: repository.isConnected,
          builder: (context, snapshot) {
            final connected =
                isUiTest || (snapshot.data ?? repository.isConnected);
            return Stack(
              children: [
                Positioned.fill(
                  child: layout.builder(context, controller.settings),
                ),
                if (!connected)
                  Positioned.fill(
                    child: ColoredBox(
                      key: const Key('connection-overlay'),
                      color: Colors.black87,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 24),
                            Text(
                              'Connecting to ${controller.activeMode.label}...',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Server: ${repository.serverAddress ?? 'none'}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          key: const Key('settings-button'),
          onPressed: () => _openSettings(context, controller),
          child: const Icon(Icons.settings),
        ),
      ),
    );
  }
}

extension on LianaConnectionMode {
  String get label => switch (this) {
    LianaConnectionMode.robot => 'Robot',
    LianaConnectionMode.simulation => 'Simulation',
    LianaConnectionMode.uiTest => 'UI Test',
  };
}
