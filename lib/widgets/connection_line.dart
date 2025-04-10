import 'package:flutter/material.dart';

class ConnectionLine extends StatefulWidget {
  final Offset startPoint;
  final Offset endPoint;
  final List<Offset> pathPoints;
  final Color color;

  const ConnectionLine({
    super.key,
    required this.startPoint,
    required this.endPoint,
    required this.pathPoints,
    this.color = Colors.blue,
  });

  @override
  State<ConnectionLine> createState() => _ConnectionLineState();
}

class _ConnectionLineState extends State<ConnectionLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late List<Offset> _animatedPath;
  late List<double> _segmentLengths;
  late double _totalLength;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _calculatePathSegments();
    _controller.forward();
  }

  void _calculatePathSegments() {
    _animatedPath = [widget.startPoint];
    if (widget.pathPoints.isNotEmpty) {
      _animatedPath.addAll(widget.pathPoints);
    }
    _animatedPath.add(widget.endPoint);

    _segmentLengths = [];
    _totalLength = 0;

    for (int i = 0; i < _animatedPath.length - 1; i++) {
      final length = (_animatedPath[i + 1] - _animatedPath[i]).distance;
      _segmentLengths.add(length);
      _totalLength += length;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: _ConnectionLinePainter(
            path: _animatedPath,
            segmentLengths: _segmentLengths,
            totalLength: _totalLength,
            progress: _animation.value,
            color: widget.color,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _ConnectionLinePainter extends CustomPainter {
  final List<Offset> path;
  final List<double> segmentLengths;
  final double totalLength;
  final double progress;
  final Color color;

  _ConnectionLinePainter({
    required this.path,
    required this.segmentLengths,
    required this.totalLength,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (path.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // 绘制发光效果
    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 12.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // 计算当前进度下的路径长度
    final currentLength = totalLength * progress;

    // 绘制发光效果
    _drawPath(canvas, glowPaint, currentLength);

    // 绘制主线条
    _drawPath(canvas, paint, currentLength);

    // 绘制起点和终点的圆形标记
    if (progress > 0) {
      _drawEndpoints(canvas, currentLength);
    }
  }

  void _drawPath(Canvas canvas, Paint paint, double currentLength) {
    final path = Path();
    double accumulatedLength = 0;

    // 移动到起点
    path.moveTo(this.path[0].dx, this.path[0].dy);

    for (int i = 0; i < this.path.length - 1; i++) {
      final start = this.path[i];
      final end = this.path[i + 1];
      final segmentLength = segmentLengths[i];

      if (accumulatedLength + segmentLength <= currentLength) {
        // 完全绘制这个段
        path.lineTo(end.dx, end.dy);
      } else if (accumulatedLength < currentLength) {
        // 部分绘制这个段
        final remainingLength = currentLength - accumulatedLength;
        final ratio = remainingLength / segmentLength;
        final partialEnd = Offset(
          start.dx + (end.dx - start.dx) * ratio,
          start.dy + (end.dy - start.dy) * ratio,
        );
        path.lineTo(partialEnd.dx, partialEnd.dy);
      }

      accumulatedLength += segmentLength;
    }

    canvas.drawPath(path, paint);
  }

  void _drawEndpoints(Canvas canvas, double currentLength) {
    final endpointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // 绘制起点
    canvas.drawCircle(
      path[0],
      6.0,
      endpointPaint,
    );

    // 找到当前进度下的终点位置
    double accumulatedLength = 0;
    Offset currentEndPoint = path[0];

    for (int i = 0; i < path.length - 1; i++) {
      final start = path[i];
      final end = path[i + 1];
      final segmentLength = segmentLengths[i];

      if (accumulatedLength + segmentLength <= currentLength) {
        currentEndPoint = end;
      } else if (accumulatedLength < currentLength) {
        final remainingLength = currentLength - accumulatedLength;
        final ratio = remainingLength / segmentLength;
        currentEndPoint = Offset(
          start.dx + (end.dx - start.dx) * ratio,
          start.dy + (end.dy - start.dy) * ratio,
        );
        break;
      }

      accumulatedLength += segmentLength;
    }

    // 绘制当前终点
    canvas.drawCircle(
      currentEndPoint,
      6.0,
      endpointPaint,
    );
  }

  @override
  bool shouldRepaint(_ConnectionLinePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.path != path;
  }
}
