import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? url;
  final VoidCallback? onTap;

  const AppActionChip({
    super.key,
    required this.label,
    required this.icon,
    this.url,
    this.onTap,
  });

  Future<void> abrirLink() async {
    if (url == null) return;

    final uri = Uri.parse(url!);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () async {
        onTap?.call();

        if (url != null) {
          await abrirLink();
        }
      },
      child: Chip(
        avatar: Icon(
          icon,
          size: 18,
        ),
        label: Text(label),
      ),
    );
  }
}
