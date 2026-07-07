import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? url;
  final Color? backgroundColor;

  const AppActionChip({
    super.key,
    required this.label,
    required this.icon,
    this.url,
    this.backgroundColor,
  });

  Future<void> _handleTap() async {
    if (url == null || url!.isEmpty) return;

    await launchUrl(
      Uri.parse(url!),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ActionChip(
      backgroundColor: backgroundColor ?? colors.surface,
      side: BorderSide(
        color: colors.outline,
      ),
      avatar: Icon(
        icon,
        size: 18,
        color: colors.onSurface,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: colors.onSurface,
        ),
      ),
      onPressed: _handleTap,
    );
  }
}
