import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpeedometerPainter extends CustomPainter {
  final double angleSpeedoMeterNeedle;
  final double angleFuelMeterNeedle;
  final int distanceTravelledKm;
  final Color speedoMeterBoundaryColor;
  final Color speedoMeterColor;
  final Color speedoMeterNeedleColor;
  final Color fuelMeterBoundaryColor;
  final Color fuelMeterColor;
  final Color fuelMeterNeedleColor;
  final Color distanceScreenBoundaryColor;
  final Color distanceScreenColor;
  final Color distanceScreenTextColor;
  final double sizeText;

  const SpeedometerPainter({
    required this.angleSpeedoMeterNeedle,
    required this.angleFuelMeterNeedle,
    required this.distanceTravelledKm,
    required this.speedoMeterColor,
    required this.speedoMeterBoundaryColor,
    required this.speedoMeterNeedleColor,
    required this.distanceScreenBoundaryColor,
    required this.distanceScreenColor,
    required this.distanceScreenTextColor,
    required this.fuelMeterBoundaryColor,
    required this.fuelMeterColor,
    required this.fuelMeterNeedleColor,
    required this.sizeText,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Size(:height, :width) = size;
    final centerHeight = height * 0.5;
    final centerWidth = width * 0.5;
    final center = Offset(centerWidth, centerHeight);

    // Draw circular body
    final circularBodyRadius = min(width, height) * 0.5;
    final circularBodyPaint = Paint()
      ..shader =
      RadialGradient(
        colors: [speedoMeterColor, speedoMeterBoundaryColor],
        stops: [0.95, 1.0],
      ).createShader(
        Rect.fromCircle(center: center, radius: circularBodyRadius),
      );
    canvas.drawCircle(center, circularBodyRadius, circularBodyPaint);

    // Draw circular body boundary
    final circularBodyBoundaryPaint = Paint()
      ..color = speedoMeterBoundaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = circularBodyRadius * 0.04;
    canvas.drawCircle(center, circularBodyRadius, circularBodyBoundaryPaint);

    // Draw km/h tickers
    final kmhShorterTickerP1 = Offset(
      0,
      -(circularBodyRadius - circularBodyRadius * 0.05),
    );
    final kmhShorterTickerP2 = Offset(
      0,
      -(circularBodyRadius - circularBodyRadius * 0.09),
    );
    final shorterTickerWidth = circularBodyRadius * 0.01;
    final shorterTickerPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = shorterTickerWidth;
    final longerTickerWidth = circularBodyRadius * 0.02;
    final longerTikcerPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = longerTickerWidth;
    final kmhLongerTickerP1 = Offset(
      0,
      -(circularBodyRadius - circularBodyRadius * 0.05),
    );
    final kmhLongerTickerP2 = Offset(
      0,
      -(circularBodyRadius - circularBodyRadius * 0.125),
    );

    final startAngleTickers = 2 * pi * 0.7;
    final sweepAngleKmhTikcers = 2 * pi * 0.006;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(startAngleTickers);

    for (int i = 0; i <= 100; i++) {
      if (i % 10 == 0) {
        canvas.drawLine(
          kmhLongerTickerP1,
          kmhLongerTickerP2,
          longerTikcerPaint,
        );
      } else {
        canvas.drawLine(
          kmhShorterTickerP1,
          kmhShorterTickerP2,
          shorterTickerPaint,
        );
      }
      canvas.rotate(sweepAngleKmhTikcers);
    }
    canvas.restore();

    final kmhNumberFontStyle = GoogleFonts.oranienbaum(
      fontSize: sizeText,
      color: Colors.red,
      fontWeight: FontWeight.bold,
    );
    final zero = '0';
    final twenty = '20';
    final forty = '40';
    final sixty = '60';
    final eighty = '80';
    final hundred = '100';
    final hundredTwenty = '120';
    final hundredForty = '140';
    final hundredSixty = '160';
    final hundredEighty = '180';
    final twoHundred = '200';

    final zeroKmhTextSpan = TextSpan(text: zero, style: kmhNumberFontStyle);
    final zeroKmhTextPainter = TextPainter(
      text: zeroKmhTextSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    final twentyKmhTextSpan = TextSpan(text: twenty, style: kmhNumberFontStyle);
    final twentyKmhTextPainter = TextPainter(
      text: twentyKmhTextSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    final fortyKmhTextSpan = TextSpan(text: forty, style: kmhNumberFontStyle);
    final fortyKmhTextPainter = TextPainter(
      text: fortyKmhTextSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    final sixtyKmhTextSpan = TextSpan(text: sixty, style: kmhNumberFontStyle);
    final sixtyKmhTextPainter = TextPainter(
      text: sixtyKmhTextSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    final eigthyKmhTextSpan = TextSpan(text: eighty, style: kmhNumberFontStyle);
    final eightyKmhTextPainter = TextPainter(
      text: eigthyKmhTextSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    final hundredKmhTextSpan = TextSpan(
      text: hundred,
      style: kmhNumberFontStyle,
    );
    final hundredKmhTextPainter = TextPainter(
      text: hundredKmhTextSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    final hundredTwentyKmhTextSpan = TextSpan(
      text: hundredTwenty,
      style: kmhNumberFontStyle,
    );
    final hundredTwentyKmhTextPainter = TextPainter(
      text: hundredTwentyKmhTextSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    final hundredFortyKmhTextSpan = TextSpan(
      text: hundredForty,
      style: kmhNumberFontStyle,
    );
    final hundredFortyKmhTextPainter = TextPainter(
      text: hundredFortyKmhTextSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    final hundredSixtyKmhTextSpan = TextSpan(
      text: hundredSixty,
      style: kmhNumberFontStyle,
    );
    final hundredSixtyKmhTextPainter = TextPainter(
      text: hundredSixtyKmhTextSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    final hundredEightyKmhTextSpan = TextSpan(
      text: hundredEighty,
      style: kmhNumberFontStyle,
    );
    final hundredEightyKmhTextPainter = TextPainter(
      text: hundredEightyKmhTextSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    final twoHundredKmhTextSpan = TextSpan(
      text: twoHundred,
      style: kmhNumberFontStyle,
    );
    final twoHundredKmhTextPainter = TextPainter(
      text: twoHundredKmhTextSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.save();
    canvas.translate(center.dx, center.dy);
    zeroKmhTextPainter.paint(
      canvas,
      Offset(-(circularBodyRadius * 0.8), circularBodyRadius * 0.2),
    );
    twentyKmhTextPainter.paint(
      canvas,
      Offset(-(circularBodyRadius * 0.825), -(circularBodyRadius * 0.125)),
    );
    fortyKmhTextPainter.paint(
      canvas,
      Offset(-(circularBodyRadius * 0.75), -(circularBodyRadius * 0.4)),
    );
    sixtyKmhTextPainter.paint(
      canvas,
      Offset(-(circularBodyRadius * 0.6), -(circularBodyRadius * 0.625)),
    );
    eightyKmhTextPainter.paint(
      canvas,
      Offset(-(circularBodyRadius * 0.35), -(circularBodyRadius * 0.785)),
    );
    hundredKmhTextPainter.paint(
      canvas,
      Offset(-(circularBodyRadius * 0.1), -(circularBodyRadius * 0.85)),
    );
    hundredTwentyKmhTextPainter.paint(
      canvas,
      Offset((circularBodyRadius * 0.2), -(circularBodyRadius * 0.785)),
    );
    hundredFortyKmhTextPainter.paint(
      canvas,
      Offset((circularBodyRadius * 0.45), -(circularBodyRadius * 0.625)),
    );
    hundredSixtyKmhTextPainter.paint(
      canvas,
      Offset((circularBodyRadius * 0.60), -(circularBodyRadius * 0.4)),
    );
    hundredEightyKmhTextPainter.paint(
      canvas,
      Offset((circularBodyRadius * 0.6775), -(circularBodyRadius * 0.125)),
    );
    twoHundredKmhTextPainter.paint(
      canvas,
      Offset((circularBodyRadius * 0.65), circularBodyRadius * 0.2),
    );
    canvas.restore();

    // Draw distance travelled screen, km/h text and fuel meter
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.restore();

    // Draw needle
    canvas.save();
    canvas.translate(centerWidth, centerHeight);
    canvas.rotate(startAngleTickers);
    canvas.rotate(angleSpeedoMeterNeedle);
    final needlePath = Path();
    needlePath.moveTo(-circularBodyRadius * 0.02, 0);
    needlePath.lineTo(-circularBodyRadius * 0.005, -circularBodyRadius * 0.9);
    needlePath.conicTo(
      0,
      -circularBodyRadius * 0.95,
      circularBodyRadius * 0.005,
      -circularBodyRadius * 0.9,
      0.5,
    );
    needlePath.lineTo(circularBodyRadius * 0.02, 0);
    needlePath.close();
    final needlePaint = Paint()..color = speedoMeterNeedleColor;
    canvas.drawPath(needlePath, needlePaint);
    canvas.restore();

    // Draw needle circle
    final needleCircle1Radius = circularBodyRadius * 0.1;
    final needleCircle1Paint = Paint()
      ..shader = LinearGradient(colors: [Colors.grey, Colors.grey.shade900])
          .createShader(
        Rect.fromCircle(center: center, radius: needleCircle1Radius),
      );
    canvas.drawCircle(center, needleCircle1Radius, needleCircle1Paint);

    final needleCircle2Radius = circularBodyRadius * 0.08;
    final needleCircle2Paint = Paint()
      ..shader = LinearGradient(colors: [Colors.grey.shade900, Colors.grey])
          .createShader(
        Rect.fromCircle(center: center, radius: needleCircle2Radius),
      );
    canvas.drawCircle(center, needleCircle2Radius, needleCircle2Paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    oldDelegate = oldDelegate as SpeedometerPainter;
    return oldDelegate.angleSpeedoMeterNeedle != angleFuelMeterNeedle ||
        oldDelegate.angleSpeedoMeterNeedle != angleSpeedoMeterNeedle ||
        oldDelegate.distanceTravelledKm != distanceTravelledKm;
  }
}

class FuelMeterPainter extends CustomPainter {
  final double angleFuelMeterNeedle;
  final Color fuelMeterColor;
  final Color fuelMeterBoundaryColor;
  final Color fuelMeterNeedleColor;

  const FuelMeterPainter({required this.angleFuelMeterNeedle, required this.fuelMeterColor, required this.fuelMeterBoundaryColor, required this.fuelMeterNeedleColor});

  @override
  void paint(Canvas canvas, Size size) {
    final Size(:height, :width) = size;
    final centerWidth = width * 0.5;
    final centerHeight = height * 0.5;

    // Draw fuel meter circle
    final fuelMeterCircleOffset = Offset(centerWidth, centerHeight);
    final fuelMeterCircleRadius = min(width, height) * 0.5;
    final fuelMeterCirclePaint = Paint()
      ..color = fuelMeterColor
      ..isAntiAlias = true;
    canvas.drawCircle(
      fuelMeterCircleOffset,
      fuelMeterCircleRadius,
      fuelMeterCirclePaint,
    );

    // Draw fuel meter circle boundary
    final fuelMeterCircleBondaryPaint = Paint()
      ..color = fuelMeterBoundaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = fuelMeterCircleRadius * 0.05;
    canvas.drawCircle(
      fuelMeterCircleOffset,
      fuelMeterCircleRadius,
      fuelMeterCircleBondaryPaint,
    );

    // Draw fuel meter tickers
    final shorterTickerWidth = fuelMeterCircleRadius * 0.04;
    final shorterTickerPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = shorterTickerWidth;
    final longerTickerWidth = fuelMeterCircleRadius * 0.06;
    final longerTikcerPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = longerTickerWidth;
    final fuelShorterTickerP1 = Offset(0, -fuelMeterCircleRadius * 0.9);
    final fuelShorterTickerP2 = Offset(0, -fuelMeterCircleRadius * 0.78);
    final fuelLongerTickerP1 = Offset(0, -fuelMeterCircleRadius * 0.9);
    final fuelLongerTickerP2 = Offset(0, -fuelMeterCircleRadius * 0.75);

    final fuelTickersStartAngle = 2 * pi * 0.8;
    final fueltickersSweepAngle = 2 * pi * 0.04;

    canvas.save();
    canvas.translate(centerWidth, centerHeight);
    canvas.rotate(fuelTickersStartAngle);
    for (int i = 0; i <= 10; i++) {
      if (i % 5 == 0) {
        canvas.drawLine(
          fuelLongerTickerP1,
          fuelLongerTickerP2,
          longerTikcerPaint,
        );
      } else {
        canvas.drawLine(
          fuelShorterTickerP1,
          fuelShorterTickerP2,
          shorterTickerPaint,
        );
      }
      canvas.rotate(fueltickersSweepAngle);
    }
    canvas.restore();

    // Draw texts
    canvas.save();
    canvas.translate(centerWidth, centerHeight);
    final textColor = Colors.white;
    final textFontSize = fuelMeterCircleRadius * 0.21;
    final textStyle = TextStyle(
      color: textColor,
      fontSize: textFontSize,
      fontWeight: FontWeight.bold,
    );

    canvas.restore();

    final needleCircle2Radius = fuelMeterCircleRadius * 0.08;
    final needleCircle2Paint = Paint()
      ..shader = LinearGradient(colors: [Colors.grey.shade900, Colors.grey])
          .createShader(
        Rect.fromCircle(
          center: Offset(centerWidth, centerHeight),
          radius: needleCircle2Radius,
        ),
      );
    canvas.drawCircle(
      Offset(centerWidth, centerHeight),
      needleCircle2Radius,
      needleCircle2Paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
