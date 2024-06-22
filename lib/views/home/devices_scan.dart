import 'package:digitaltwin/services/bluetooth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;

class DeviceScanningScreen extends StatefulWidget {
  @override
  _DeviceScanningScreenState createState() => _DeviceScanningScreenState();
}

class _DeviceScanningScreenState extends State<DeviceScanningScreen> {
  final BluetoothService _bluetoothService = BluetoothService();
  List<fbp.ScanResult> _scanResults = [];
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _bluetoothService.scanResults.listen((results) {
      if (mounted) {
        setState(() {
          _scanResults = results;
        });
      }
    });
    _startScan();
  }

  void _startScan() {
    setState(() {
      _isScanning = true;
    });

    _bluetoothService.scanForDevices();
    Future.delayed(Duration(seconds: 5)).then((_) {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
      print("Error starting scan: $error");
    });
  }

  void _stopScan() {
    _bluetoothService.stopScan();
    if (mounted) {
      setState(() {
        _isScanning = false;
      });
    }
  }

  @override
  void dispose() {
    _bluetoothService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Scanning'),
        actions: [
          IconButton(
            icon: Icon(_isScanning ? Icons.stop : Icons.refresh),
            onPressed: _isScanning ? _stopScan : _startScan,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _scanResults.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_scanResults[index].device.name),
            subtitle: Text(_scanResults[index].device.id.id),
            onTap: () async {
              bool connected = await _bluetoothService
                  .connectToDevice(_scanResults[index].device);
              if (connected) {
                // Handle successful connection
              }
            },
          );
        },
      ),
    );
  }
}
