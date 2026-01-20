import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final IconData? icon;
  final bool isOutlined;

  const AnimatedButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
    this.isOutlined = false,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child:
            AnimatedContainer(
                  duration: 200.ms,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: widget.isOutlined
                        ? Colors.transparent
                        : (_isHovered
                              ? colorScheme.primary.withOpacity(0.9)
                              : colorScheme.primary),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: colorScheme.primary, width: 2),
                    boxShadow: _isHovered && !widget.isOutlined
                        ? [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.text,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: widget.isOutlined
                              ? colorScheme.primary
                              : colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      if (widget.icon != null) ...[
                        const SizedBox(width: 8),
                        Icon(
                          widget.icon,
                          size: 18,
                          color: widget.isOutlined
                              ? colorScheme.primary
                              : colorScheme.onPrimary,
                        ),
                      ],
                    ],
                  ),
                )
                .animate(target: _isHovered ? 1 : 0)
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.05, 1.05),
                ),
      ),
    );
  }
}
