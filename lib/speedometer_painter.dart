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

    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: [speedMeterColor, speedMeterBoundaryColor],
        stops: const [0.95, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, bgPaint);

    final borderPaint = Paint()
      ..color = speedMeterBoundaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.04;

    canvas.drawCircle(center, radius, borderPaint);

    _drawScale(canvas, center, radius);

    _drawNeedle(canvas, center, radius);

    _drawCenter(canvas, center, radius);
  }

  void _drawScale(Canvas canvas, Offset center, double radius) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(startAngle);

    final step = sweepAngle / (scaleLabels.length - 1);

    final textStyle = GoogleFonts.oranienbaum(
      fontSize: sizeText,
      color: Colors.red,
      fontWeight: FontWeight.bold,
    );

    final tickPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = radius * 0.02;

    for (int i = 0; i < scaleLabels.length; i++) {
      // tick
      canvas.drawLine(
        Offset(0, -radius * 0.90),
        Offset(0, -radius * 0.75),
        tickPaint,
      );

      final tp = TextPainter(
        text: TextSpan(text: scaleLabels[i], style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(
        canvas,
        Offset(-tp.width / 2, -radius * 0.68),
      );

      canvas.rotate(step);
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
      ..color = speedMeterNeedleColor.withOpacity(0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    final corePaint = Paint()
      ..color = speedMeterNeedleColor;

    canvas.drawPath(needle, glowPaint);
    canvas.drawPath(needle, corePaint);

    canvas.restore();
  }

  void _drawCenter(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(center, radius * 0.1, Paint()..color = Colors.grey);

    final textPainter = TextPainter(
      text: TextSpan(
        text: centerText,
        style: GoogleFonts.orbitron(
          fontSize: radius * 0.25,
          color: Colors.white,
          fontWeight: FontWeight.bold,
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

    final descPainter = TextPainter(
      text: TextSpan(
        text: centerTextDescription,
        style: GoogleFonts.orbitron(
          fontSize: radius * 0.14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    descPainter.paint(
      canvas,
      Offset(
        center.dx - descPainter.width / 2,
        center.dy - descPainter.height / 2 + radius * 0.35,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant SpeedometerPainter oldDelegate) {
    return oldDelegate.value != value;
  }
}