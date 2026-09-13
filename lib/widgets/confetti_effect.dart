import 'dart:math';
import 'package:flutter/material.dart';

/// Lightweight custom celebratory confetti particles widget
class ConfettiEffect extends StatefulWidget {
  final Widget child;

  const ConfettiEffect({super.key, required this.child});

  @override
  State<ConfettiEffect> createState() => _ConfettiEffectState();
}

class _ConfettiEffectState extends State<ConfettiEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Generate confetti particles
    const colors = [
      Color(0xFFFFD700),
      Color(0xFF00E5FF),
      Color(0xFFFF5252),
      Color(0xFF69F0AE),
      Color(0xFFFF4081),
      Color(0xFFFFFFFF),
    ];

    for (int i = 0; i < 60; i++) {
      _particles.add(
        _Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble() * -1,
          size: _random.nextDouble() * 8 + 4,
          color: colors[_random.nextInt(colors.length)],
          speed: _random.nextDouble() * 0.4 + 0.2,
          rotation: _random.nextDouble() * 2 * pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 4,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        IgnorePointer(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                size: Size.infinite,
                painter: _ConfettiPainter(_particles, _controller.value),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Particle {
  double x;
  double y;
  double size;
  Color color;
  double speed;
  double rotation;
  double rotationSpeed;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speed,
    required this.rotation,
    required this.rotationSpeed,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ConfettiPainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var p in particles) {
      final currentY = ((p.y + progress * p.speed * 2) % 1.2) * size.height;
      final currentX = (p.x * size.width) + sin(progress * 4 + p.y * 10) * 20;

      paint.color = p.color;
      canvas.save();
      canvas.translate(currentX, currentY);
      canvas.rotate(p.rotation + progress * p.rotationSpeed);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: p.size,
          height: p.size * 0.6,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
