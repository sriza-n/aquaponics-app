import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '../../app/providers/sensor_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MainPage extends NyStatefulWidget {
  static const path = '/main';

  MainPage({super.key}) : super(path, child: () => _MainPageState());
}

class _MainPageState extends NyState<MainPage> {
  // late Timer _timer;
  late final Timer _timer;
  bool isRelayOn1 = false;
  bool isRelayOn2 = false;

  @override
  init() async {
    // super.initState();
    final provider = Provider.of<SensorDataProvider>(context, listen: false);
    provider.fetchSensorData();
    // _timer = Timer.periodic(Duration(seconds: 5), (timer) {
    //   provider.fetchSensorData();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      // Assuming fetchSensorData is defined in your SensorDataProvider
      Provider.of<SensorDataProvider>(context, listen: false).fetchSensorData();
    }); // Fetch data every 5 seconds

    // });
  }

  // @override
  // boot() async {
  //   _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
  //     // Assuming fetchSensorData is defined in your SensorDataProvider
  //     Provider.of<SensorDataProvider>(context, listen: false).fetchSensorData();
  //   });
  // }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _controlRelay(
      BuildContext context, int relayNumber, String state) async {
    try {
      final provider = Provider.of<SensorDataProvider>(context, listen: false);
      await provider.controlRelay(relayNumber, state);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Relay $relayNumber $state Successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to control relay $relayNumber')),
      );
    }
  }

  /// Use boot if you need to load data before the [view] is rendered.
  // @override
  // boot() async {
  //
  // }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'Aquaponics Dashboard',
          style: TextStyle(fontSize: 20, color: Colors.white),
        )),
      ),
      body: Consumer<SensorDataProvider>(
        builder: (context, provider, child) {
          final sensorData = provider.sensorData;
          if (sensorData == null) {
            return Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              SingleChildScrollView(
                  child: Row(
                children: [
                  Container(
                    child: Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            height: 200,
                            child: SfRadialGauge(
                              axes: <RadialAxis>[
                                RadialAxis(
                                  minimum: 0,
                                  maximum: 100,
                                  labelsPosition: ElementsPosition.outside,
                                  ticksPosition: ElementsPosition.outside,
                                  axisLineStyle: AxisLineStyle(thickness: 10),
                                  majorTickStyle:
                                      MajorTickStyle(length: 10, thickness: 2),
                                  minorTicksPerInterval: 5,
                                  showLabels: false,
                                  showTicks: false,
                                  pointers: <GaugePointer>[
                                    RangePointer(value: sensorData.temperature),
                                  ],
                                  annotations: <GaugeAnnotation>[
                                    GaugeAnnotation(
                                      widget: Container(
                                        child: Text(
                                            '${sensorData.temperature}°C',
                                            style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      angle: 90,
                                      positionFactor: 0.0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            // Adjust padding to control space between the gauge and the text
                            padding: EdgeInsets.only(top: 10),
                            child: Text('Temperature',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          padding: EdgeInsets.all(10),
                          child: SfRadialGauge(
                            axes: <RadialAxis>[
                              RadialAxis(
                                minimum: 0,
                                maximum: 100,
                                labelsPosition: ElementsPosition.outside,
                                ticksPosition: ElementsPosition.outside,
                                axisLineStyle: AxisLineStyle(thickness: 10),
                                majorTickStyle:
                                    MajorTickStyle(length: 10, thickness: 2),
                                minorTicksPerInterval: 5,
                                showLabels: false,
                                showTicks: false,
                                pointers: <GaugePointer>[
                                  RangePointer(
                                      value: sensorData.waterTemperature),
                                ],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                    widget: Container(
                                      child: Text(
                                          '${sensorData.waterTemperature}°C',
                                          style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    angle: 90,
                                    positionFactor: 0.0,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          // Adjust padding to control space between the gauge and the text
                          padding: EdgeInsets.only(top: 10),
                          child: Text('Water Temperature',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
              SizedBox(height: 20),
              Expanded(
                  child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          // height: 200,
                          padding: EdgeInsets.all(10),
                          child: SfRadialGauge(
                            axes: <RadialAxis>[
                              RadialAxis(
                                minimum: 0,
                                maximum:
                                    100, // Assuming humidity is measured from 0% to 100%
                                labelsPosition: ElementsPosition.outside,
                                ticksPosition: ElementsPosition.outside,
                                axisLineStyle: AxisLineStyle(thickness: 10),
                                majorTickStyle:
                                    MajorTickStyle(length: 10, thickness: 2),
                                minorTicksPerInterval: 5,
                                pointers: <GaugePointer>[
                                  RangePointer(value: sensorData.humidity),
                                ],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                    widget: Container(
                                      child: Text('${sensorData.humidity}%',
                                          style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    angle: 90,
                                    positionFactor: 0.0,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text('Humidity',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  SfLinearGauge(
                    minimum: 0,
                    maximum: 14,
                    orientation: LinearGaugeOrientation.horizontal,
                    // showLabels: true,
                    // showAxisTrack: true,
                    axisTrackStyle: LinearAxisTrackStyle(thickness: 10),
                    markerPointers: [
                      LinearWidgetPointer(
                        value: 3, // Position for "Acidic"
                        child:
                            Text('Acidic', style: TextStyle(color: Colors.red)),
                      ),
                      LinearWidgetPointer(
                        value: 7, // Position for "Neutral"
                        child: Text('Neutral',
                            style: TextStyle(color: Colors.green)),
                      ),
                      LinearWidgetPointer(
                        value: 11, // Position for "Basic"
                        child:
                            Text('Basic', style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                    ranges: [
                      LinearGaugeRange(
                        startValue: 0,
                        endValue: sensorData.phValue,
                        color: Colors.blue,
                        startWidth: 10,
                        endWidth: 10,
                      ),
                    ],
                  ),
                  // SizedBox(height: 20),
                  Text('Ph Value: ${sensorData.phValue}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                ],
              )),
              // Text('Date: ${sensorData.date}'),
              // Text('Time: ${sensorData.time}'),
              // Text('Humidity: ${sensorData.humidity}'),
              // Text('Temperature: ${sensorData.temperature}'),
              // Text('Water Temperature: ${sensorData.waterTemperature}'),
              // Text('Water Level: ${sensorData.waterLevel}'),
              // Text('pH Value: ${sensorData.phValue}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Relay 1:'),
                  Switch(
                    value: isRelayOn1,
                    onChanged: (value) {
                      setState(() {
                        isRelayOn1 = value;
                        _controlRelay(context, 1, isRelayOn1 ? 'on' : 'off');
                      });
                    },
                  ),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Text('Relay 2:'),
              //     Switch(
              //       value: isRelayOn2,
              //       onChanged: (value) {
              //         setState(() {
              //           isRelayOn2 = value;
              //           _controlRelay(context, 2, isRelayOn2 ? 'on' : 'off');
              //         });
              //       },
              //     ),
              //   ],
              // ),
              // Repeat for other relays
            ],
          );
        },
      ),
    );
  }
}
