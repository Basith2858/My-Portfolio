import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Wrapper widget that animates children when they scroll into view
class ScrollReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double slideOffset;
  final bool enableBlur;

  const ScrollReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.slideOffset = 30,
    this.enableBlur = false,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // Delay initial visibility check to allow layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  void _checkVisibility() {
    if (!mounted) return;

    final renderObject = context.findRenderObject();
    if (renderObject is RenderBox) {
      final viewport = MediaQuery.of(context).size.height;
      final position = renderObject.localToGlobal(Offset.zero).dy;

      // Trigger animation when element enters bottom 80% of viewport
      if (position < viewport * 0.9 && !_isVisible) {
        setState(() => _isVisible = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _checkVisibility();
        return false;
      },
      child: AnimatedOpacity(
        duration: widget.duration,
        opacity: _isVisible ? 1.0 : 0.0,
        child: AnimatedSlide(
          duration: widget.duration,
          curve: Curves.easeOutCubic,
          offset: _isVisible
              ? Offset.zero
              : Offset(0, widget.slideOffset / 100),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Creates staggered animations for a list of children
class StaggeredList extends StatelessWidget {
  final List<Widget> children;
  final Duration initialDelay;
  final Duration staggerDelay;
  final Duration duration;
  final double slideOffset;
  final Axis axis;

  const StaggeredList({
    super.key,
    required this.children,
    this.initialDelay = Duration.zero,
    this.staggerDelay = const Duration(milliseconds: 100),
    this.duration = const Duration(milliseconds: 500),
    this.slideOffset = 20,
    this.axis = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        final delay = initialDelay + (staggerDelay * index);

        return child
            .animate(delay: delay)
            .fadeIn(duration: duration)
            .slideY(
              begin: slideOffset / 100,
              end: 0,
              duration: duration,
              curve: Curves.easeOutCubic,
            );
      }).toList(),
    );
  }
}

/// Extension for easy scroll reveal animations
extension ScrollRevealExtension on Widget {
  Widget scrollReveal({
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 600),
    double slideOffset = 30,
  }) {
    return ScrollReveal(
      delay: delay,
      duration: duration,
      slideOffset: slideOffset,
      child: this,
    );
  }

  Widget staggeredReveal({
    required int index,
    Duration initialDelay = Duration.zero,
    Duration staggerDelay = const Duration(milliseconds: 100),
    Duration duration = const Duration(milliseconds: 500),
  }) {
    final delay = initialDelay + (staggerDelay * index);
    return animate(delay: delay)
        .fadeIn(duration: duration)
        .slideY(
          begin: 0.1,
          end: 0,
          duration: duration,
          curve: Curves.easeOutCubic,
        );
  }
}
