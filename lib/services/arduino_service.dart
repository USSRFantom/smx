import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:usb_serial/usb_serial.dart';

class ArduinoService {
  UsbPort? _port;
  StreamSubscription<Uint8List>? _subscription;

  final StreamController<List<bool>> _channelsController =
  StreamController<List<bool>>.broadcast();

  Stream<List<bool>> get channels => _channelsController.stream;

  Future<bool> connect() async {
    final devices = await UsbSerial.listDevices();

    if (devices.isEmpty) {
      print('Arduino не найден');
      return false;
    }

    print('Найдено USB устройств: ${devices.length}');

    for (final device in devices) {
      print(
        'USB: ${device.productName} '
            'VID=${device.vid} '
            'PID=${device.pid}',
      );
    }

    final device = devices.first;

    final port = await device.create();
    if (port == null) {
      print('Не удалось создать USB порт');
      return false;
    }

    final opened = await port.open();
    if (!opened) {
      print('Не удалось открыть USB порт');
      return false;
    }

    _port = port;

    await port.setDTR(true);
    await port.setRTS(true);

    await port.setPortParameters(
      9600,
      UsbPort.DATABITS_8,
      UsbPort.STOPBITS_1,
      UsbPort.PARITY_NONE,
    );

    _subscription = port.inputStream?.listen(
      _onData,
      onError: (error) {
        print('Arduino USB error: $error');
      },
    );

    print('Arduino подключена');

    return true;
  }

  void _onData(Uint8List data) {
    final text = utf8.decode(data, allowMalformed: true);

    print('Arduino → $text');

    final lines = text.split('\n');

    for (final line in lines) {
      final value = line.trim();

      if (value.isEmpty) {
        continue;
      }

      if (value.startsWith('CH')) {
        _parseChannels(value);
      }
    }
  }

  void _parseChannels(String line) {
    final channels = List<bool>.filled(16, false);

    final parts = line.split(';');

    for (final part in parts) {
      final data = part.split('=');

      if (data.length != 2) {
        continue;
      }

      final channelName = data[0].trim();
      final value = data[1].trim();

      if (!channelName.startsWith('CH')) {
        continue;
      }

      final channelNumber = int.tryParse(
        channelName.substring(2),
      );

      if (channelNumber == null) {
        continue;
      }

      if (channelNumber < 1 || channelNumber > 16) {
        continue;
      }

      channels[channelNumber - 1] = value == '1';
    }

    _channelsController.add(channels);
  }

  Future<void> disconnect() async {
    await _subscription?.cancel();
    _subscription = null;

    await _port?.close();
    _port = null;

    print('Arduino отключена');
  }

  Future<void> dispose() async {
    await disconnect();
    await _channelsController.close();
  }
}