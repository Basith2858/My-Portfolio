import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/portfolio_data.dart';
import '../../theme/app_theme.dart';
import '../common/responsive_wrapper.dart';
import 'package:url_launcher/url_launcher.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      constraints: BoxConstraints(minHeight: size.height * 0.9),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Center(
        child: ResponsiveWrapper(
          mobile: _buildContent(context, isMobile: true),
          desktop: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(flex: 3, child: _buildContent(context, isMobile: false)),
              const SizedBox(width: 60),
              Expanded(flex: 2, child: _buildIllustration(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, {required bool isMobile}) {
    final theme = Theme.of(context);
    final textAlign = isMobile ? TextAlign.center : TextAlign.start;
    final crossAlign = isMobile
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: crossAlign,
      children: [
        // Greeting badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.1),
                AppColors.accentCyan.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Available for new projects",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),

        const SizedBox(height: 24),

        // Name with gradient
        ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.primary, AppColors.accentCyan],
              ).createShader(bounds),
              child: Text(
                "Hi, I'm ${PortfolioData.name}",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: textAlign,
              ),
            )
            .animate()
            .fadeIn(delay: 100.ms, duration: 600.ms)
            .slideY(begin: 0.2, end: 0),

        const SizedBox(height: 16),

        // Title with typewriter effect
        _TypewriterText(
              text: PortfolioData.title,
              style: theme.textTheme.displayMedium?.copyWith(
                height: 1.2,
                fontWeight: FontWeight.bold,
              ),
              textAlign: textAlign,
            )
            .animate()
            .fadeIn(delay: 200.ms, duration: 600.ms)
            .slideY(begin: 0.2, end: 0),

        const SizedBox(height: 20),

        // Description
        Container(
              constraints: BoxConstraints(maxWidth: isMobile ? 350 : 500),
              child: Text(
                PortfolioData.aboutShort,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.6,
                ),
                textAlign: textAlign,
              ),
            )
            .animate()
            .fadeIn(delay: 300.ms, duration: 600.ms)
            .slideY(begin: 0.2, end: 0),

        const SizedBox(height: 40),

        // CTA Buttons
        Wrap(
              alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
              spacing: 16,
              runSpacing: 16,
              children: [
                _GradientButton(
                  text: "View My Work",
                  icon: Icons.arrow_forward_rounded,
                  onTap: () {
                    // Scroll to projects
                  },
                ),
                _OutlineButton(
                  text: "Download CV",
                  icon: Icons.download_rounded,
                  onTap: () {
                    // Download CV
                  },
                ),
              ],
            )
            .animate()
            .fadeIn(delay: 400.ms, duration: 600.ms)
            .slideY(begin: 0.2, end: 0),

        const SizedBox(height: 48),

        // Social Icons
        Row(
          mainAxisAlignment: isMobile
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            _SocialIcon(
              icon: "assets/icons/github.svg",
              url: PortfolioData.githubUrl,
              delay: 500,
            ),
            const SizedBox(width: 16),
            _SocialIcon(
              icon: "assets/icons/linkedin.svg",
              url: PortfolioData.linkedinUrl,
              delay: 600,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIllustration(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow ring
          _AnimatedRing(size: 400, color: AppColors.primary, delay: 0),
          _AnimatedRing(size: 320, color: AppColors.accentBlue, delay: 200),
          _AnimatedRing(size: 240, color: AppColors.accentPurple, delay: 400),

          // Center content
          Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.2),
                      AppColors.accentCyan.withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 60,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.code_rounded,
                    size: 80,
                    color: AppColors.primary,
                  ),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1.05, 1.05),
                duration: 2000.ms,
              ),

          // Floating particles
          ...List.generate(6, (index) {
            final angle = (index * 60) * (math.pi / 180);
            final radius = 160.0;
            return Positioned(
              left: 200 + math.cos(angle) * radius,
              top: 200 + math.sin(angle) * radius,
              child: _FloatingParticle(
                delay: index * 200,
                color: index.isEven
                    ? AppColors.primary
                    : AppColors.accentPurple,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;

  const _TypewriterText({
    required this.text,
    this.style,
    this.textAlign = TextAlign.start,
  });

  @override
  State<_TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<_TypewriterText>
    with TickerProviderStateMixin {
  late AnimationController _typeController;
  late AnimationController _cursorController;
  late AnimationController _gradientController;
  late Animation<int> _characterCount;

  @override
  void initState() {
    super.initState();

    // Typing animation
    _typeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.text.length * 50),
    );

    _characterCount = IntTween(
      begin: 0,
      end: widget.text.length,
    ).animate(CurvedAnimation(parent: _typeController, curve: Curves.easeOut));

    // Cursor blink animation
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    // Gradient animation (after typing completes)
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Start typing after a short delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _typeController.forward().then((_) {
          // Start gradient animation after typing
          _cursorController.stop();
          _gradientController.repeat();
        });
      }
    });
  }

  @override
  void dispose() {
    _typeController.dispose();
    _cursorController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _typeController,
        _gradientController,
        _cursorController,
      ]),
      builder: (context, child) {
        final displayText = widget.text.substring(0, _characterCount.value);
        final showCursor = !_typeController.isCompleted;

        return ShaderMask(
          shaderCallback: (bounds) {
            if (_gradientController.isAnimating) {
              return LinearGradient(
                colors: const [
                  AppColors.textPrimaryDark,
                  AppColors.primary,
                  AppColors.accentCyan,
                  AppColors.textPrimaryDark,
                ],
                stops: [
                  0.0,
                  _gradientController.value,
                  (_gradientController.value + 0.2).clamp(0.0, 1.0),
                  1.0,
                ],
              ).createShader(bounds);
            }
            return const LinearGradient(
              colors: [AppColors.textPrimaryDark, AppColors.textPrimaryDark],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: RichText(
            textAlign: widget.textAlign,
            text: TextSpan(
              style: widget.style,
              children: [
                TextSpan(text: displayText),
                if (showCursor)
                  TextSpan(
                    text: '|',
                    style: widget.style?.copyWith(
                      color: AppColors.primary.withValues(
                        alpha: _cursorController.value,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GradientButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _GradientButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.primaryGradient),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(
                  alpha: _isHovered ? 0.5 : 0.3,
                ),
                blurRadius: _isHovered ? 25 : 15,
                spreadRadius: _isHovered ? 2 : 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 8),
              Icon(widget.icon, color: Colors.white, size: 18)
                  .animate(target: _isHovered ? 1 : 0)
                  .moveX(begin: 0, end: 4, duration: 200.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _OutlineButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<_OutlineButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.text,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.download_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedRing extends StatelessWidget {
  final double size;
  final Color color;
  final int delay;

  const _AnimatedRing({
    required this.size,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
          ),
        )
        .animate(delay: delay.ms)
        .fadeIn(duration: 800.ms)
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1))
        .then()
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.05, 1.05),
          duration: 3000.ms,
          curve: Curves.easeInOut,
        );
  }
}

class _FloatingParticle extends StatelessWidget {
  final int delay;
  final Color color;

  const _FloatingParticle({required this.delay, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 10),
            ],
          ),
        )
        .animate(delay: delay.ms)
        .fadeIn()
        .then()
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(begin: -10, end: 10, duration: 2000.ms, curve: Curves.easeInOut);
  }
}

class _SocialIcon extends StatefulWidget {
  final String icon;
  final String url;
  final int delay;

  const _SocialIcon({
    required this.icon,
    required this.url,
    required this.delay,
  });

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: () => launchUrl(Uri.parse(widget.url)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isHovered
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : theme.colorScheme.surface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isHovered
                      ? AppColors.primary.withValues(alpha: 0.5)
                      : theme.colorScheme.onSurface.withValues(alpha: 0.1),
                ),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          blurRadius: 15,
                        ),
                      ]
                    : null,
              ),
              child: SvgPicture.asset(
                widget.icon,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  _isHovered ? AppColors.primary : theme.iconTheme.color!,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        )
        .animate(delay: widget.delay.ms)
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.3, end: 0);
  }
}
