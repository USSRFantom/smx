import 'package:flutter/material.dart';
import 'package:smx/speedometer_painter.dart';

class Speedometer extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double height;
  final double width;
  final double speedKmh;
  final int distanceTravelledKm;

  final Duration duration;

  final Color speedoMeterBoundaryColor;
  final Color speedoMeterColor;
  final Color speedoMeterNeedleColor;

  final double sizeText;
  final String centerText;
  final String centerTextDescription;

  final List<String> speedScale;

  const Speedometer({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.sizeText,
    required this.speedKmh,
    required this.distanceTravelledKm,
    required this.centerText,
    required this.centerTextDescription,
    required this.speedScale,
    this.height = 400,
    this.width = 400,
    this.duration = const Duration(milliseconds: 300),
    this.speedoMeterColor = Colors.black,
    this.speedoMeterBoundaryColor = Colors.black,
    this.speedoMeterNeedleColor = Colors.red,
  });

  @override
  State<Speedometer> createState() => SpeedometerState();
}

class SpeedometerState extends State<Speedometer>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;
  late Animation<double> _animation;


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _animation = Tween<double>(
      begin: widget.minValue,
      end: widget.speedKmh,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }
  @override
  void didUpdateWidget(covariant Speedometer oldWidget) {
    super.didUpdateWidget(oldWidget);

    _animation = Tween<double>(
      begin: _animation.value,
      end: widget.speedKmh,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: SpeedometerPainter(
            minValue: widget.minValue,
            maxValue: widget.maxValue,
            value: _animation.value,
            sizeText: widget.sizeText,
            speedMeterColor: widget.speedoMeterColor,
            speedMeterBoundaryColor: widget.speedoMeterBoundaryColor,
            speedMeterNeedleColor: widget.speedoMeterNeedleColor,
            centerText: widget.centerText,
            centerTextDescription: widget.centerTextDescription,
            scaleLabels: widget.speedScale,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}