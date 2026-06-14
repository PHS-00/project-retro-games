import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopupCard extends StatelessWidget {
  final Widget child;
  final String? title;

  const PopupCard({
    super.key,
    required this.child,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isHovering = false.obs;
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    title ?? "",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                MouseRegion(
                  onEnter: (_) => isHovering.value = true,
                  onExit: (_) => isHovering.value = false,
                  child: Obx(
                    () => TextButton(
                      style: TextButton.styleFrom(
                        iconColor: Colors.white,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            height: 45,
                            width: 55,
                            alignment: Alignment.centerLeft,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 250),
                              opacity: isHovering.value ? 1 : 0,
                              child: const Text("Fechar",
                                  overflow: TextOverflow.fade),
                            ),
                          ),
                          const Icon(Icons.close, size: 25),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            child,
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
