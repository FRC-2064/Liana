import 'package:flutter/widgets.dart';
import 'package:liana/app/app_settings.dart';

typedef LayoutWidgetBuilder =
    Widget Function(BuildContext context, AppSettings settings);

final class LayoutDefinition {
  final String id;
  final String name;
  final String description;
  final LayoutWidgetBuilder builder;

  const LayoutDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.builder,
  }) : assert(id != '');
}
