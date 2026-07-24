import 'package:flutter/material.dart';
import 'dart:math';

import 'vega_mood.dart';
import 'vega_identity.dart';
import '../audio/vega_audio.dart';

class VegaStar extends StatefulWidget {
  final VegaMood mood;

  String get name => VegaIdentity.name;

  const VegaStar({
    super.key,
    this.mood = VegaMood.calm,
  });

  @override
  State<VegaStar> createState() => _VegaStarState();
}

late AnimationController _appearController;
late AnimationController _breatheController;

late Animation<double> _appearAnimation;
late Animation<double> _breatheAnimation;

class _VegaStarState extends State<VegaStar>
    with TickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _appearAnimation;
  late Animation<double> _breatheAnimation;
  late AnimationController _moodController;

@override
void didUpdateWidget(covariant VegaStar oldWidget) {
  super.didUpdateWidget(oldWidget);

  if (oldWidget.mood != widget.mood) {
    _moodController.forward(from: 0);

    VegaAudio.playChime();
  }
}

 @override
void initState() {
  super.initState();

  // انیمیشن ظاهر شدن اولیه
  _appearController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  _appearAnimation = CurvedAnimation(
    parent: _appearController,
    curve: Curves.easeOutCubic,
  );

  // انیمیشن نفس کشیدن
  _breatheController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  );
_moodController = AnimationController(
  vsync: this,
  duration: const Duration(milliseconds: 1200),
)..forward();

  _breatheAnimation = Tween<double>(
  begin: 0.965,
  end: 1.1,
).animate(
  CurvedAnimation(
    parent: _breatheController,
    curve: Curves.easeInOut,
  ),
);

  // اول فقط بزرگ شود
  _appearController.forward().then((_) {
    // بعد از رسیدن به اندازه کامل، نفس کشیدن شروع شود
    _breatheController.repeat(reverse: true);
  });
}

 @override
void dispose() {
  _appearController.dispose();
  _breatheController.dispose();
  super.dispose();
  _moodController.dispose();
}

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
  _appearController,
  _breatheController,
]),
      builder: (context, child) {
        return CustomPaint(
          size: const Size(300, 300),
         painter: VegaStarPainter(
  mood: widget.mood,
  appear: _appearAnimation.value,
  breathe: _breatheAnimation.value,
  animation: _breatheController.value,
  moodTransition: _moodController.value,


),
        );
      },
    );
  }
}

class VegaPalette {
  final Color main;
  final Color glow;
  final Color highlight;
  final double breathMin;
  final double breathMax;

  VegaPalette({
    required this.main,
    required this.glow,
    required this.highlight,
    required this.breathMin,
    required this.breathMax,
  });
}

class VegaStarPainter extends CustomPainter {
  final VegaMood mood;
  final double appear;
  final double breathe;
  final double animation;
  final double moodTransition;

  VegaStarPainter({
    required this.mood,
    required this.appear,
    required this.breathe,
    required this.animation,
    required this.moodTransition,
  });

  VegaPalette get palette {
  switch (mood) {

    case VegaMood.calm:
      return VegaPalette(
        main: const Color(0xFFAEDFFF),
        glow: const Color(0xFFCDBBFF),
        highlight: Colors.white,
        breathMin: 0.97,
        breathMax: 1.03,
      );

    case VegaMood.happy:
      return VegaPalette(
        main: const Color(0xFFFFC6DD),
        glow: const Color(0xFFFFE4A8),
        highlight: Colors.white,
        breathMin: 0.98,
        breathMax: 1.06,
      );

    case VegaMood.thinking:
      return VegaPalette(
        main: const Color(0xFFCBB8FF),
        glow: const Color(0xFFA8DFFF),
        highlight: Colors.white,
        breathMin: 0.99,
        breathMax: 1.02,
      );

    case VegaMood.excited:
      return VegaPalette(
        main: const Color(0xFFFFDD70),
        glow: const Color(0xFFC8F7C5),
        highlight: Colors.white,
        breathMin: 0.96,
        breathMax: 1.10,
      );

    case VegaMood.comforting:
      return VegaPalette(
        main: const Color(0xFF91B8D8),
        glow: const Color(0xFFB7A7D9),
        highlight: const Color(0xFFE8F0FF),
        breathMin: 0.99,
        breathMax: 1.01,
      );

    case VegaMood.thinking:
      return VegaPalette(
        main: const Color(0xFF9BE7FF),
        glow: const Color(0xFFC7F1FF),
        highlight: Colors.white,
        breathMin: 0.98,
        breathMax: 1.04,
      );

    case VegaMood.comforting:
      return VegaPalette(
        main: const Color(0xFFFFD9E8),
        glow: const Color(0xFFFFF0F5),
        highlight: Colors.white,
        breathMin: 0.97,
        breathMax: 1.03,
      );

    case VegaMood.listening:
      return VegaPalette(
        main: const Color(0xFFB8E7FF),
        glow: const Color(0xFFE8F7FF),
        highlight: Colors.white,
        breathMin: 0.98,
        breathMax: 1.04,
      );
  }
}
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );
    

    final p = palette;

    // اندازه هسته: بزرگ + ظاهر شدن اولیه + نفس کشیدن
    final coreRadius = size.width * 0.38 * appear * breathe;

    // هاله بیرونی (کوچک‌تر از قبل)
    final outerGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          p.main.withOpacity(0.18),
          p.glow.withOpacity(0.10),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius: coreRadius * 1.7,
        ),
      );

    canvas.drawCircle(
      center,
      coreRadius * 1.7,
      outerGlow,
    );

    // هاله میانی
    final middleGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          p.main.withOpacity(0.35),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius: coreRadius * 1.15,
        ),
      );

    canvas.drawCircle(
      center,
      coreRadius * 1.15,
      middleGlow,
    );

    // 🌌 پرتوهای متحرک نرم
canvas.save();

// چرخش خیلی آرام پرتوها
canvas.translate(center.dx, center.dy);
canvas.rotate(animation * 0.3);
canvas.translate(-center.dx, -center.dy);

final rayOpacity = mood == VegaMood.excited ? 0.35 : 0.18;

final rayPaint = Paint()
  ..shader = LinearGradient(
    colors: [
      Colors.transparent,
      p.main.withOpacity(rayOpacity),
      Colors.transparent,
    ],
  ).createShader(
    Rect.fromCenter(
      center: center,
      width: coreRadius * 3.2,
      height: coreRadius * 0.18,
    ),
  )
  ..maskFilter = const MaskFilter.blur(
    BlurStyle.normal,
    20,
  );

// پرتو افقی
canvas.drawOval(
  Rect.fromCenter(
    center: center,
    width: coreRadius * 3.2,
    height: coreRadius * 0.18,
  ),
  rayPaint,
);

// پرتو عمودی
canvas.drawOval(
  Rect.fromCenter(
    center: center,
    width: coreRadius * 0.18,
    height: coreRadius * 3.2,
  ),
  rayPaint,
);

canvas.restore();

    // هسته اصلی Vega
   final blendedMain = Color.lerp(
  Colors.white,
  p.main,
  moodTransition,
)!;

final blendedGlow = Color.lerp(
  Colors.white,
  p.glow,
  moodTransition,
)!;

final corePaint = Paint()
  ..shader = RadialGradient(
    colors: [
      p.highlight.withOpacity(0.98),
      blendedMain.withOpacity(0.95),
      blendedGlow.withOpacity(0.45),
      Colors.transparent,
    ],
    stops: [
      0.0,
      0.20 + (0.15 * moodTransition),
      0.45 + (0.30 * moodTransition),
      1.0,
    ],
  ).createShader(
    Rect.fromCircle(
      center: center,
      radius: coreRadius,
    ),
  );

canvas.drawCircle(center, coreRadius, corePaint);

// ✨ چشمک محسوس‌تر Vega
final blinkStrength = sin(animation * pi * 2).abs();

final blinkPaint = Paint()
  ..color = Colors.white.withOpacity(
    0.25 + (blinkStrength * 0.45),
  )
  ..maskFilter = const MaskFilter.blur(
    BlurStyle.normal,
    18,
  );

canvas.drawCircle(
  center,
  coreRadius * (0.14 + blinkStrength * 0.08),
  blinkPaint,
);

    // نقطه درخشان مرکزی
    final centerLight = Paint()
      ..color = Colors.white.withOpacity(0.85)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        8,
      );

    canvas.drawCircle(
      center,
      coreRadius * 0.18,
      centerLight,
    );
  }

  @override
  bool shouldRepaint(covariant VegaStarPainter oldDelegate) {
    return oldDelegate.mood != mood ||
        oldDelegate.appear != appear ||
        oldDelegate.breathe != breathe;
  }
}