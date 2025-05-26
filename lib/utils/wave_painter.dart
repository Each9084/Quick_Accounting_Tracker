import 'dart:math';
import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  final Animation<double> animation;

  WavePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final waveLength = size.width; // 所有波统一波长，确保循环一致
    //流动速度
    final fullCycleOffset = animation.value * 2 * pi; // 控制整体循环

    final waveConfigs = [
      _WaveConfig(
        color: Colors.blueAccent.withOpacity(0.6),
        //振幅
        amplitude: 20,
        //整体上下偏移的位置（相对于底部）
        baseHeight: 65,
        //起始相位
        phaseShift: 0,
      ),
      _WaveConfig(
        color: Colors.purpleAccent.withOpacity(0.4),
        amplitude: 15,
        baseHeight: 55,
        phaseShift: pi / 2, // 相位偏移制造差异但周期相同
      ),
      _WaveConfig(
        color: Colors.orangeAccent.withOpacity(0.3),
        amplitude: 10,
        baseHeight: 50,
        phaseShift: pi, // 相反方向起始
      ),
    ];

    for (final config in waveConfigs) {
      final paint = Paint()..color = config.color;
      final path = Path();

      path.moveTo(0, size.height);
      for (double x = 0; x <= size.width; x++) {
        final normalizedX = x / waveLength * 2 * pi;
        final y = config.amplitude *
            sin(normalizedX + fullCycleOffset + config.phaseShift) +
            size.height - config.baseHeight;
        path.lineTo(x, y);
      }
      path.lineTo(size.width, size.height);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) => true;
}

class _WaveConfig {
  final Color color;
  final double amplitude;
  final double baseHeight;
  final double phaseShift;

  _WaveConfig({
    required this.color,
    required this.amplitude,
    required this.baseHeight,
    required this.phaseShift,
  });
}


