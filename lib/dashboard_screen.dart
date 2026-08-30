import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:smx/constants.dart';
import 'package:smx/services/arduino_service.dart';
import 'package:smx/speedometer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double _speed = 0;
  double _temp = 65;
  double _oil = 60;
  int _distanceTravelled = 2100;

  final ArduinoService _arduinoService = ArduinoService();

  StreamSubscription<List<bool>>? _arduinoSubscription;




  final List<bool> _lamps = List.generate(10, (_) => false);

  Timer? _lampTimer;

  bool _isSweeping = true;
  int _sweepIndex = 0;
  bool _sweepForward = true;

  int _randomCooldown = 0;

  Timer? _timer;

  Future<void> _connectArduino() async {
    final connected = await _arduinoService.connect();

    if (!connected) {
      print('Arduino не подключена');
      return;
    }

    _arduinoSubscription = _arduinoService.channels.listen(
          (channels) {
        if (!mounted) {
          return;
        }

        setState(() {
          for (int i = 0; i < _lamps.length; i++) {
            _lamps[i] = channels[i];
          }
        });
      },
    );
  }


  static const bool useArduino = true;

  @override
  void initState() {
    super.initState();

    print('DASHBOARD: initState');

    if (useArduino) {
      print('DASHBOARD: запускаем Arduino');
      _connectArduino();
    } else {
      print('DASHBOARD: запускаем симуляцию');
      _startSimulation();
      _startLampAnimation();
    }
  }

  void _startLampAnimation() {
    _lampTimer = Timer.periodic(
      const Duration(milliseconds: 180),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        setState(() {
          if (_isSweeping) {
            _runSweep();
          } else {
            _runRandom();
          }
        });
      },
    );
  }

  void _runSweep() {
    for (int i = 0; i < _lamps.length; i++) {
      _lamps[i] = false;
    }

    _lamps[_sweepIndex] = true;

    if (_sweepForward) {
      _sweepIndex++;
      if (_sweepIndex >= _lamps.length - 1) {
        _sweepForward = false;
      }
    } else {
      _sweepIndex--;
      if (_sweepIndex <= 0) {
        _isSweeping = false;
      }
    }
  }

  void _runRandom() {
    if (_randomCooldown > 0) {
      _randomCooldown--;
      return;
    }

    for (int i = 0; i < _lamps.length; i++) {
      _lamps[i] = false;
    }

    final rand = Random().nextInt(_lamps.length);
    _lamps[rand] = true;

    _randomCooldown = 28; // ~5 сек (28 * 180ms ≈ 5s)
  }

  void _startSimulation() {
    double throttle = 0;
    int stopTimer = 0;

    _timer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        final rand = Random().nextDouble();

        // 🚦 имитация светофоров / остановок
        if (rand > 0.96 && _speed < 20) {
          stopTimer = 20; // ~2–3 секунды стоп
        }

        if (stopTimer > 0) {
          stopTimer--;

          // 🛑 машина стоит
          _speed *= 0.85;
          if (_speed < 0.5) _speed = 0;
          throttle = 0;
        } else {
          // 🚗 нормальное движение
          if (rand > 0.82) {
            throttle = rand; // газ
          } else {
            throttle *= 0.97; // отпуск газа
          }
        }

        // 🚗 скорость (инерция)
        final targetSpeed = throttle * 130;
        _speed += (targetSpeed - _speed) * 0.07;
        _speed = _speed.clamp(0, 130);

        // 🌡 температура
        final loadFactor = _speed / 130;
        final tempTarget = 65 + loadFactor * 30;

        _temp += (tempTarget - _temp) * 0.04;
        _temp = _temp.clamp(65, 95);

        // ⛽ УВЕЛИЧЕННЫЙ расход топлива
        final fuelDrain = 0.004 + (_speed / 130) * 0.018;
        _oil -= fuelDrain;
        _oil = _oil.clamp(0, 60);

        // 📍 пробег
        if (_speed > 0.5) {
          _distanceTravelled++;
        }
      });
    });
  }

  void onArduinoData(double speed, double temp, double fuel) {
    setState(() {
      _speed = speed;
      _temp = temp;
      _oil = fuel;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _lampTimer?.cancel();

    _arduinoSubscription?.cancel();
    _arduinoService.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.asset('assets/bg.png', fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.1)),
            ),

            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned(
                  top: 5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.7),
                          blurRadius: 60,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _lamp('assets/gas.png', 0),
                        SizedBox(width: 15),
                        _lamp('assets/high_beam.png', 1),
                        SizedBox(width: 15),
                        _lamp('assets/open_trunk.png', 2),
                        SizedBox(width: 15),
                        _lamp('assets/door_open.png', 3),
                        SizedBox(width: 15),
                        _lamp('assets/check.png', 4),
                        SizedBox(width: 15),
                        _lamp('assets/battery.png', 5),
                        SizedBox(width: 15),
                        _lamp('assets/abs.png', 6),
                        SizedBox(width: 15),
                        _lamp('assets/srs.png', 7),
                        SizedBox(width: 15),
                        _lamp('assets/oil.png', 8),
                        SizedBox(width: 15),
                        _lamp('assets/seatbelt.png', 9),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;

                      final small = width * 0.24;
                      final big = width * 0.42;
                      final spacing = width * 0.03;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Speedometer(
                            minValue: 65,
                            maxValue: 115,
                            sizeText: 15,
                            speedKmh: _temp,
                            distanceTravelledKm: _distanceTravelled,
                            width: small,
                            height: small,
                            speedScale: Constants.tempScale,
                            speedoMeterColor: Colors.black.withOpacity(0.7),
                            centerText: _temp.toStringAsFixed(0),
                            centerTextDescription: "°C",
                            bottomIcon: 'assets/cooler.png',
                          ),

                          SizedBox(width: spacing),

                          Speedometer(
                            minValue: 0,
                            maxValue: 200,
                            sizeText: 30,
                            speedKmh: _speed,
                            distanceTravelledKm: _distanceTravelled,
                            width: big,
                            height: big,
                            speedScale: Constants.speedScale,
                            speedoMeterColor: Colors.black.withOpacity(0.7),
                            centerTextDescription: "km/h",
                            centerText: _speed.toStringAsFixed(0),
                          ),

                          SizedBox(width: spacing),

                          Speedometer(
                            minValue: 0,
                            maxValue: 60,
                            sizeText: 20,
                            speedKmh: _oil,
                            distanceTravelledKm: _distanceTravelled,
                            width: small,
                            height: small,
                            speedScale: Constants.fuelScale,
                            speedoMeterColor: Colors.black.withOpacity(0.7),
                            centerText: _oil.toStringAsFixed(0),
                            centerTextDescription: "L",
                            bottomIcon: 'assets/gas.png',
                          ),
                        ],
                      );
                    },
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _lamp(String icon, int index) {
    final active = _lamps[index];

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: active ? 1 : 0.25,
      child: Image.asset(
        icon,
        width: 50,
        height: 50,
        color: active ? Colors.orange : Colors.black,
      ),
    );
  }

}


class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    final w = size.width;
    final h = size.height;

    path.moveTo(w * 0.25, 0);
    path.lineTo(w * 0.75, 0);
    path.lineTo(w, h * 0.5);
    path.lineTo(w * 0.75, h);
    path.lineTo(w * 0.25, h);
    path.lineTo(0, h * 0.5);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
