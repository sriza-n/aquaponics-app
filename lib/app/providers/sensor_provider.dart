import 'package:flutter/material.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import '../models/sensor_data.dart';

class SensorDataProvider with ChangeNotifier {
  SensorData? _sensorData;
  final ApiService _service = ApiService();

  SensorData? get sensorData => _sensorData;

  Future<void> fetchSensorData() async {
    _sensorData = await _service.fetchLatestSensorData();
    notifyListeners();
  }

  Future<void> controlRelay(int relayNumber, String state) async {
    await _service.controlRelay(relayNumber, state);
    notifyListeners();
  }
}
