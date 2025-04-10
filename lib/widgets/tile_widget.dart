import 'package:flutter/material.dart';

class TileWidget extends StatefulWidget {
  final int value;
  final bool isSelected;
  final bool isMatched;
  final VoidCallback onTap;
  final bool showConnection;

  const TileWidget({
    super.key,
    required this.value,
    this.isSelected = false,
    this.isMatched = false,
    required this.onTap,
    this.showConnection = false,
  });

  @override
  State<TileWidget> createState() => _TileWidgetState();
}

class _TileWidgetState extends State<TileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    if (widget.isMatched) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(TileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isMatched && !oldWidget.isMatched) {
      _controller.forward();
    } else if (!widget.isMatched && oldWidget.isMatched) {
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isSelected ? _scaleAnimation.value : 1.0,
            child: Transform.rotate(
              angle: widget.isSelected ? _rotateAnimation.value : 0.0,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.value == 0 ? Colors.grey[300] : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: widget.isSelected
                          ? Colors.blue.withOpacity(0.5)
                          : Colors.black.withOpacity(0.1),
                      spreadRadius: widget.isSelected ? 2 : 1,
                      blurRadius: widget.isSelected ? 5 : 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                  border: widget.isSelected
                      ? Border.all(color: Colors.blue, width: 2)
                      : null,
                ),
                child: widget.value == 0
                    ? null
                    : FadeTransition(
                        opacity: _opacityAnimation,
                        child: Image.asset(
                          'assets/images/tile_${widget.value}.png',
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
