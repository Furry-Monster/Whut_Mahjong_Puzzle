import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CuteShaderWidget extends StatefulWidget {
  final Widget child;
  final double intensity;

  const CuteShaderWidget({
    super.key,
    required this.child,
    this.intensity = 1.0,
  });

  @override
  State<CuteShaderWidget> createState() => _CuteShaderWidgetState();
}

class _CuteShaderWidgetState extends State<CuteShaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  ui.FragmentShader? _shader;
  double _time = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _loadShader();
  }

  Future<void> _loadShader() async {
    final fragmentProgram =
        await FragmentProgram.fromAsset('assets/shaders/cute_effect.frag');
    _shader = fragmentProgram.fragmentShader();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _shader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_shader == null) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        _time += 0.016; // Approximately 60fps
        _shader!
          ..setFloat(0, MediaQuery.of(context).size.width)
          ..setFloat(1, MediaQuery.of(context).size.height)
          ..setFloat(2, _time);

        return CustomPaint(
          painter: _CuteShaderPainter(
            shader: _shader!,
            intensity: widget.intensity,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _CuteShaderPainter extends CustomPainter {
  final ui.FragmentShader shader;
  final double intensity;

  _CuteShaderPainter({
    required this.shader,
    required this.intensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(_CuteShaderPainter oldDelegate) => true;
}
