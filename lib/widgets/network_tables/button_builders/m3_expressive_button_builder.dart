import 'package:liana/widgets/network_tables/button_builders/nt_button_builder.dart';
import 'package:flutter/material.dart';

/// a [NtButtonBuilder] that draws a Material 3 expressive button.
class M3ExpressiveButtonBuilder extends NtButtonBuilder {
  const M3ExpressiveButtonBuilder();

  @override
  Widget build(
    BuildContext context, {
    required bool isSelected,
    required bool isMissing,
    required Color backgroundColor,
    required VoidCallback onPressed,
    required Widget child,
  }) {
    return _M3ExpressiveButton(
      isSelected: isSelected,
      backgroundColor: backgroundColor,
      onPress: onPressed,
      child: child,
    );
  }
}

class _M3ExpressiveButton extends StatefulWidget {
  final bool isSelected;
  final Color backgroundColor;
  final VoidCallback onPress;
  final Widget child;

  const _M3ExpressiveButton({
    required this.isSelected,
    required this.backgroundColor,
    required this.onPress,
    required this.child,
  });

  @override
  State<_M3ExpressiveButton> createState() => _M3ExpressiveButtonState();
}

class _M3ExpressiveButtonState extends State<_M3ExpressiveButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {

    final borderRadius = widget.isSelected
        ? const BorderRadius.only(
            topLeft: Radius.circular(28.0),
            bottomRight: Radius.circular(28.0),
            topRight: Radius.circular(14.0),
            bottomLeft: Radius.circular(14.0),
          )
        : BorderRadius.circular(20.0);


    final double targetScale = _isHovered ? 1.03 : 1.0;


    final List<BoxShadow> shadow = _isHovered
        ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ]
        : [];

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: targetScale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: borderRadius,
            boxShadow: shadow,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPress,
              customBorder: RoundedRectangleBorder(borderRadius: borderRadius),
              hoverColor: Colors.black.withValues(alpha: 0.04),
              splashColor: Colors.black.withValues(alpha: 0.08),
              highlightColor: Colors.black.withValues(alpha: 0.06),
              child: Center(child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}
