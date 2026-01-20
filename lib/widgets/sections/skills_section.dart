import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/portfolio_data.dart';
import '../../theme/app_theme.dart';
import '../common/glass_container.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Section header
          _buildSectionHeader(theme),
          const SizedBox(height: 60),

          // Skill categories
          Wrap(
            spacing: 32,
            runSpacing: 32,
            alignment: WrapAlignment.center,
            children: PortfolioData.skillCategories.asMap().entries.map((
              entry,
            ) {
              final index = entry.key;
              final category = entry.value;
              return _SkillCard(category: category, index: index);
            }).toList(),
          ),
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
            color: AppColors.accentPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "EXPERTISE",
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.accentPurple,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.accentPurple, AppColors.accentBlue],
          ).createShader(bounds),
          child: Text(
            "Skills & Technologies",
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Tools and technologies I work with",
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0);
  }
}

class _SkillCard extends StatefulWidget {
  final SkillCategory category;
  final int index;

  const _SkillCard({required this.category, required this.index});

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _isHovered = false;

  static const _categoryIcons = {
    'Mobile Development': Icons.phone_android_rounded,
    'Frontend': Icons.web_rounded,
    'Backend': Icons.dns_rounded,
    'Tools & Others': Icons.build_rounded,
    'Languages': Icons.code_rounded,
    'Database': Icons.storage_rounded,
  };

  static const _categoryColors = [
    AppColors.primary,
    AppColors.accentBlue,
    AppColors.accentPurple,
    AppColors.accentPink,
    AppColors.accentOrange,
    AppColors.accentCyan,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _categoryColors[widget.index % _categoryColors.length];
    final icon = _categoryIcons[widget.category.title] ?? Icons.star_rounded;

    return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.identity()
              ..setTranslationRaw(0, _isHovered ? -8 : 0, 0),
            child: GlassContainer(
              padding: const EdgeInsets.all(28),
              showGradientBorder: _isHovered,
              gradientColors: [color, color.withValues(alpha: 0.5)],
              child: SizedBox(
                width: 320,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with icon
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                color.withValues(alpha: 0.2),
                                color.withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icon, color: color, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            widget.category.title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Skills with animated chips
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: widget.category.skills.asMap().entries.map((e) {
                        return _AnimatedSkillChip(
                          skill: e.value,
                          color: color,
                          delay: e.key * 50,
                          isHovered: _isHovered,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate(delay: (100 * widget.index).ms)
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.2, end: 0);
  }
}

class _AnimatedSkillChip extends StatefulWidget {
  final String skill;
  final Color color;
  final int delay;
  final bool isHovered;

  const _AnimatedSkillChip({
    required this.skill,
    required this.color,
    required this.delay,
    required this.isHovered,
  });

  @override
  State<_AnimatedSkillChip> createState() => _AnimatedSkillChipState();
}

class _AnimatedSkillChipState extends State<_AnimatedSkillChip> {
  bool _isChipHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isChipHovered = true),
      onExit: (_) => setState(() => _isChipHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _isChipHovered
              ? widget.color.withValues(alpha: 0.2)
              : widget.color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isChipHovered
                ? widget.color.withValues(alpha: 0.5)
                : widget.color.withValues(alpha: 0.2),
          ),
          boxShadow: _isChipHovered
              ? [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.2),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        child: Text(
          widget.skill,
          style: theme.textTheme.bodySmall?.copyWith(
            color: _isChipHovered
                ? widget.color
                : theme.colorScheme.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
