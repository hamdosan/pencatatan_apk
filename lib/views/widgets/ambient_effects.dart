import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AmbientEffects extends StatefulWidget {
  const AmbientEffects({super.key});

  @override
  State<AmbientEffects> createState() => _AmbientEffectsState();
}

class _AmbientEffectsState extends State<AmbientEffects>
    with SingleTickerProviderStateMixin {
  final _time = ValueNotifier<double>(0);
  late final Ticker _ticker;

  static final _flakes = _Flake.generate(70);
  static final _motes = _Mote.generate(16);

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      _time.value = elapsed.inMicroseconds / 1e6;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ticker hanya jalan bila animasi diizinkan, agar tidak memakan baterai
    // saat pengguna memilih "kurangi animasi".
    final enabled = !MediaQuery.of(context).disableAnimations;
    if (enabled && !_ticker.isActive) {
      _ticker.start();
    } else if (!enabled && _ticker.isActive) {
      _ticker.stop();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _time.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return const SizedBox.shrink();
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          child: CustomPaint(
            key: ValueKey(isDark),
            size: Size.infinite,
            painter: isDark
                ? _SnowPainter(_time, _flakes)
                : _LightPainter(_time, _motes),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- salju

class _Flake {
  const _Flake(this.x, this.y, this.radius, this.speed, this.sway,
      this.swaySpeed, this.phase, this.opacity);

  final double x; // posisi awal 0..1
  final double y; // posisi awal 0..1
  final double radius; // px
  final double speed; // px per detik
  final double sway; // px
  final double swaySpeed;
  final double phase;
  final double opacity;

  static List<_Flake> generate(int n) {
    final r = math.Random(7);
    return List.generate(n, (_) {
      // Kepingan besar jatuh lebih cepat dan lebih terang (efek kedalaman).
      final depth = r.nextDouble();
      return _Flake(
        r.nextDouble(),
        r.nextDouble(),
        0.8 + depth * 2.4,
        18 + depth * 42,
        6 + r.nextDouble() * 18,
        0.4 + r.nextDouble() * 0.8,
        r.nextDouble() * math.pi * 2,
        0.25 + depth * 0.55,
      );
    });
  }
}

class _SnowPainter extends CustomPainter {
  _SnowPainter(this.time, this.flakes) : super(repaint: time);

  final ValueNotifier<double> time;
  final List<_Flake> flakes;

  @override
  void paint(Canvas canvas, Size size) {
    final t = time.value;
    final paint = Paint();
    final h = size.height + 20;
    for (final f in flakes) {
      final y = (f.y * h + f.speed * t) % h - 10;
      final x = f.x * size.width + math.sin(t * f.swaySpeed + f.phase) * f.sway;
      paint.color = Colors.white.withValues(alpha: f.opacity);
      canvas.drawCircle(Offset(x, y), f.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_SnowPainter old) => old.flakes != flakes;
}

// --------------------------------------------------------------- cahaya

class _Mote {
  const _Mote(this.x, this.y, this.radius, this.speed, this.sway, this.phase,
      this.pulse);

  final double x;
  final double y;
  final double radius;
  final double speed;
  final double sway;
  final double phase;
  final double pulse;

  static List<_Mote> generate(int n) {
    final r = math.Random(11);
    return List.generate(
      n,
      (_) => _Mote(
        r.nextDouble(),
        r.nextDouble(),
        4 + r.nextDouble() * 10,
        6 + r.nextDouble() * 14,
        10 + r.nextDouble() * 20,
        r.nextDouble() * math.pi * 2,
        0.5 + r.nextDouble() * 1.0,
      ),
    );
  }
}

class _LightPainter extends CustomPainter {
  _LightPainter(this.time, this.motes) : super(repaint: time);

  final ValueNotifier<double> time;
  final List<_Mote> motes;

  static const _warm = Color(0xFFFFF4D6);

  @override
  void paint(Canvas canvas, Size size) {
    final t = time.value;
    _paintRays(canvas, size, t);
    _paintMotes(canvas, size, t);
  }

  void _paintRays(Canvas canvas, Size size, double t) {
    final source = Offset(-size.width * 0.15, -size.height * 0.08);
    final length = size.height * 0.9;
    const rays = [
      // sudut (rad), lebar (rad), kecepatan denyut, fase
      [0.55, 0.10, 0.35, 0.0],
      [0.78, 0.07, 0.50, 1.7],
      [0.98, 0.12, 0.28, 3.1],
      [1.20, 0.06, 0.45, 4.4],
    ];
    for (final r in rays) {
      final sway = math.sin(t * 0.15 + r[3]) * 0.04;
      final angle = r[0] + sway;
      final half = r[1] / 2;
      final alpha = 0.10 + 0.10 * (0.5 + 0.5 * math.sin(t * r[2] + r[3]));
      Offset at(double a) => source + Offset(math.cos(a), math.sin(a)) * length;
      final path = Path()
        ..moveTo(source.dx, source.dy)
        ..lineTo(at(angle - half).dx, at(angle - half).dy)
        ..lineTo(at(angle + half).dx, at(angle + half).dy)
        ..close();
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withValues(alpha: alpha * 2.2),
            _warm.withValues(alpha: alpha),
            _warm.withValues(alpha: 0),
          ],
          stops: const [0, 0.45, 1],
        ).createShader(Rect.fromCircle(center: source, radius: length));
      canvas.drawPath(path, paint);
    }
  }

  void _paintMotes(Canvas canvas, Size size, double t) {
    final h = size.height + 40;
    for (final m in motes) {
      final y = h - ((m.y * h + m.speed * t) % h) - 20;
      final x = m.x * size.width + math.sin(t * 0.3 + m.phase) * m.sway;
      final glow = 0.5 + 0.5 * math.sin(t * m.pulse + m.phase);
      final center = Offset(x, y);
      canvas.drawCircle(
        center,
        m.radius,
        Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.white.withValues(alpha: 0.35 + 0.35 * glow),
              _warm.withValues(alpha: 0),
            ],
          ).createShader(Rect.fromCircle(center: center, radius: m.radius)),
      );
    }
  }

  @override
  bool shouldRepaint(_LightPainter old) => old.motes != motes;
}
