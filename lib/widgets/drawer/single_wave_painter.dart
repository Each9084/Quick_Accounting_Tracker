import 'dart:math';
import 'package:flutter/material.dart';

class SingleWavePainter extends CustomPainter {
  final Animation<double> animation;
  final double waveHeight;
  final double waveSpeed;
  final double baseHeight;
  final List<Color> colors;

  SingleWavePainter(
      this.animation, {
        //高度
        this.waveHeight = 30.0,
        //速度
        this.waveSpeed = 1.0,
        //初始高度
        this.baseHeight = 60.0,
        this.colors = const [Colors.blueAccent, Colors.purpleAccent],
      }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final waveLength = size.width / 1.5;
    final offset = animation.value * waveLength * waveSpeed;

    path.moveTo(0, size.height);
    for (double x = 0; x <= size.width; x++) {
      double y = waveHeight *
          sin((x + offset) / waveLength * 2 * pi) +
          size.height -
          baseHeight;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SingleWavePainter oldDelegate) => true;
}
