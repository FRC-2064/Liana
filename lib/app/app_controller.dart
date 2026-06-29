import 'package:flutter/foundation.dart';
import 'package:liana/app/app_settings.dart';
import 'package:liana/app/layout_definition.dart';
import 'package:liana/app/layout_registry.dart';
import 'package:liana/app/settings_store.dart';
import 'package:liana/services/network_tables/memory_nt_repository.dart';
import 'package:liana/services/network_tables/nt4_repository.dart';
import 'package:liana/services/network_tables/nt_repository.dart';
import 'package:liana/utils/liana_connection_mode.dart';

typedef NtRepositoryFactory = NtRepository Function(AppSettings settings);

NtRepository createRepository(AppSettings settings) {
  return switch (settings.mode) {
    LianaConnectionMode.uiTest => MemoryNtRepository(),
    _ => Nt4Repository(serverAddress: settings.serverAddress!),
  };
}

final class AppController extends ChangeNotifier {
  final SettingsStore store;
  final LayoutRegistry _registry;
  final NtRepositoryFactory repositoryFactory;
  final LianaConnectionMode _activeMode;

  AppSettings _settings;
  late final NtRepository _repository;
  bool _restartRequired = false;
  bool _disposed = false;

  AppController({
    required AppSettings settings,
    required this.store,
    LayoutRegistry? registry,
    this.repositoryFactory = createRepository,
  }) : _settings = settings,
       _registry = registry ?? LayoutRegistry.standard(),
       _activeMode = settings.mode {
    _settings = _sanitizeLayout(settings);
    _repository = repositoryFactory(_settings);
  }

  AppSettings get settings => _settings;
  LayoutDefinition get selectedLayout => _registry.lookup(_settings.layoutId);
  List<LayoutDefinition> get layouts => _registry.layouts;
  NtRepository get repository => _repository;
  LianaConnectionMode get activeMode => _activeMode;
  bool get restartRequired => _restartRequired;

  AppSettings _sanitizeLayout(AppSettings settings) {
    final layout = _registry.lookup(settings.layoutId);
    return layout.id == settings.layoutId
        ? settings
        : settings.copyWith(layoutId: layout.id);
  }

  Future<void> applySettings(AppSettings nextSettings) async {
    if (_disposed) throw StateError('AppController is disposed');
    final next = _sanitizeLayout(nextSettings);
    final previous = _settings;
    _settings = next;

    _restartRequired = next.mode != _activeMode;

    if (_activeMode == LianaConnectionMode.robot &&
        previous.teamNumber != next.teamNumber &&
        _repository is Nt4Repository) {
      _repository.reconnect(AppSettings.robotAddressForTeam(next.teamNumber));
    }

    await store.save(next);
    notifyListeners();
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _repository.dispose();
    super.dispose();
  }
}
