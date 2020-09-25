import 'dart:async';
import 'dart:io';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

class BleManager {
  FlutterReactiveBle _ble;

  final Uuid serviceKarel = Uuid.parse("180f");
  final Uuid characteristicBattery = Uuid.parse("2a19");

  PermissionStatus _locationPermissionStatus = PermissionStatus.unknown;

  StreamController<int> _battery = StreamController<int>();

  Stream get battery => _battery.stream;

  BleManager() {
    _ble = FlutterReactiveBle();
  }

  void connect() async {
    print("Checking permissions");
    await _checkPermissions();
    
    _connectToDevice();
  }

  void _connectToDevice() {
    print("Starting scanning");
    StreamSubscription scanning;
    scanning = _ble.scanForDevices(withServices: [ serviceKarel ], scanMode: ScanMode.balanced)
      .listen((device) async {
        print("Found desired device ${device.name}, ID: ${device.id}, RSSI ${device.rssi}");
        scanning.cancel();

        _ble.connectToDevice(
            id: device.id,
            connectionTimeout: Duration(seconds: 5)
        ).listen((event) {
          if (event.connectionState == DeviceConnectionState.connected) {
            print("Connected to the device ${device.name} (${device.id})");
            _ble.discoverServices(device.id).then((services) => services.forEach((s) => print("- ${s.serviceId.toString()}")));

            final batteryChar = QualifiedCharacteristic(
              serviceId: serviceKarel,
              characteristicId: characteristicBattery,
              deviceId: device.id,
            );

            final processBattery = (List<int> data) {
              final value = data[0];
              print("Battery: $value");
              _battery.add(value);
            };

            //_ble.readCharacteristic(batteryChar).then(processBattery);
            _ble.subscribeToCharacteristic(batteryChar).listen(processBattery);
          } else if (event.connectionState == DeviceConnectionState.disconnected) {
            print("Disconnected from the device ${device.name} (${device.id}). Trying to reconnect...");
            _connectToDevice();
          } else {
            print("Actual state: ${event.connectionState}");
          }
        });
      });
  }

  void disconnect() async {

  }

  Future<void> _checkPermissions() async {
    if (Platform.isAndroid) {
      var permissionStatus = await PermissionHandler()
          .requestPermissions([PermissionGroup.location]);

      _locationPermissionStatus = permissionStatus[PermissionGroup.location];

      if (_locationPermissionStatus != PermissionStatus.granted) {
        return Future.error(Exception("Location permission not granted"));
      }
    }
  }

  void dispose() {
    _battery.close();
  }
}