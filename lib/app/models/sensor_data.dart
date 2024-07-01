class SensorData {
  final String date;
  final String time;
  final double humidity;
  final double temperature;
  final double waterTemperature;
  final double waterLevel;
  final double phValue;

  SensorData({
    required this.date,
    required this.time,
    required this.humidity,
    required this.temperature,
    required this.waterTemperature,
    required this.waterLevel,
    required this.phValue,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      date: json['date'],
      time: json['time'],
      humidity: json['humidity'],
      temperature: json['temperature'],
      waterTemperature: json['waterTemperature'],
      waterLevel: json['waterLevel'],
      phValue: json['phValue'],
    );
  }
}
