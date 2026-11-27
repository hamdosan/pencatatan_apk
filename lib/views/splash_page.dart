import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/expense_controller.dart';
import '../l10n/l10n.dart';
import 'main_shell.dart';

// Warna sama dengan splash native (launch_background.xml) agar transisi mulus.
const _bgTop = Color(0xFF0254A6);
const _bgBottom = Color(0xFF031D61);

const _logoSize = 128.0;

// Splash saat aplikasi dibuka: logo muncul dengan animasi, lalu indikator
// loading sampai data selesai dimuat (minimal [_minDuration]).
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  static const _minDuration = Duration(milliseconds: 1800);
  static const _maxWait = Duration(seconds: 6);

  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..forward();

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

  late final Animation<double> _logoScale = Tween(begin: 0.45, end: 1.0)
      .animate(CurvedAnimation(parent: _intro, curve: Curves.elasticOut));
  late final Animation<double> _textFade = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0.45, 1, curve: Curves.easeOut),
  );

  bool _left = false;

  @override
  void initState() {
    super.initState();
    _waitThenOpen();
  }

  Future<void> _waitThenOpen() async {
    final controller = context.read<ExpenseController>();
    final loaded = Completer<void>();
    void check() {
      if (!controller.isLoading && !loaded.isCompleted) loaded.complete();
    }

    controller.addListener(check);
    check();
    await Future.wait([
      Future<void>.delayed(_minDuration),
      loaded.future.timeout(_maxWait, onTimeout: () {}),
    ]);
    controller.removeListener(check);
    _open();
  }

  void _open() {
    if (!mounted || _left) return;
    _left = true;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const MainShell(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _intro.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgTop, _bgBottom],
          ),
        ),
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: _logoSize * 2,
                height: _logoSize * 2,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Gelombang cahaya yang terus memancar dari logo.
                    for (var i = 0; i < 2; i++)
                      AnimatedBuilder(
                        animation: _pulse,
                        builder: (_, __) {
                          final t = (_pulse.value + i / 2) % 1;
                          return Opacity(
                            opacity: (1 - t) * 0.35 * _textFade.value,
                            child: Container(
                              width: _logoSize * (1.2 + t * 0.8),
                              height: _logoSize * (1.2 + t * 0.8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ScaleTransition(
                      scale: _logoScale,
                      child: const _Logo(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              FadeTransition(
                opacity: _textFade,
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.6),
                    end: Offset.zero,
                  ).animate(_textFade),
                  child: Text(
                    tr('appTitle'),
                    style: text.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              FadeTransition(
                opacity: _textFade,
                child: _LoadingDots(animation: _pulse),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Logo aplikasi: ambil kotak ikon dari ic_launcher_foreground (432 px),
// buang bayangan lembut di tepinya.
class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) => Container(
        width: _logoSize,
        height: _logoSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Color(0x66000000),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: OverflowBox(
            maxWidth: _logoSize * 432 / 280,
            maxHeight: _logoSize * 432 / 280,
            child: Image.asset(
              'assets/logo.png',
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
      );
}

// Tiga titik yang naik-turun bergantian.
class _LoadingDots extends StatelessWidget {
  const _LoadingDots({required this.animation});
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: animation,
        builder: (_, __) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 3; i++)
              Builder(builder: (_) {
                final t = (animation.value * 2 - i * 0.2) % 1;
                final lift = math.max(0.0, math.sin(t * math.pi * 2));
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  transform: Matrix4.translationValues(0, -8 * lift, 0),
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.lerp(
                      Colors.white54,
                      const Color(0xFFFF9800),
                      lift,
                    ),
                  ),
                );
              }),
          ],
        ),
      );
}
