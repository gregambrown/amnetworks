// lib/pages/portfolio_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:video_player/video_player.dart';
import '../models/project.dart';
import '../services/portfolio_service.dart';

/// Represents one featured project in the showcase section
class _FeaturedProject {
  final String title;
  final String description;
  final Color backgroundColor;
  final Color textColor;

  const _FeaturedProject({
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.textColor,
  });
}

/// A card widget that shows a featured project with hover effect
class _FeaturedCard extends StatefulWidget {
  final _FeaturedProject project;

  const _FeaturedCard({Key? key, required this.project}) : super(key: key);

  @override
  State<_FeaturedCard> createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<_FeaturedCard> {
  bool _hovering = false;
  static const Color _hoverAccent = Color(0xFF00A8A8);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: widget.project.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hovering ? _hoverAccent : Colors.transparent,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.project.title,
              style: TextStyle(
                color: widget.project.textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.project.description,
              style: TextStyle(
                color: widget.project.textColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PortfolioPage extends StatelessWidget {
  PortfolioPage({Key? key}) : super(key: key);

  final PortfolioService _service = PortfolioService();

  // Static list of featured projects
  final List<_FeaturedProject> _featuredProjects = const [
    _FeaturedProject(
      title: 'Garrison',
      description: 'A Jamaican-themed strategy board game.',
      backgroundColor: Color(0xFF2E2E2E),
      textColor: Color(0xFFFFD700),
    ),
    _FeaturedProject(
      title: 'YaadBook',
      description: 'Jamaican Patois dictionary with audio.',
      backgroundColor: Color(0xFFFEEEC7),
      textColor: Color(0xFF5A3E36), // brown text
    ),
    _FeaturedProject(
      title: 'GrungTV',
      description: 'Caribbean Boiler Room–style music platform.',
      backgroundColor: Color(0xFF151515),
      textColor: Color(0xFFFF8C42),
    ),
    _FeaturedProject(
      title: 'SuperUI',
      description: 'Tech design system for scalable apps.',
      backgroundColor: Color(0xFFEFF3F6),
      textColor: Color(0xFF1F1F1F),
    ),
    _FeaturedProject(
      title: 'A-M Portfolio',
      description: 'This very portfolio showcasing my work.',
      backgroundColor: Color(0xFFF0F0F0),
      textColor: Color(0xFF1F1F1F),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Showcase header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Real Projects. Real Impact.',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F1F1F),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Dive into standout ventures that blend innovation with culture.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1F1F1F),
                    ),
                  ),
                ],
              ),
            ),

            // Featured grid (responsive 2x2)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: LayoutBuilder(builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 800 ? 2 : 1;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _featuredProjects.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) {
                    return _FeaturedCard(
                      project: _featuredProjects[index],
                    );
                  },
                );
              }),
            ),

            const SizedBox(height: 32),

            // Dynamic "All Projects" section
            StreamBuilder<List<Project>>(
              stream: _service.projectsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(color: primary));
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading projects'));
                }
                final projects = snapshot.data ?? [];
                if (projects.isEmpty) {
                  return const Center(child: Text('No projects found'));
                }
                final crossAxisCount =
                MediaQuery.of(context).size.width > 800 ? 4 : 2;
                return MasonryGridView.count(
                  padding: const EdgeInsets.all(16),
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final proj = projects[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProjectDetailPage(project: proj),
                        ),
                      ),
                      child: Hero(
                        tag: proj.id,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            proj.imageUrls.first,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectDetailPage extends StatelessWidget {
  final Project project;
  const ProjectDetailPage({Key? key, required this.project})
      : super(key: key);

  bool _isVideo(String url) => url.toLowerCase().endsWith('.mp4');

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(project.title),
        backgroundColor: primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: project.id,
              child: _buildMedia(project.imageUrls.first),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                project.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 16),
            if (project.imageUrls.length > 1)
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemCount: project.imageUrls.length,
                  itemBuilder: (ctx, i) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 200,
                      child: _buildMedia(project.imageUrls[i]),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMedia(String url) {
    return _isVideo(url)
        ? _VideoPlayerWidget(url: url)
        : Image.network(url, fit: BoxFit.cover);
  }
}

class _VideoPlayerWidget extends StatefulWidget {
  final String url;
  const _VideoPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  State<_VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<_VideoPlayerWidget> {
  late VideoPlayerController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = VideoPlayerController.network(widget.url)
      ..initialize().then((_) => setState(() {}))
      ..setLooping(true)
      ..play();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ctrl.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return AspectRatio(
      aspectRatio: _ctrl.value.aspectRatio,
      child: VideoPlayer(_ctrl),
    );
  }
}
