// lib/pages/about_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Colour palette
const Color _backgroundColor = Color(0xFFF9F7F3);
const Color _headerTextColor = Color(0xFF1A1A1A);
const Color _bodyTextColor = Color(0xFF444444);
const Color _accentColor = Color(0xFFFF8C42);
const Color _highlightColor = Color(0xFF00A8A8);

/// Fade-in wrapper for cards, staggered by index
class FadeInCard extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration duration;

  const FadeInCard({
    super.key,
    required this.child,
    required this.index,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  _FadeInCardState createState() => _FadeInCardState();
}

class _FadeInCardState extends State<FadeInCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: widget.duration);
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    Timer(Duration(milliseconds: 200 * widget.index), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      FadeTransition(opacity: _animation, child: widget.child);
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // "Why Choose Us" data
  List<_Service> get _services => [
    _Service(
      title: 'A-M NETWORKS',
      icon: Icons.network_check,
      description: 'Comprehensive event management & ticketing solutions.',
    ),
    _Service(
      title: 'Care4Life',
      icon: Icons.health_and_safety,
      description: 'Secure caregiving platform with chat & booking features.',
    ),
    _Service(
      title: 'Garrison',
      icon: Icons.videogame_asset,
      description:
      'Jamaican-themed strategy board game with role-based mechanics.',
    ),
    _Service(
      title: 'YaadBook',
      icon: Icons.book,
      description:
      'Jamaican Patois dictionary app with rich definitions & audio.',
    ),
    _Service(
      title: 'A-M Services',
      icon: Icons.build,
      description:
      'Digital marketing, design & consulting services for growth.',
    ),
  ];

  // "By the Numbers" stats
  List<_Stat> get _stats => [
    _Stat(label: 'Projects', value: 25),
    _Stat(label: 'Clients', value: 15),
    _Stat(label: 'Awards', value: 4),
    _Stat(label: 'Years Exp', value: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('About', style: TextStyle(color: _headerTextColor)),
        backgroundColor: _backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: _headerTextColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero banner (image + overlay)
            Stack(
              children: [
                Image.asset(
                  'assets/about_bg.jpg',
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.4),
                ),
                SizedBox(
                  height: 300,
                  child: Center(
                    child: Text(
                      'We Are The Best',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // "Why Choose Us" header + divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'Why Choose Us',
                    style: const TextStyle(
                      color: _headerTextColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Divider(color: _highlightColor, thickness: 2),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Services grid with fade-in cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: LayoutBuilder(builder: (context, constraints) {
                final cols = constraints.maxWidth > 800
                    ? 3
                    : constraints.maxWidth > 500
                    ? 2
                    : 1;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _services.length,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, i) {
                    final svc = _services[i];
                    return FadeInCard(
                      index: i,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Icon(svc.icon,
                                  size: 36,
                                  color: _accentColor),
                              const SizedBox(height: 12),
                              Text(
                                svc.title,
                                style: const TextStyle(
                                  color: _headerTextColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                svc.description,
                                style: const TextStyle(
                                  color: _bodyTextColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            const SizedBox(height: 40),

            // "By the Numbers" header + divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'By the Numbers',
                    style: const TextStyle(
                      color: _headerTextColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Divider(color: _highlightColor, thickness: 2),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Stats row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: LayoutBuilder(builder: (context, constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _stats
                      .map((stat) => _StatItem(
                    stat: stat,
                    valueStyle: const TextStyle(
                      color: _headerTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    labelStyle: const TextStyle(
                      color: _bodyTextColor,
                      fontSize: 16,
                    ),
                  ))
                      .toList(),
                );
              }),
            ),

            const SizedBox(height: 60),

            // Call-to-Action banner
            Container(
              width: double.infinity,
              color: _accentColor,
              padding: const EdgeInsets.symmetric(
                  vertical: 40, horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'Ready to Work Together?',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _highlightColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                          color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () =>
                        GoRouter.of(context).go('/contact'),
                    child: const Text('Contact Me'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

/// Service model
class _Service {
  final String title;
  final IconData icon;
  final String description;

  _Service({
    required this.title,
    required this.icon,
    required this.description,
  });
}

/// Stat model
class _Stat {
  final String label;
  final int value;
  _Stat({required this.label, required this.value});
}

/// Widget to display a single stat
class _StatItem extends StatelessWidget {
  final _Stat stat;
  final TextStyle valueStyle;
  final TextStyle labelStyle;

  const _StatItem({
    super.key,
    required this.stat,
    required this.valueStyle,
    required this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${stat.value}', style: valueStyle),
        const SizedBox(height: 4),
        Text(stat.label, style: labelStyle),
      ],
    );
  }
}
