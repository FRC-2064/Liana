import 'package:flutter/material.dart';
import 'package:liana/app/app_controller.dart';
import 'package:liana/app/liana_app.dart';
import 'package:liana/app/settings_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await SettingsStore.create();
  final controller = AppController(settings: store.load(), store: store);
  runApp(LianaApp(controller: controller));
}
