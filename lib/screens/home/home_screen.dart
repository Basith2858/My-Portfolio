import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/animated_background.dart';
import '../../widgets/layout/footer.dart';
import '../../widgets/layout/nav_bar.dart';
import '../../widgets/sections/about_section.dart';
import '../../widgets/sections/contact_section.dart';
import '../../widgets/sections/hero_section.dart';
import '../../widgets/sections/projects_section.dart';
import '../../widgets/sections/skills_section.dart';
import '../../widgets/sections/cta_strip.dart';

// Provider to store keys for scrolling
final homeScrollKeysProvider = Provider<List<GlobalKey>>((ref) {
  return List.generate(5, (_) => GlobalKey());
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;

    // Update scroll progress
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    final progress = maxScroll > 0
        ? (currentScroll / maxScroll).clamp(0.0, 1.0)
        : 0.0;
    ref.read(scrollProgressProvider.notifier).state = progress;

    // Update active section based on scroll position
    _updateActiveSection();
  }

  void _updateActiveSection() {
    final keys = ref.read(homeScrollKeysProvider);

    final viewportHeight = MediaQuery.of(context).size.height;

    int activeIndex = 0;
    for (int i = 0; i < keys.length; i++) {
      final key = keys[i];
      if (key.currentContext != null) {
        final box = key.currentContext!.findRenderObject() as RenderBox?;
        if (box != null) {
          final position = box.localToGlobal(Offset.zero).dy;
          // Section is active when it's in the top third of the viewport
          if (position <= viewportHeight * 0.4) {
            activeIndex = i;
          }
        }
      }
    }

    if (ref.read(activeSectionProvider) != activeIndex) {
      ref.read(activeSectionProvider.notifier).state = activeIndex;
    }
  }

  void _scrollToSection(int index) {
    final keys = ref.read(homeScrollKeysProvider);
    if (index < keys.length && keys[index].currentContext != null) {
      Scrollable.ensureVisible(
        keys[index].currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final keys = ref.watch(homeScrollKeysProvider);

    // Listen for section changes from navbar
    ref.listen<int>(activeSectionProvider, (previous, next) {
      if (previous != next) {
        _scrollToSection(next);
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const NavBar(),
      endDrawer: const _MobileDrawer(),
      body: AnimatedBackground(
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(key: keys[0], child: const HeroSection()),
              _SectionDivider(),
              SizedBox(key: keys[1], child: const AboutSection()),
              _SectionDivider(),
              SizedBox(key: keys[2], child: const SkillsSection()),
              _SectionDivider(),
              SizedBox(key: keys[3], child: const ProjectsSection()),
              _SectionDivider(),
              SizedBox(key: keys[4], child: const ContactSection()),
              const CTAStrip(),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            (isDark ? AppColors.primary : AppColors.accentBlue).withValues(
              alpha: 0.2,
            ),
            (isDark ? AppColors.accentCyan : AppColors.accentPurple).withValues(
              alpha: 0.2,
            ),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class _MobileDrawer extends ConsumerWidget {
  const _MobileDrawer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keys = ref.read(homeScrollKeysProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeSection = ref.watch(activeSectionProvider);

    return Drawer(
      backgroundColor: isDark
          ? const Color(0xFF0A0A12)
          : theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: AppColors.primaryGradient,
                ).createShader(bounds),
                child: Text(
                  "Menu",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // Menu items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  _DrawerItem(
                    icon: Icons.home_rounded,
                    title: "Home",
                    isActive: activeSection == 0,
                    onTap: () {
                      Navigator.pop(context);
                      ref.read(activeSectionProvider.notifier).state = 0;
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.person_rounded,
                    title: "About",
                    isActive: activeSection == 1,
                    onTap: () {
                      Navigator.pop(context);
                      ref.read(activeSectionProvider.notifier).state = 1;
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.code_rounded,
                    title: "Skills",
                    isActive: activeSection == 2,
                    onTap: () {
                      Navigator.pop(context);
                      ref.read(activeSectionProvider.notifier).state = 2;
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.work_rounded,
                    title: "Projects",
                    isActive: activeSection == 3,
                    onTap: () {
                      Navigator.pop(context);
                      ref.read(activeSectionProvider.notifier).state = 3;
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.email_rounded,
                    title: "Contact",
                    isActive: activeSection == 4,
                    onTap: () {
                      Navigator.pop(context);
                      ref.read(activeSectionProvider.notifier).state = 4;
                    },
                  ),
                ],
              ),
            ),

            // Theme toggle
            Padding(
              padding: const EdgeInsets.all(24),
              child: _ThemeToggleRow(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<_DrawerItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHighlighted = _isHovered || widget.isActive;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: isHighlighted
                ? LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.15),
                      AppColors.primary.withValues(alpha: 0.05),
                    ],
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
            border: widget.isActive
                ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
                : null,
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: isHighlighted
                    ? AppColors.primary
                    : theme.iconTheme.color,
                size: 22,
              ),
              const SizedBox(width: 16),
              Text(
                widget.title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
                  color: isHighlighted
                      ? AppColors.primary
                      : theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              if (widget.isActive)
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeToggleRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surface.withValues(alpha: 0.5),
            theme.colorScheme.surface.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: isDark ? Colors.amber : Colors.indigo,
              ),
              const SizedBox(width: 12),
              Text(
                isDark ? "Dark Mode" : "Light Mode",
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          Switch(
            value: isDark,
            onChanged: (_) =>
                ref.read(themeModeProvider.notifier).toggleTheme(),
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}
