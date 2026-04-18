import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smx/speedometer.dart';

void main() {
  runApp(const DashboardApp());
}

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double _speed = 0;

  double _fuel = 80;

  int _distanceTravelled = 2100;

  void _onTap() {
    setState(() {
      _speed += 25;
      _fuel -= 5;
      _distanceTravelled++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// 🔥 ФОН
          Positioned.fill(
            child: Image.asset(
              'assets/bg.png',
              fit: BoxFit.cover,
            ),
          ),

          /// затемнение
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.1),
            ),
          ),

          /// ЦЕНТР
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                /// 🔴 СПИДОМЕТР
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Speedometer(
                        sizeText: 11,
                        speedKmh: _speed,
                        fuelPercent: _fuel,
                        distanceTravelledKm: _distanceTravelled,
                        width: 200,
                        height: 200,
                        speedoMeterColor: Colors.black.withOpacity(0.7),
                      ),
                      Speedometer(
                        sizeText: 22,
                        speedKmh: _speed,
                        fuelPercent: _fuel,
                        distanceTravelledKm: _distanceTravelled,
                        speedoMeterColor: Colors.black.withOpacity(0.7),
                          speedoMeterBoundaryColor: Colors.red.withOpacity(0.2),
                      ),
                      Speedometer(
                        sizeText: 11,
                        speedKmh: _speed,
                        fuelPercent: _fuel,
                        distanceTravelledKm: _distanceTravelled,
                        width: 200,
                        height: 200,
                        speedoMeterColor: Colors.black.withOpacity(0.7),
                      ),

                    ],
                  ),
                ),

                /// ЦИФРА
                Positioned(
                  top: 140,
                  child: Text(
                    "108",
                    style: GoogleFonts.orbitron(
                      fontSize: 90,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                /// SMX
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "SMX",
                    style: GoogleFonts.knewave(
                      color: Color(0xFF770E04),
                      fontSize: 30,
                    ),
                  ),
                ),

                /// ПЕРЕДАЧА
                Positioned(
                  right: 120,
                  bottom: 80,
                  child: Text(
                    "D",
                    style: GoogleFonts.orbitron(
                      fontSize: 40,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                /// НИЖНЯЯ ПАНЕЛЬ
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    color: Colors.black.withOpacity(0.3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _lamp(Icons.door_front_door, "DOOR", true),
                        _lamp(Icons.lock, "ABS", false),
                        _lamp(Icons.air, "SRS", false),
                        _lamp(Icons.lightbulb, "LOW", true),
                        _lamp(Icons.highlight, "HIGH", false),
                        _lamp(Icons.event_seat, "BELT", true),
                        _lamp(Icons.local_parking, "BRAKE", false),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _onTap,
        tooltip: 'Change',
        backgroundColor: Colors.grey.shade200,
        child: const Icon(Icons.star, color: Color.fromARGB(255, 41, 41, 41)),
      ),
    );
  }

  Widget _lamp(IconData icon, String label, bool active) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 20,
          color: active ? Colors.redAccent : Colors.white24,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.orbitron(
            fontSize: 9,
            color: active ? Colors.redAccent : Colors.white24,
          ),
        ),
      ],
    );
  }
}

/// 🔥 ЦЕНТРАЛЬНЫЙ СПИДОМЕТР
class SpeedPainter extends CustomPainter {
  final double speed;

  SpeedPainter(this.speed);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    /// glow
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.red.withOpacity(0.4),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, glow);

    /// фон дуги
    final bg = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 20),
      pi,
      pi,
      false,
      bg,
    );

    /// активная дуга
    final sweep = (speed / 180) * pi;

    final active = Paint()
      ..shader = SweepGradient(
        startAngle: pi,
        endAngle: 2 * pi,
        colors: [Colors.redAccent, Colors.red],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 20),
      pi,
      sweep,
      false,
      active,
    );

    /// стрелка
    final angle = pi + sweep;

    final needle = Paint()
      ..color = Colors.red
      ..strokeWidth = 3;

    final end = Offset(
      center.dx + cos(angle) * (radius - 40),
      center.dy + sin(angle) * (radius - 40),
    );

    canvas.drawLine(center, end, needle);

    canvas.drawCircle(center, 6, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 📊 БОКОВЫЕ ДАТЧИКИ
class SmallGauge extends StatelessWidget {
  final double value;
  final String label;

  const SmallGauge({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(120, 120),
      painter: SmallGaugePainter(value),
      child: Center(
        child: Text(
          "$value\n$label",
          textAlign: TextAlign.center,
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class SmallGaugePainter extends CustomPainter {
  final double value;

  SmallGaugePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    final bg = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      bg,
    );

    final active = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      (value / 100) * pi,
      false,
      active,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}