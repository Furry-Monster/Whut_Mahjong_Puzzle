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
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _shimmerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isSelected) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(TileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 处理选中状态变化
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }

    // 处理消除状态变化
    if (widget.isMatched && !oldWidget.isMatched) {
      _startDisappearingAnimation();
    }
  }

  void _startDisappearingAnimation() {
    setState(() {});

    // 重置动画
    _controller.reset();

    // 创建新的消失动画
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _shimmerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // 播放动画
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value == 0) {
      return Container(); // 空白方块
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotateAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: widget.isSelected
                        ? Border.all(color: Colors.blue, width: 3)
                        : null,
                    boxShadow: widget.isSelected
                        ? [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            )
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: const Offset(0, 2),
                            )
                          ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        // 基础图片
                        Image.asset(
                          'assets/images/tile_${widget.value}.png',
                          fit: BoxFit.cover,
                        ),

                        // 渐变叠加层
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _TileGradientPainter(
                              value: widget.value,
                              shimmerValue: _shimmerAnimation.value,
                            ),
                          ),
                        ),

                        // 光泽效果
                        if (widget.isSelected)
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _ShimmerPainter(
                                shimmerValue: _shimmerAnimation.value,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// 渐变效果绘制器
class _TileGradientPainter extends CustomPainter {
  final int value;
  final double shimmerValue;

  _TileGradientPainter({
    required this.value,
    required this.shimmerValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // 根据方块值创建不同的渐变
    final colors = _getGradientColors(value);

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
      stops: const [0.0, 0.7, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.overlay;

    canvas.drawRect(rect, paint);
  }

  List<Color> _getGradientColors(int value) {
    switch (value) {
      case 1:
        return [
          Colors.red.withOpacity(0.3),
          Colors.red.withOpacity(0.1),
          Colors.red.withOpacity(0.0),
        ];
      case 2:
        return [
          Colors.orange.withOpacity(0.3),
          Colors.orange.withOpacity(0.1),
          Colors.orange.withOpacity(0.0),
        ];
      case 3:
        return [
          Colors.yellow.withOpacity(0.3),
          Colors.yellow.withOpacity(0.1),
          Colors.yellow.withOpacity(0.0),
        ];
      case 4:
        return [
          Colors.green.withOpacity(0.3),
          Colors.green.withOpacity(0.1),
          Colors.green.withOpacity(0.0),
        ];
      case 5:
        return [
          Colors.blue.withOpacity(0.3),
          Colors.blue.withOpacity(0.1),
          Colors.blue.withOpacity(0.0),
        ];
      case 6:
        return [
          Colors.indigo.withOpacity(0.3),
          Colors.indigo.withOpacity(0.1),
          Colors.indigo.withOpacity(0.0),
        ];
      case 7:
        return [
          Colors.purple.withOpacity(0.3),
          Colors.purple.withOpacity(0.1),
          Colors.purple.withOpacity(0.0),
        ];
      case 8:
        return [
          Colors.pink.withOpacity(0.3),
          Colors.pink.withOpacity(0.1),
          Colors.pink.withOpacity(0.0),
        ];
      default:
        return [
          Colors.grey.withOpacity(0.3),
          Colors.grey.withOpacity(0.1),
          Colors.grey.withOpacity(0.0),
        ];
    }
  }

  @override
  bool shouldRepaint(_TileGradientPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.shimmerValue != shimmerValue;
  }
}

// 光泽效果绘制器
class _ShimmerPainter extends CustomPainter {
  final double shimmerValue;

  _ShimmerPainter({
    required this.shimmerValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // 创建光泽路径
    final path = Path();
    final shimmerWidth = width * 0.5;
    final shimmerHeight = height * 0.1;

    // 计算光泽位置
    final shimmerX = width * shimmerValue - shimmerWidth;
    final shimmerY = height * 0.2;

    path.moveTo(shimmerX, shimmerY);
    path.lineTo(shimmerX + shimmerWidth, shimmerY);
    path.lineTo(shimmerX + shimmerWidth * 0.8, shimmerY + shimmerHeight);
    path.lineTo(shimmerX + shimmerWidth * 0.2, shimmerY + shimmerHeight);
    path.close();

    // 绘制光泽
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ShimmerPainter oldDelegate) {
    return oldDelegate.shimmerValue != shimmerValue;
  }
}
