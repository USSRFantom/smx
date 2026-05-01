import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smx/constants.dart';
import 'package:smx/speedometer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double _speed = 0;
  double _temp = 0;
  double _oil = 0;
  int _distanceTravelled = 2100;


  void _onTapSpeed() {
    setState(() {
      _speed = (_speed + 3).clamp(0, 200);
      _distanceTravelled++;
    });
  }

  void _onTapTemp() {
    setState(() {
      _temp = (_temp + 3).clamp(65, 115);
      _distanceTravelled++;
    });
  }

  void _onTapOil() {
    setState(() {
      _oil = (_oil + 1).clamp(0, 60);

      _distanceTravelled++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: 1920,
            height: 550,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset('assets/bg.png', fit: BoxFit.cover),
                ),
                Positioned.fill(
                  child: Container(color: Colors.black.withOpacity(0.1)),
                ),

                Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Speedometer(
                            sizeText: 11,
                            speedKmh: _temp,
                            distanceTravelledKm: _distanceTravelled,
                            width: 300,
                            height: 300,
                            speedScale: Constants.tempScale,
                            speedoMeterColor: Colors.black.withOpacity(0.7),
                            centerText: _temp.toString(),
                            centerTextDescription: "°C",
                            minValue: 65,
                            maxValue: 115,
                          ),
                          const SizedBox(width: 100),

                          Speedometer(
                            minValue: 0,
                            maxValue: 200,
                            sizeText: 22,
                            speedKmh: _speed,
                            distanceTravelledKm: _distanceTravelled,
                            width: 550,
                            height: 550,
                            speedScale: Constants.speedScale,
                            speedoMeterColor: Colors.black.withOpacity(0.7),
                            speedoMeterBoundaryColor:
                            Colors.red.withOpacity(0.2),
                            centerTextDescription: "km/h",
                            centerText: _speed.toString(),
                          ),

                          const SizedBox(width: 100),

                          Speedometer(
                            minValue: 0,
                            maxValue: 60,
                            sizeText: 11,
                            speedKmh: _oil,
                            distanceTravelledKm: _distanceTravelled,
                            width: 300,
                            height: 300,
                            speedScale: Constants.fuelScale,
                            speedoMeterColor: Colors.black.withOpacity(0.7),
                            centerText: _oil.toString(),
                            centerTextDescription: "L",
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 8,
                        ),
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            onPressed: _onTapTemp,
            backgroundColor: Colors.grey.shade200,
            child: const Icon(Icons.ac_unit,
                color: Color.fromARGB(255, 41, 41, 41)),
          ),
          FloatingActionButton(
            onPressed: _onTapSpeed,
            backgroundColor: Colors.grey.shade200,
            child: const Icon(Icons.speed,
                color: Color.fromARGB(255, 41, 41, 41)),
          ),
          FloatingActionButton(
            onPressed: _onTapOil,
            backgroundColor: Colors.grey.shade200,
            child: const Icon(Icons.oil_barrel,
                color: Color.fromARGB(255, 41, 41, 41)),
          ),
        ],
      ),
    );
  }

  Widget _lamp(IconData icon, String label, bool active) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            size: 20,
            color: active ? Colors.redAccent : Colors.white24),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.orbitron(
            fontSize: 14,
            color: active ? Colors.redAccent : Colors.white24,
          ),
        ),
      ],
    );
  }
}