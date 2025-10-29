import 'package:flutter/cupertino.dart';
import 'package:liana/widgets/network_tables/nt_status_button.dart';

/// Defines the requirements to build an
/// object around a [NtStatusButton], should
/// be extended for any custom shapes.
abstract class NtButtonBuilder {
  const NtButtonBuilder();

  Widget build(
    BuildContext context,
    bool isSelected,
    Color backgroundColor,
    VoidCallback onPress,
    Widget child,
  );
}
