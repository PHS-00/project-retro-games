import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  AppFloatingButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  final isHovering = false.obs;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return MouseRegion(
      onEnter: (_) => isHovering.value = true,
      onExit: (_) => isHovering.value = false,
      child: Obx(
        () => FloatingActionButton.extended(
          heroTag: label, // corrigido — usa o label como tag única
          onPressed: onPressed,
          backgroundColor: colors.primary,
          foregroundColor: colors.onSurface,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          label: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: isHovering.value ? 70 : 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: isHovering.value ? 1 : 0,
                  child: Text(
                    label,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
              ),
              Icon(icon, size: 25),
            ],
          ),
        ),
      ),
    );
  }
}
