import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../utils/crc_calculator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

typedef OnMeasurementUpdate = void Function(Map<String, dynamic>);

class MeasurementService {
  final fbp.BluetoothDevice device;
  final fbp.BluetoothCharacteristic txCharacteristic;
  final fbp.BluetoothCharacteristic rxCharacteristic;
  OnMeasurementUpdate onMeasurementUpdate;

  MeasurementService({
    required this.device,
    required this.txCharacteristic,
    required this.rxCharacteristic,
    required this.onMeasurementUpdate,
  }) {
    print("MeasurementService created for device: ${device.id}");
  }

  Future<void> startMeasurements() async {
    print("Starting measurements");
    while (true) {
      await _readHeartRate();
      await _readBloodOxygen();
      await _readHRV();
      await _readTemperature();
    }
  }

  Future<void> _readHeartRate() async {
    print("Starting heart rate measurement");
    List<int> command = createCommand(0x02, 0x01); // Command to read heart rate
    await txCharacteristic.write(command);
    print("Sent command to read heart rate");

    rxCharacteristic.value.listen((value) {
      if (value.isNotEmpty && value[0] == 0x28) {
        int heartRate = value[2];
        print("Heart Rate Value: $heartRate");
        onMeasurementUpdate({'heartRate': heartRate});
        callAPI("04-02-02-05-E3-03", "heartRate", heartRate.toString());
      }
    });

    await Future.delayed(Duration(minutes: 1));
    await _stopMeasurement(0x02);
  }

  Future<void> _readHRV() async {
    print("Starting HRV measurement");
    List<int> command = createCommand(0x01, 0x01); // Command to read HRV
    await txCharacteristic.write(command);
    print("Sent command to read HRV");

    rxCharacteristic.value.listen((value) {
      if (value.isNotEmpty && value[0] == 0x28) {
        int hrv = value[4];
        print("HRV Value: $hrv");
        onMeasurementUpdate({'hrv': hrv});
      }
    });

    await Future.delayed(Duration(minutes: 1));
    await _stopMeasurement(0x01);
  }

  Future<void> _readBloodOxygen() async {
    print("Starting blood oxygen measurement");
    List<int> command =
        createCommand(0x03, 0x01); // Command to read blood oxygen
    await txCharacteristic.write(command);
    print("Sent command to read blood oxygen");

    rxCharacteristic.value.listen((value) {
      if (value.isNotEmpty && value[0] == 0x28) {
        int bloodOxygen = value[3];
        print("Blood Oxygen Value: $bloodOxygen");
        onMeasurementUpdate({'bloodOxygen': bloodOxygen});
      }
    });

    await Future.delayed(Duration(minutes: 1));
    await _stopMeasurement(0x03);
  }

  Future<void> _readTemperature() async {
    print("Starting temperature measurement");
    List<int> command =
        createCommand(0x04, 0x01); // Command to read temperature
    await txCharacteristic.write(command);
    print("Sent command to read temperature");

    rxCharacteristic.value.listen((value) {
      if (value.isNotEmpty && value[0] == 0x28) {
        double temperature = value[8] / 10.0;
        print("Temperature Value: $temperature");
        onMeasurementUpdate({'temperature': temperature});
      }
    });

    await Future.delayed(Duration(minutes: 1));
    await _stopMeasurement(0x04);
  }

  Future<void> _stopMeasurement(int measurement) async {
    print("Stopping measurement for $measurement");
    List<int> command =
        createCommand(measurement, 0x00); // Command to stop measurement
    await txCharacteristic.write(command);
    print("Sent command to stop measurement for $measurement");
  }

  List<int> createCommand(int measurementType, int startStopInd) {
    List<int> value = List.filled(16, 0);
    value[0] = 0x28; // Command to measure
    value[1] = measurementType;
    value[2] = startStopInd; // 0x01 to start measurement, 0x00 to stop

    // Compute CRC and set the last byte
    int crc = CrcCalculator.calculateCRC(value);
    value[value.length - 1] = crc;

    return value;
  }

  Future<String> callAPI(
      String deviceMacId, String readingType, String value) async {
    print("Calling API for $readingType with value $value");
    var now = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    String formatted = formatter.format(now);

    final response = await http.post(
      Uri.parse('https://usmiley-telemetry.onrender.com/api/v1/$readingType'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': deviceMacId,
        'date': formatted,
        readingType: value,
      }),
    );

    if (response.statusCode == 200) {
      print("API Call for $readingType Successful");
      return "Success";
    } else {
      print("API Call for $readingType Failed");
      return "Failure";
    }
  }
}
