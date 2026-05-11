import 'package:flutter/material.dart';
import '../../../core/theme/verve_theme.dart';

class HeroCard extends StatefulWidget {
  final String title;
  final bool isLowFidelity;

  const HeroCard({
    super.key,
    required this.title,
    this.isLowFidelity = false,
  });

  @override
  State<HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<HeroCard> with SingleTickerProviderStateMixin {
  late final AnimationController _tiltController;
  late final Animation<double> _tiltAnimation;

  @override
  void initState() {
    super.initState();
    _tiltController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _tiltAnimation = Tween<double>(begin: -0.05, end: 0.05).animate(CurvedAnimation(
      parent: _tiltController,
      curve: Curves.easeInOut,
    ));

    if (!widget.isLowFidelity) {
      _tiltController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(HeroCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLowFidelity && _tiltController.isAnimating) {
      _tiltController.stop();
    } else if (!widget.isLowFidelity && !_tiltController.isAnimating) {
      _tiltController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _tiltController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      width: 300,
      height: 400,
      decoration: BoxDecoration(
        color: VerveTokens.auraTeal.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: VerveTokens.auraTeal.withValues(alpha: widget.isLowFidelity ? 0.2 : 0.5)),
        boxShadow: widget.isLowFidelity ? null : [
          BoxShadow(
            color: VerveTokens.auraTeal.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 5,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_bag_outlined, size: 64, color: VerveTokens.auraTeal),
            const SizedBox(height: 24),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            const Text("Swipe to dismiss", style: TextStyle(color: Colors.white54)),
          ],
        ),
      ),
    );

    if (widget.isLowFidelity) {
      return Center(child: cardContent);
    }

    return AnimatedBuilder(
      animation: _tiltAnimation,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateX(_tiltAnimation.value)
            ..rotateY(_tiltAnimation.value),
          alignment: FractionalOffset.center,
          child: child,
        );
      },
      child: Center(child: cardContent),
    );
  }
}
