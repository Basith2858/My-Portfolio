import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Premium glass container with optional animated gradient border
class GlassContainer extends StatefulWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final Color? color;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final bool enableHover;
  final bool showGradientBorder;
  final List<Color>? gradientColors;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 10,
    this.opacity = 0.1,
    this.color,
    this.borderRadius,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.enableHover = true,
    this.showGradientBorder = false,
    this.gradientColors,
  });

  @override
  State<GlassContainer> createState() => _GlassContainerState();
}

class _GlassContainerState extends State<GlassContainer>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _borderController;

  @override
  void initState() {
    super.initState();
    _borderController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    if (widget.showGradientBorder) {
      _borderController.repeat();
    }
  }

  @override
  void dispose() {
    _borderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(20);
    final colors = widget.gradientColors ?? AppColors.primaryGradient;

    return MouseRegion(
      onEnter: widget.enableHover
          ? (_) => setState(() => _isHovered = true)
          : null,
      onExit: widget.enableHover
          ? (_) => setState(() => _isHovered = false)
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: widget.margin,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 30,
                    spreadRadius: -5,
                  ),
                ]
              : [
                  BoxShadow(
                    color: (isDark ? Colors.black : Colors.grey).withValues(
                      alpha: 0.1,
                    ),
                    blurRadius: 20,
                    spreadRadius: -5,
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
            child: AnimatedBuilder(
              animation: _borderController,
              builder: (context, child) {
                return Container(
                  padding: widget.padding,
                  decoration: BoxDecoration(
                    color: (widget.color ?? theme.colorScheme.surface)
                        .withValues(alpha: isDark ? 0.15 : widget.opacity),
                    borderRadius: borderRadius,
                    border: widget.showGradientBorder
                        ? _buildGradientBorder(colors)
                        : Border.all(
                            color: _isHovered
                                ? AppColors.primary.withValues(alpha: 0.3)
                                : theme.colorScheme.onSurface.withValues(
                                    alpha: 0.08,
                                  ),
                            width: _isHovered ? 1.5 : 1,
                          ),
                  ),
                  child: widget.child,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Border _buildGradientBorder(List<Color> colors) {
    // Animated gradient rotation effect
    final rotation = _borderController.value * 2 * 3.14159;
    final color1 = Color.lerp(
      colors[0],
      colors[1],
      (rotation / (2 * 3.14159)),
    )!;
    final color2 = Color.lerp(
      colors[1],
      colors[0],
      (rotation / (2 * 3.14159)),
    )!;

    return Border.all(
      color: Color.lerp(color1, color2, 0.5)!.withValues(alpha: 0.5),
      width: 1.5,
    );
  }
}

/// Simple gradient border painter for decorative use
class GradientBorderPainter extends CustomPainter {
  final List<Color> colors;
  final double strokeWidth;
  final double radius;
  final double rotation;

  GradientBorderPainter({
    required this.colors,
    this.strokeWidth = 2,
    this.radius = 20,
    this.rotation = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    final paint = Paint()
      ..shader = SweepGradient(
        colors: [...colors, colors.first],
        transform: GradientRotation(rotation),
      ).createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant GradientBorderPainter oldDelegate) {
    return oldDelegate.rotation != rotation;
  }
}
