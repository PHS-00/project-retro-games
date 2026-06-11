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
    final bool isMobile = MediaQuery.of(context).size.width < 700;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 8,
          sigmaY: 8,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.35),
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.15),
              ),
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 800,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sports_esports,
                    size: isMobile ? 35 : 45,
                    color: Colors.white,
                  ),

                  const SizedBox(height: 15),

                  Text(
                    appName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 20 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: 300,
                    child: Divider(
                      color: Colors.grey.shade700,
                    ),
                  ),

                  // TECNOLOGIAS
                  if (technologyChips.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      "Tecnologias",
                      style: TextStyle(
                        color: Colors.grey.shade300,
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

                  // DESENVOLVEDORES
                  if (developerChips.isNotEmpty) ...[
                    const SizedBox(height: 25),
                    Text(
                      "Desenvolvedores",
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: developerChips
                          .map(
                            (chip) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: chip,
                            ),
                          )
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 25),

                  Text(
                    "Versão $version",
                    style: const TextStyle(
                      color: Colors.white54,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "© $year - Projeto Acadêmico",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white54,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "Dados fornecidos pela API $apiName",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white54,
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
