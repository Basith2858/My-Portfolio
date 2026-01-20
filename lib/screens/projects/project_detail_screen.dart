import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../data/portfolio_data.dart';
import '../../widgets/common/animated_button.dart';
import '../../widgets/common/glass_container.dart';
import '../../widgets/common/responsive_wrapper.dart';
import '../../widgets/layout/footer.dart';
import '../../widgets/layout/nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectDetailScreen extends StatelessWidget {
  final String projectId;
  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final project = PortfolioData.projects.firstWhere(
      (p) => p.id == projectId,
      orElse: () => PortfolioData.projects.first, // Fallback
    );

    final theme = Theme.of(context);

    return Scaffold(
      appBar: const NavBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 80), // AppBar spacer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button
                    TextButton.icon(
                      onPressed: () => context.go('/'),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Back to Home"),
                    ),
                    const SizedBox(height: 24),

                    // Title & Tags
                    Text(
                      project.title,
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ).animate().fadeIn().moveY(begin: 20, end: 0),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: project.tags
                          .map((tag) => Chip(label: Text(tag)))
                          .toList(),
                    ),
                    const SizedBox(height: 40),

                    // Main Image/Banner
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.image,
                            size: 100,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 200.ms),

                    const SizedBox(height: 40),

                    // Description & Buttons
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "About the Project",
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                project.description,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                "Technologies Used",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                project.tags.join(" • "),
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        if (ResponsiveWrapper.isDesktop(context)) ...[
                          const SizedBox(width: 40),
                          Expanded(
                            flex: 1,
                            child: _buildLinks(context, project),
                          ),
                        ],
                      ],
                    ),

                    if (!ResponsiveWrapper.isDesktop(context)) ...[
                      const SizedBox(height: 40),
                      _buildLinks(context, project),
                    ],

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildLinks(BuildContext context, Project project) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Project Links", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          if (project.liveUrl != null)
            AnimatedButton(
              text: "View Live",
              icon: Icons.launch,
              onTap: () => launchUrl(Uri.parse(project.liveUrl!)),
            ),
          if (project.liveUrl != null) const SizedBox(height: 16),
          if (project.githubUrl != null)
            AnimatedButton(
              text: "View Code",
              icon: Icons.code,
              isOutlined: true,
              onTap: () => launchUrl(Uri.parse(project.githubUrl!)),
            ),
        ],
      ),
    );
  }
}
