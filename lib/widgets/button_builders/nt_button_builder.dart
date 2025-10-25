import 'package:flutter/cupertino.dart';

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
