import 'package:flutter/material.dart';

class CartActionButton extends StatefulWidget {
  final int count;
  final VoidCallback onPressed;

  const CartActionButton({super.key, required this.count, required this.onPressed});

  @override
  State<CartActionButton> createState() => _CartActionButtonState();
}

class _CartActionButtonState extends State<CartActionButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 520),
    vsync: this,
  );

  late final Animation<double> _shake = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0, end: 8), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 8, end: -8), weight: 2),
    TweenSequenceItem(tween: Tween(begin: -8, end: 0), weight: 1),
  ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  late final Animation<double> _tilt = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.05), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 0.05, end: -0.05), weight: 2),
    TweenSequenceItem(tween: Tween(begin: -0.05, end: 0.0), weight: 1),
  ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.12), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 1.12, end: 1.0), weight: 3),
  ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  @override
  void didUpdateWidget(covariant CartActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count != oldWidget.count) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showBadge = widget.count > 0;
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(_shake.value, 0),
        child: Transform.rotate(
          angle: _tilt.value,
          child: Transform.scale(
            scale: _scale.value,
            child: child,
          ),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: widget.onPressed,
            tooltip: 'Carrito',
          ),
          Positioned(
            right: 6,
            top: 6,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
              child: showBadge
                  ? Container(
                      key: ValueKey(widget.count),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${widget.count}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}