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
  final String? bottomIcon;

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
    this.bottomIcon,
  });

  @override
  State<Speedometer> createState() => SpeedometerState();
}

class SpeedometerState extends State<Speedometer>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;
  late Animation<double> _animation;

  bool _bootFinished = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _runBoot();
  }

  void _runBoot() {
    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: widget.minValue,
          end: widget.maxValue,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: widget.maxValue,
          end: widget.minValue,
        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 50,
      ),
    ]).animate(_controller);

    _controller.forward().whenComplete(() {
      if (!mounted) return;
      _bootFinished = true;
    });
  }

  @override
  void didUpdateWidget(covariant Speedometer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_bootFinished) return;

    _animation = Tween<double>(
      begin: _animation.value,
      end: widget.speedKmh.clamp(widget.minValue, widget.maxValue),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller
      ..duration = widget.duration
      ..reset()
      ..forward();
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.isAnimating && !_bootFinished) {
      return const SizedBox();
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
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
              ),

                Positioned(
                  bottom: widget.height * 0.32,
                  child: Row(
                    children: [
                      if (widget.bottomIcon != null)
                      Image.asset(
                        widget.bottomIcon!,
                        width: widget.width * 0.08,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      SizedBox(width: 10),
                      if(widget.centerTextDescription != "")
                        Text(widget.centerTextDescription, style: TextStyle(color: Colors.white, fontSize: 24),),


                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}