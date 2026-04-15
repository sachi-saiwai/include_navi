import 'package:flutter/material.dart';

class SoftSurfaceCard extends StatelessWidget {
  const SoftSurfaceCard({
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.backgroundColor,
    this.borderColor,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor ?? const Color(0xFFE9E5E3)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0F244244),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
