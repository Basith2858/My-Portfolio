import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/portfolio_data.dart';
import '../../theme/app_theme.dart';
import '../common/responsive_wrapper.dart';

// Scroll progress provider
final scrollProgressProvider = StateProvider<double>((ref) => 0.0);
final activeSectionProvider = StateProvider<int>((ref) => 0);

class NavBar extends ConsumerWidget implements PreferredSizeWidget {
  const NavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final theme = Theme.of(context);
    final scrollProgress = ref.watch(scrollProgressProvider);
    final activeSection = ref.watch(activeSectionProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Scroll progress indicator
        Container(
          height: 2,
          width: double.infinity,
          color: Colors.transparent,
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: MediaQuery.of(context).size.width * scrollProgress,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: AppColors.primaryGradient),
            ),
          ),
        ),

        // Navbar content
        Expanded(
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0A0A12).withValues(alpha: 0.8)
                      : theme.scaffoldBackgroundColor.withValues(alpha: 0.85),
                  border: Border(
                    bottom: BorderSide(
                      color: isDark
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : theme.colorScheme.onSurface.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo with neon glow
                    _AnimatedLogo(isDark: isDark),

                    // Desktop Menu
                    if (ResponsiveWrapper.isDesktop(context) ||
                        ResponsiveWrapper.isTablet(context))
                      Row(
                        children: [
                          _NavLink(
                            title: "Home",
                            isActive: activeSection == 0,
                            onTap: () => _scrollToSection(context, ref, 0),
                          ),
                          _NavLink(
                            title: "About",
                            isActive: activeSection == 1,
                            onTap: () => _scrollToSection(context, ref, 1),
                          ),
                          _NavLink(
                            title: "Skills",
                            isActive: activeSection == 2,
                            onTap: () => _scrollToSection(context, ref, 2),
                          ),
                          _NavLink(
                            title: "Projects",
                            isActive: activeSection == 3,
                            onTap: () => _scrollToSection(context, ref, 3),
                          ),
                          _NavLink(
                            title: "Contact",
                            isActive: activeSection == 4,
                            onTap: () => _scrollToSection(context, ref, 4),
                          ),
                          const SizedBox(width: 24),
                          _ThemeToggle(
                            isDark: isDark,
                            onToggle: () => ref
                                .read(themeModeProvider.notifier)
                                .toggleTheme(),
                          ),
                        ],
                      )
                    else
                      // Mobile Menu
                      Row(
                        children: [
                          _ThemeToggle(
                            isDark: isDark,
                            onToggle: () => ref
                                .read(themeModeProvider.notifier)
                                .toggleTheme(),
                          ),
                          const SizedBox(width: 8),
                          _MenuButton(
                            onTap: () => Scaffold.of(context).openEndDrawer(),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _scrollToSection(BuildContext context, WidgetRef ref, int index) {
    if (GoRouterState.of(context).uri.toString() != '/') {
      context.go('/');
    }
    // Set active section - scroll will be handled by home_screen
    ref.read(activeSectionProvider.notifier).state = index;
  }
}

class _MenuButton extends StatefulWidget {
  final VoidCallback onTap;

  const _MenuButton({required this.onTap});

  @override
  State<_MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<_MenuButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.primary.withValues(alpha: 0.1)
                : theme.colorScheme.surface.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : theme.colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
          child: Icon(
            Icons.menu_rounded,
            color: _isHovered ? AppColors.primary : theme.iconTheme.color,
          ),
        ),
      ),
    );
  }
}

class _AnimatedLogo extends StatefulWidget {
  final bool isDark;

  const _AnimatedLogo({required this.isDark});

  @override
  State<_AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<_AnimatedLogo> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => context.go('/'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: _isHovered
                ? LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.15),
                      AppColors.accentCyan.withValues(alpha: 0.1),
                    ],
                  )
                : null,
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 25,
                      spreadRadius: -8,
                    ),
                  ]
                : null,
            border: _isHovered
                ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
                : null,
          ),
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: _isHovered
                  ? [AppColors.primary, AppColors.accentCyan]
                  : [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor,
                    ],
            ).createShader(bounds),
            child: Text(
              "< ${PortfolioData.name} />",
              style: GoogleFonts.firaCode(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2, end: 0);
  }
}

class _NavLink extends StatefulWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _NavLink({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHighlighted = _isHovered || widget.isActive;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
                  color: isHighlighted
                      ? AppColors.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  letterSpacing: isHighlighted ? 0.5 : 0,
                ),
                child: Text(widget.title),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: isHighlighted ? 24 : 0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  gradient: const LinearGradient(
                    colors: AppColors.primaryGradient,
                  ),
                  boxShadow: widget.isActive
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ]
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const _ThemeToggle({required this.isDark, required this.onToggle});

  @override
  State<_ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<_ThemeToggle> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _isHovered
                ? (widget.isDark ? Colors.amber : Colors.indigo).withValues(
                    alpha: 0.1,
                  )
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: _isHovered
                ? Border.all(
                    color: (widget.isDark ? Colors.amber : Colors.indigo)
                        .withValues(alpha: 0.3),
                  )
                : null,
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: (widget.isDark ? Colors.amber : Colors.indigo)
                          .withValues(alpha: 0.3),
                      blurRadius: 15,
                      spreadRadius: -5,
                    ),
                  ]
                : null,
          ),
          child:
              Icon(
                    widget.isDark
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    color: widget.isDark ? Colors.amber : Colors.indigo,
                    size: 20,
                  )
                  .animate(target: _isHovered ? 1 : 0)
                  .rotate(begin: 0, end: 0.1)
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.15, 1.15),
                  ),
        ),
      ),
    );
  }
}
