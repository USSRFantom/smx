import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpeedometerPainter extends CustomPainter {
  final double value;
  final double minValue;
  final double maxValue;
  final Color speedMeterBoundaryColor;
  final Color speedMeterColor;
  final Color speedMeterNeedleColor;
  final double sizeText;
  final String centerText;
  final String centerTextDescription;

  final List<String> scaleLabels;

  const SpeedometerPainter({
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.speedMeterColor,
    required this.speedMeterBoundaryColor,
    required this.speedMeterNeedleColor,
    required this.sizeText,
    required this.centerText,
    required this.centerTextDescription,
    required this.scaleLabels,
  });

  static const startAngle = 2 * pi * 0.7;
  static const sweepAngle = 2 * pi * 0.6;

  double _toAngle(double v) {
    final t = ((v - minValue) / (maxValue - minValue)).clamp(0.0, 1.0);

    return startAngle + sweepAngle * t;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) * 0.5;

    ///Внешняя тень
    final glowPaint = Paint()
      ..color = Colors.red.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.18
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 35);

    canvas.drawCircle(center, radius * 1.02, glowPaint);
    ///Внутренний цвет
    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: [speedMeterColor, speedMeterBoundaryColor],
        stops: const [0.95, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, bgPaint);
    ///Внутренняяя тень
    final innerShadow = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.transparent,
          Colors.black.withOpacity(0.7),
        ],
        stops: const [0.65, 1.0],
      ).createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    canvas.drawCircle(center, radius, innerShadow);

    _drawProgressArc(canvas, center, radius);

    _drawScale(canvas, center, radius);

    _drawNeedle(canvas, center, radius);

    _drawCenter(canvas, center, radius);
  }

  ///прорисовка шкалы
  void _drawScale(Canvas canvas, Offset center, double radius) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(startAngle);

    final totalSteps = scaleLabels.length - 1;

    final baseOuter = radius * 0.96;

    final majorOuter = baseOuter;
    final majorInner = radius * 0.88; // было 0.80 → короче

    final minorOuter = baseOuter;
    final minorInner = radius * 0.92; // было 0.86 → тоже короче

    final stepAngle = sweepAngle / totalSteps;
    final minorStepAngle = stepAngle / 5; // 👈 4 маленьких деления между основными

    final majorPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = radius * 0.025;

    final minorPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = radius * 0.012;

    final textStyle = GoogleFonts.roboto(
      fontSize: sizeText * 1.1,
      color: Colors.white.withOpacity(0.95),
      fontWeight: FontWeight.w500,
      letterSpacing: 1.2,
    );

    double angle = 0;

    for (int i = 0; i <= totalSteps; i++) {
      canvas.drawLine(
        Offset(0, -majorOuter),
        Offset(0, -majorInner),
        majorPaint,
      );

      ///Цифры
      final labelRadius = radius * 0.85; //
      final tp = TextPainter(
        text: TextSpan(text: scaleLabels[i], style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(
        canvas,
        Offset(
          -tp.width / 2,
          -labelRadius,
        ),
      );

      if (i < totalSteps) {
        for (int j = 1; j < 5; j++) {

          canvas.save();
          canvas.rotate(minorStepAngle * j);

          canvas.drawLine(
            Offset(0, -minorOuter),
            Offset(0, -minorInner),
            minorPaint,
          );

          canvas.restore();
        }
      }

      canvas.rotate(stepAngle);
      angle += stepAngle;
    }

    canvas.restore();
  }

  void _drawNeedle(Canvas canvas, Offset center, double radius) {
    final angle = _toAngle(value);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    final needle = Path()
      ..moveTo(-radius * 0.02, 0)
      ..lineTo(0, -radius * 0.9)
      ..lineTo(radius * 0.02, 0)
      ..close();

    final glowPaint = Paint()
      ..color = Colors.red.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.06
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    final corePaint = Paint()
      ..color = speedMeterNeedleColor;


    canvas.drawPath(needle, glowPaint);
    canvas.drawPath(needle, corePaint);

    canvas.restore();
  }

  ///Дуга
  void _drawProgressArc(Canvas canvas, Offset center, double radius) {
    final t = ((value - minValue) / (maxValue - minValue))
        .clamp(0.0, 1.0);

    final sweep = sweepAngle * t;

    final rect = Rect.fromCircle(
      center: center,
      radius: radius * 0.92,
    );

    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.red, Colors.redAccent],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.05
      ..strokeCap = StrokeCap.round;

    final arcStart = -pi / 2 + startAngle;

    canvas.drawArc(
      rect,
      arcStart,
      sweep,
      false,
      paint,
    );
  }

  void _drawCenter(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(center, radius * 0.1, Paint()..color = Colors.grey);

    final textPainter = TextPainter(
      text: TextSpan(
        text: centerText,
        style: GoogleFonts.roboto(
          fontSize: radius * 0.28,
          color: Colors.white.withOpacity(0.95),
          fontWeight: FontWeight.w500,
          letterSpacing: 2.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2 - radius * 0.35,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant SpeedometerPainter oldDelegate) {
    return oldDelegate.value != value;
  }
}