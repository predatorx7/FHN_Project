import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// Tabview implementation for Navigation's Top-level peer fade-through motion transition.
///
/// References:
/// - https://material.io/design/navigation/navigation-transitions.html#peer-transitions
/// - https://material.io/design/motion/the-motion-system.html#fade-through
class DestinationTabView extends StatefulWidget {
  const DestinationTabView({
    Key? key,
    required this.index,
    required this.tabs,
    this.initialScaleForIncomingElements = 0.96,
  }) : super(key: key);

  final ValueListenable<int> index;
  final List<Widget> tabs;

  /// Value is 0.96 but the specs suggest 0.92.
  final double initialScaleForIncomingElements;

  @override
  State<DestinationTabView> createState() => _DestinationTabViewState();
}

class _DestinationTabViewState extends State<DestinationTabView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeOut;
  late Animation<double> _fadeIn;
  late Animation<double> _scaleOut;
  late Animation<double> _scaleIn;

  static const firstPartDurationMs = 90;
  static const secondPartDurationMs = 210;
  // total animation duration = 300 ms = 90 ms + 210 ms
  static const totalDurationMs = firstPartDurationMs + secondPartDurationMs;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: totalDurationMs),
      vsync: this,
    );
    // Each animation defined here transforms its value during the subset
    // of the controller's duration defined by the animation's interval.
    // For example the first opacity animation transforms its value during
    // the first 30% of the controller's duration.
    final firstAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.0,
        0.3,
        curve: Curves.ease,
      ),
    );
    _fadeOut = Tween(begin: 1.0, end: 0.0).animate(firstAnimation);
    final secondAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.7,
        1.0,
        curve: Curves.ease,
      ),
    );
    _fadeIn = Tween(begin: 0.0, end: 1.0).animate(
      secondAnimation,
    );
    _scaleOut = Tween(
      begin: 1.0,
      end: widget.initialScaleForIncomingElements,
    ).animate(firstAnimation);
    _scaleIn = Tween(
      begin: widget.initialScaleForIncomingElements,
      end: 1.0,
    ).animate(secondAnimation);
    currentIndex = ValueNotifier(widget.index.value);
    widget.index.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    widget.index.removeListener(_handleTabChange);
    _animationController.dispose();
    super.dispose();
  }

  late ValueNotifier<int> currentIndex;

  int get newIndex => widget.index.value;
  int get oldIndex => currentIndex.value;

  void _handleTabChange() async {
    if (oldIndex == newIndex) {
      return;
    }
    _animationController.reset();
    Future.delayed(const Duration(milliseconds: totalDurationMs + 5), () {
      // Change value of currentIndex after first part of the animation.
      currentIndex.value = newIndex;
    });
    try {
      await _animationController.forward().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because it was disposed of
    }
  }

  // This function is called each time the controller "ticks" a new frame.
  // When it runs, all of the animation's values will have been
  // updated to reflect the controller's current value.
  Widget _buildAnimation(BuildContext context, Widget? child) {
    // Show incoming element on fade in.
    final activeIndex = _fadeOut.value > 0 ? oldIndex : newIndex;
    final activeOpacity = max(_fadeOut.value, _fadeIn.value);
    final activeScale = max(_scaleOut.value, _scaleIn.value);
    return FadeTransition(
      opacity: AlwaysStoppedAnimation(activeOpacity),
      child: ScaleTransition(
        scale: AlwaysStoppedAnimation(activeScale),
        child: IndexedStack(
          index: activeIndex,
          children: widget.tabs,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: _buildAnimation,
    );
  }
}
