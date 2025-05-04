// lib/pages/hero_page.dart

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';

class HeroPage extends StatelessWidget {
  HeroPage({super.key});

  // Scaffold key to control the Drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Colour constants for the hero section
  static const Color _bgColor = Color(0xFF0B0C10);
  static const Color _headlineColor = Color(0xFFF4F4F4);
  static const Color _subtextColor = Color(0xFFDADADA);
  static const Color _accentColor = Color(0xFFFF8C42);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bgColor,
      extendBodyBehindAppBar: true,

      // Slide-out navigation drawer
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: _bgColor),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'A-M NETWORKS',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: _headlineColor),
                ),
              ),
            ),
            _buildNavItem(context, icon: Icons.home, label: 'Home', route: '/'),
            _buildNavItem(context, icon: Icons.work, label: 'Portfolio', route: '/portfolio'),
            _buildNavItem(context, icon: Icons.person, label: 'About', route: '/about'),
            _buildNavItem(context, icon: Icons.mail, label: 'Contact', route: '/contact'),
          ],
        ),
      ),

      // Transparent AppBar with hamburger icon
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: _headlineColor),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            tooltip: 'Open navigation menu',
          ),
        ],
      ),

      // Full-screen carousel with styled slides
      body: CarouselSlider(
        items: [
          HeroSlide(
            title: 'Hi, I’m Gregory A.M. Brown – Software Engineer, Consultant, and Cultural Architect.',
            subtitle:
            'I build digital products rooted in Jamaican identity — from games and apps to systems that scale. Welcome to my creative & technical playground.',
            imageUrl: 'assets/onboarding1.png',
            buttonText: 'Explore My Work',
            buttonColor: _accentColor,
            onPressed: () => context.go('/portfolio'),
          ),
          HeroSlide(
            title: 'About Me',
            subtitle:
            'I’m a Jamaican-based full-stack developer and strategic consultant with a passion for turning local insight into global-ready systems. My work spans software engineering, cultural product development, and tech-for-impact initiatives — all through the AM Network framework.',
            imageUrl: 'assets/onboarding2.png',
            buttonText: 'Meet the Team',
            buttonColor: _accentColor,
            onPressed: () => context.go('/about'),
          ),
          HeroSlide(
            title: 'Let’s Build Together',
            subtitle:
            'Whether you have an idea, a problem to solve, or a project ready to scale — I’d love to connect.',
            imageUrl: 'assets/onboarding3.png',
            buttonText: 'Book a Consultation',
            buttonColor: _accentColor,
            onPressed: () => context.go('/contact'),
          ),
        ],
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height,
          viewportFraction: 1.0,
          autoPlay: true,
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String route,
      }) {
    return ListTile(
      leading: Icon(icon, color: _accentColor),
      title: Text(label, style: TextStyle(color: _accentColor)),
      onTap: () {
        Navigator.of(context).pop(); // close drawer
        context.go(route);            // navigate
      },
    );
  }
}

class HeroSlide extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String buttonText;
  final Color buttonColor;
  final VoidCallback onPressed;

  const HeroSlide({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.buttonText,
    required this.buttonColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Image.asset(imageUrl, fit: BoxFit.cover),

        // Dark overlay for contrast
        Container(color: Colors.black.withOpacity(0.6)),

        // Centered text & button
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(color: HeroPage._headlineColor),
                ),
                const SizedBox(height: 16),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: HeroPage._subtextColor),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: Theme.of(context).textTheme.labelLarge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onPressed,
                  child: Text(
                    buttonText,
                    style: const TextStyle(color: HeroPage._headlineColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
