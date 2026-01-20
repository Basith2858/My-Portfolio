import 'dart:math' as math;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Futuristic animated background with star field, orbs, grid, and cursor spotlight
class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _orbController;
  late AnimationController _starController;
  late List<_GradientOrb> _orbs;
  late List<_Star> _stars;
  Offset _mousePosition = Offset.zero;
  bool _showSpotlight = false;

  @override
  void initState() {
    super.initState();
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    _orbs = List.generate(4, (index) => _GradientOrb(index));
    _stars = List.generate(60, (index) => _Star(index));
  }

  @override
  void dispose() {
    _orbController.dispose();
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return MouseRegion(
      onHover: kIsWeb
          ? (event) {
              setState(() {
                _mousePosition = event.localPosition;
                _showSpotlight = true;
              });
            }
          : null,
      onExit: kIsWeb ? (_) => setState(() => _showSpotlight = false) : null,
      child: Stack(
        children: [
          // Base gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        const Color(0xFF050508),
                        const Color(0xFF0A0A12),
                        const Color(0xFF050510),
                      ]
                    : [
                        AppColors.backgroundLight,
                        const Color(0xFFF0F4FF),
                        AppColors.backgroundLight,
                      ],
              ),
            ),
          ),

          // Grid lines (subtle)
          if (isDark)
            CustomPaint(
              size: size,
              painter: _GridPainter(
                color: AppColors.primary.withValues(alpha: 0.03),
              ),
            ),

          // Star field
          AnimatedBuilder(
            animation: _starController,
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: _StarFieldPainter(
                  stars: _stars,
                  progress: _starController.value,
                  isDark: isDark,
                ),
              );
            },
          ),

          // Animated gradient orbs
          ...List.generate(_orbs.length, (index) {
            return AnimatedBuilder(
              animation: _orbController,
              builder: (context, child) {
                final orb = _orbs[index];
                final progress = (_orbController.value + orb.offset) % 1.0;
                final x =
                    orb.startX + math.sin(progress * 2 * math.pi) * orb.radiusX;
                final y =
                    orb.startY + math.cos(progress * 2 * math.pi) * orb.radiusY;

                return Positioned(
                  left: x,
                  top: y,
                  child: Container(
                    width: orb.size,
                    height: orb.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          orb.color.withValues(alpha: isDark ? 0.15 : 0.1),
                          orb.color.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Cursor spotlight (web only)
          if (kIsWeb && _showSpotlight && isDark)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _SpotlightPainter(
                    position: _mousePosition,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

          // Content
          widget.child,
        ],
      ),
    );
  }
}

// Star data class
class _Star {
  final double x;
  final double y;
  final double size;
  final double twinkleOffset;
  final double brightness;

  static final _random = math.Random(42);

  _Star(int index)
    : x = _random.nextDouble(),
      y = _random.nextDouble(),
      size = 1.0 + _random.nextDouble() * 2.0,
      twinkleOffset = _random.nextDouble(),
      brightness = 0.3 + _random.nextDouble() * 0.7;
}

// Star field painter
class _StarFieldPainter extends CustomPainter {
  final List<_Star> stars;
  final double progress;
  final bool isDark;

  _StarFieldPainter({
    required this.stars,
    required this.progress,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isDark) return;

    for (final star in stars) {
      // Calculate twinkle
      final twinkle =
          (math.sin((progress + star.twinkleOffset) * math.pi * 2) + 1) / 2;
      final alpha = star.brightness * (0.3 + twinkle * 0.7);

      final paint = Paint()
        ..color = Colors.white.withValues(alpha: alpha * 0.8)
        ..style = PaintingStyle.fill;

      // Add glow for brighter stars
      if (star.brightness > 0.7) {
        final glowPaint = Paint()
          ..color = AppColors.primary.withValues(alpha: alpha * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        canvas.drawCircle(
          Offset(star.x * size.width, star.y * size.height),
          star.size * 2,
          glowPaint,
        );
      }

      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarFieldPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// Grid painter
class _GridPainter extends CustomPainter {
  final Color color;

  _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const spacing = 80.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => false;
}

// Cursor spotlight painter
class _SpotlightPainter extends CustomPainter {
  final Offset position;
  final Color color;

  _SpotlightPainter({required this.position, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: 0.15),
          color.withValues(alpha: 0.05),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Rect.fromCircle(center: position, radius: 300));

    canvas.drawCircle(position, 300, paint);
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) {
    return oldDelegate.position != position;
  }
}

// Gradient orb data class
class _GradientOrb {
  final double startX;
  final double startY;
  final double radiusX;
  final double radiusY;
  final double size;
  final double offset;
  final Color color;

  static final _colors = [
    AppColors.accentPurple,
    AppColors.accentBlue,
    AppColors.primary,
    AppColors.accentCyan,
  ];

  _GradientOrb(int index)
    : startX = (index % 2 == 0 ? 50 : 200) + (index * 120).toDouble(),
      startY = (index % 2 == 0 ? 100 : 350) + (index * 80).toDouble(),
      radiusX = 100 + (index * 40).toDouble(),
      radiusY = 80 + (index * 30).toDouble(),
      size = 350 + (index * 120).toDouble(),
      offset = index * 0.25,
      color = _colors[index % _colors.length];
}
