import 'dart:ui';

import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  final String appName;
  final String version;
  final String apiName;
  final String description;
  final String year;

  final List<Widget> technologyChips;
  final List<Widget> developerChips;

  const AppFooter({
    super.key,
    required this.appName,
    required this.version,
    required this.apiName,
    required this.description,
    required this.year,
    this.technologyChips = const [],
    this.developerChips = const [],
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isSmall = MediaQuery.sizeOf(context).width < 600;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 8,
          sigmaY: 8,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colors.surface.withOpacity(.35),
            border: Border(
              top: BorderSide(
                color: colors.outline.withOpacity(.3),
              ),
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                children: [
                  Icon(
                    Icons.sports_esports,
                    size: isSmall ? 35 : 45,
                    color: colors.onSurface,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    appName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmall ? 20 : 24,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colors.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(color: colors.onSurface),
                  if (technologyChips.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      'Tecnologias',
                      style: TextStyle(
                        color: colors.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: technologyChips,
                    ),
                  ],
                  if (developerChips.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      'Desenvolvedores',
                      style: TextStyle(
                        color: colors.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: developerChips,
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text(
                    'Versão $version',
                    style: TextStyle(
                      color: colors.onSurface.withOpacity(0.6),
                    ),
                  ),
                  Text(
                    '© $year - Projeto Acadêmico',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colors.onSurface.withOpacity(0.6),
                    ),
                  ),
                  Text(
                    'Dados fornecidos pela API $apiName',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colors.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
