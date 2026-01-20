import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../data/portfolio_data.dart';
import '../../theme/app_theme.dart';
import '../common/glass_container.dart';
import '../common/responsive_wrapper.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Column(
        children: [
          // Section header
          _buildSectionHeader(theme),
          const SizedBox(height: 60),

          // Projects grid
          ResponsiveWrapper(
            mobile: Column(
              children: PortfolioData.projects
                  .take(3)
                  .toList()
                  .asMap()
                  .entries
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: _ProjectCard(project: e.value, index: e.key),
                    ),
                  )
                  .toList(),
            ),
            desktop: Wrap(
              spacing: 32,
              runSpacing: 32,
              alignment: WrapAlignment.center,
              children: PortfolioData.projects
                  .take(3)
                  .toList()
                  .asMap()
                  .entries
                  .map(
                    (e) => SizedBox(
                      width: 380,
                      child: _ProjectCard(project: e.value, index: e.key),
                    ),
                  )
                  .toList(),
            ),
          ),

          const SizedBox(height: 48),

          // View all button
          _ViewAllButton(onTap: () => context.go('/projects')),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accentBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "PORTFOLIO",
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.accentBlue,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.accentBlue, AppColors.accentCyan],
          ).createShader(bounds),
          child: Text(
            "Featured Projects",
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Some of my recent work",
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0);
  }
}

class _ProjectCard extends StatefulWidget {
  final Project project;
  final int index;

  const _ProjectCard({required this.project, required this.index});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isHovered = false;
  Offset _mousePosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() {
            _isHovered = false;
            _mousePosition = Offset.zero;
          }),
          onHover: (event) {
            setState(() => _mousePosition = event.localPosition);
          },
          child: GestureDetector(
            onTap: () => context.go('/project/${widget.project.id}'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: _buildTransform(),
              transformAlignment: Alignment.center,
              child: GlassContainer(
                padding: EdgeInsets.zero,
                enableHover: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project image with overlay
                    _buildImageSection(theme),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title with arrow
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.project.title,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _isHovered
                                      ? AppColors.primary
                                      : theme.colorScheme.surface.withValues(
                                          alpha: 0.5,
                                        ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.arrow_outward_rounded,
                                  size: 16,
                                  color: _isHovered
                                      ? Colors.white
                                      : theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Description
                          Text(
                            widget.project.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Tags
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.project.tags.take(3).map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.2,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  tag,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate(delay: (150 * widget.index).ms)
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.15, end: 0);
  }

  Widget _buildImageSection(ThemeData theme) {
    return Stack(
      children: [
        // Image placeholder
        AspectRatio(
          aspectRatio: 16 / 10,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.accentBlue.withValues(alpha: 0.3),
                  AppColors.accentPurple.withValues(alpha: 0.3),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.image_rounded,
                size: 60,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ),
          ),
        ),

        // Gradient overlay on hover
        Positioned.fill(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _isHovered ? 1 : 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.primary.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Shine effect on hover
        if (_isHovered)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                gradient: RadialGradient(
                  center: Alignment(
                    (_mousePosition.dx / 380 * 2) - 1,
                    (_mousePosition.dy / 200 * 2) - 1,
                  ),
                  radius: 0.8,
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Matrix4 _buildTransform() {
    if (!_isHovered) return Matrix4.identity();

    // Subtle 3D tilt effect based on mouse position
    const maxTilt = 0.02;
    final centerX = 190.0; // Half of card width
    final centerY = 150.0; // Approximate center

    final dx = (_mousePosition.dx - centerX) / centerX;
    final dy = (_mousePosition.dy - centerY) / centerY;

    return Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateX(-dy * maxTilt)
      ..rotateY(dx * maxTilt)
      ..translate(0.0, -5.0, 0.0);
  }
}

class _ViewAllButton extends StatefulWidget {
  final VoidCallback onTap;

  const _ViewAllButton({required this.onTap});

  @override
  State<_ViewAllButton> createState() => _ViewAllButtonState();
}

class _ViewAllButtonState extends State<_ViewAllButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: _isHovered
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: _isHovered
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "View All Projects",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ).animate(target: _isHovered ? 1 : 0).moveX(begin: 0, end: 4),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 500.ms, duration: 400.ms)
        .slideY(begin: 0.2, end: 0);
  }
}
