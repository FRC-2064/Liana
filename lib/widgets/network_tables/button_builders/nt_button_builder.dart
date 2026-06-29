import 'package:flutter/widgets.dart';

/// Defines the requirements to build an
/// object around a button, should
/// be extended for any custom shapes.
abstract class NtButtonBuilder {
  const NtButtonBuilder();

  Widget build(
    BuildContext context, {
    required bool isSelected,
    required bool isMissing,
    required Color backgroundColor,
    required VoidCallback onPressed,
    required Widget child,
  });
}
