import 'package:flutter/material.dart';

class AppFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color? backgroundColor;
  final String? tooltip;

  const AppFloatingButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.backgroundColor,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      tooltip: tooltip,
      backgroundColor: backgroundColor,
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
