import 'dart:collection';

import 'package:liana/app/app_settings.dart';
import 'package:liana/app/layout_definition.dart';
import 'package:liana/layouts/2025/layout.dart';
import 'package:liana/layouts/2026/layout.dart';
import 'package:liana/layouts/example/layout.dart';

final class LayoutRegistry {
  final Map<String, LayoutDefinition> _byId;
  final String defaultLayoutId;

  LayoutRegistry(
    Iterable<LayoutDefinition> layouts, {
    this.defaultLayoutId = AppSettings.defaultLayoutId,
  }) : _byId = {for (final layout in layouts) layout.id: layout} {
    if (!_byId.containsKey(defaultLayoutId)) {
      throw ArgumentError.value(
        defaultLayoutId,
        'defaultLayoutId',
        'Not registered',
      );
    }
    if (_byId.length != layouts.length) {
      throw ArgumentError('Layout IDs must be unique');
    }
  }

  factory LayoutRegistry.standard() => LayoutRegistry([
    LayoutDefinition(
      id: 'reefscape-2025',
      name: 'Reefscape 2025',
      description: '2025 competition control board',
      builder: (context, settings) =>
          ReefscapeLayout(gifBasePath: settings.gifBasePath),
    ),
    LayoutDefinition(
      id: 'prototype-2026',
      name: 'Prototype 2026',
      description: '2026 mechanism prototype',
      builder: (context, settings) =>
          PrototypeLayout(gifBasePath: settings.gifBasePath),
    ),
    LayoutDefinition(
      id: 'example',
      name: 'Student Example',
      description: 'Small copy-and-edit starter layout',
      builder: (context, settings) => const ExampleLayout(),
    ),
  ]);

  UnmodifiableListView<LayoutDefinition> get layouts =>
      UnmodifiableListView(_byId.values);

  LayoutDefinition lookup(String id) => _byId[id] ?? _byId[defaultLayoutId]!;
}
