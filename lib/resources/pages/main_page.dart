import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '../../app/providers/sensor_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../bootstrap/helpers.dart';

class MainPage extends NyStatefulWidget {
  static const path = '/main';

  MainPage({super.key}) : super(path, child: () => _MainPageState());
}

class _MainPageState extends NyState<MainPage> {
  late final Timer _timer;
  bool isRelayOn1 = false;
  bool isRelayOn2 = false;
  bool isRelayOn3 = false;
  bool isRelayOn4 = false;
  final _textController = TextEditingController();

  @override
  init() async {
    final provider = Provider.of<SensorDataProvider>(context, listen: false);
    provider.fetchSensorData();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      Provider.of<SensorDataProvider>(context, listen: false).fetchSensorData();
    });
  }

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
        SnackBar(
            content: Text('Relay $relayNumber $state Successfully'),
            duration: Duration(seconds: 1),
            backgroundColor: ThemeColor.get(context).appBarBackground),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to control relay $relayNumber'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          // Use Builder to get the correct context
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                  Icons.settings_remote), // Use any icon that suits your needs
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Now context is correct
              },
            );
          },
        ),
        title: Center(
          child: Text(
            'Aquaponics Dashboard',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add), // Use any icon from Icons class
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Enter base url'),
                    content: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'http://192.168.1.2:8000',
                        )),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Save'),
                        onPressed: () {
                          print('Saved text: ${_textController.text}');

                          // NyStorage.store('baseurl', '${_textController.text}',
                          //     inBackpack: true);
                          // Backpack.instance
                          //     .set('baseurl', '${_textController.text}');

                          Navigator.of(context).pop(NyStorage.store(
                              "baseurl", "${_textController.text}",
                              inBackpack: true));
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      drawerScrimColor: Colors.transparent,
      drawer: SizedBox(
        width: 200,
        height: 300,
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor:
                Colors.transparent, // Make drawer background transparent
          ),
          child: Drawer(
            backgroundColor:
                ThemeColor.get(context).appBarBackground.withOpacity(0.5),
            // elevation: 10,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                // DrawerHeader(
                // child: Text('Drawer Header'),
                // decoration: BoxDecoration(
                //     // color: Colors.blue,
                //     ),
                // ),

                SizedBox(height: 30),
                ListTile(
                  // title: Center(child: Text('Item 1')),
                  // onTap: () => _onTextPressed('Item 1'),
                  title: Center(child: Text('Relay 1')),
                  trailing: Switch(
                    value: isRelayOn1,
                    activeColor: ThemeColor.get(context).background,
                    activeTrackColor: ThemeColor.get(context).buttonBackground,
                    onChanged: (value) {
                      setState(() {
                        isRelayOn1 = value;
                        _controlRelay(context, 1, isRelayOn1 ? 'on' : 'off');
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Center(child: Text('Relay 2')),
                  trailing: Switch(
                    value: isRelayOn2,
                    activeColor: ThemeColor.get(context).background,
                    activeTrackColor: ThemeColor.get(context).buttonBackground,
                    onChanged: (value) {
                      setState(() {
                        isRelayOn2 = value;
                        _controlRelay(context, 2, isRelayOn1 ? 'on' : 'off');
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Center(child: Text('Relay 3')),
                  trailing: Switch(
                    value: isRelayOn3,
                    activeColor: ThemeColor.get(context).background,
                    activeTrackColor: ThemeColor.get(context).buttonBackground,
                    onChanged: (value) {
                      setState(() {
                        isRelayOn3 = value;
                        _controlRelay(context, 3, isRelayOn1 ? 'on' : 'off');
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Center(child: Text('Relay 4')),
                  trailing: Switch(
                    value: isRelayOn4,
                    activeColor: ThemeColor.get(context).background,
                    activeTrackColor: ThemeColor.get(context).buttonBackground,
                    onChanged: (value) {
                      setState(() {
                        isRelayOn4 = value;
                        _controlRelay(context, 4, isRelayOn1 ? 'on' : 'off');
                      });
                    },
                  ),
                ),
                // Add more ListTile widgets for more pressable texts
              ],
            ),
          ),
        ),
      ),
      body: Consumer<SensorDataProvider>(
        builder: (context, provider, child) {
          final sensorData = provider.sensorData;
          if (sensorData == null) {
            return Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
              child: Column(
                children: [
                  Row(
                    // mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Column for the gauges on the left
                      Flexible(
                        flex: 5,
                        fit: FlexFit.tight,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                _buildRadialGauge(
                                  title: 'Water Temperature',
                                  value: sensorData.waterTemperature,
                                  minValue: 0,
                                  maxValue: 100,
                                  unit: '°C',
                                ),
                                _buildRadialGauge(
                                  title: 'Atm Temperature',
                                  value: sensorData.temperature,
                                  minValue: 0,
                                  maxValue: 100,
                                  unit: '°C',
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                _buildHumGauge(
                                  title: 'Humidity',
                                  value: sensorData.humidity,
                                  minValue: 0,
                                  maxValue: 100,
                                  unit: '%',
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      // _buildWatGauge on the right
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: _buildWatGauge(
                          title: 'water Level',
                          value: sensorData.waterLevel,
                          minValue: 0,
                          maxValue: 100,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildLinearGauge(
                    title: 'pH Value',
                    value: sensorData.phValue,
                    minValue: 0,
                    maxValue: 14,
                  ),
                  // SizedBox(height: 20),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       // Your button action
                  //     },
                  //     child: Text('Control Relays'),
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRadialGauge({
    required String title,
    required double value,
    required double minValue,
    required double maxValue,
    required String unit,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 200,
            padding: EdgeInsets.all(0),
            child: SfRadialGauge(
              animationDuration: 2000,
              enableLoadingAnimation: true,
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: minValue,
                  maximum: maxValue,
                  labelsPosition: ElementsPosition.outside,
                  ticksPosition: ElementsPosition.outside,
                  axisLineStyle: AxisLineStyle(thickness: 10),
                  // majorTickStyle: MajorTickStyle(length: 10, thickness: 2),
                  // minorTicksPerInterval: 5,
                  showLabels: false,
                  showTicks: false,
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: value,
                      enableAnimation: true,
                      animationDuration: 1000,
                      animationType: AnimationType.bounceOut,
                      color: ThemeColor.get(context).appBarBackground,
                      width: 15,
                      cornerStyle: CornerStyle.endCurve,
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Container(
                        child: Text(
                          '$value$unit',
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.bold),
                        ),
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
            padding: EdgeInsets.only(top: 0),
            child: Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHumGauge({
    required String title,
    required double value,
    required double minValue,
    required double maxValue,
    required String unit,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 300,
            padding: EdgeInsets.zero,
            child: SfRadialGauge(
              animationDuration: 2000,
              enableLoadingAnimation: true,
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: minValue,
                  maximum: maxValue,
                  labelsPosition: ElementsPosition.outside,
                  ticksPosition: ElementsPosition.outside,
                  axisLineStyle: AxisLineStyle(thickness: 10),
                  majorTickStyle: MajorTickStyle(length: 10, thickness: 2),
                  minorTicksPerInterval: 5,
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: value,
                      enableAnimation: true,
                      animationDuration: 1000,
                      animationType: AnimationType.bounceOut,
                      color: ThemeColor.get(context).appBarBackground,
                      width: 15,
                      cornerStyle: CornerStyle.endCurve,
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Container(
                        child: Text(
                          '$value$unit',
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
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
            padding: const EdgeInsets.only(top: 0),
            child: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Text('$value $unit', style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildLinearGauge({
    required String title,
    required double value,
    required double minValue,
    required double maxValue,
  }) {
    return Column(
      children: [
        SfLinearGauge(
          minimum: minValue,
          maximum: maxValue,
          orientation: LinearGaugeOrientation.horizontal,
          axisTrackStyle: LinearAxisTrackStyle(thickness: 10),
          markerPointers: [
            LinearWidgetPointer(
              value: 3,
              child: Text('Acidic', style: TextStyle(color: Colors.red)),
            ),
            LinearWidgetPointer(
              value: 7,
              child: Text('Neutral', style: TextStyle(color: Colors.green)),
            ),
            LinearWidgetPointer(
              value: 11,
              child: Text('Basic', style: TextStyle(color: Colors.blue)),
            ),
          ],
          ranges: [
            LinearGaugeRange(
              startValue: minValue,
              endValue: value,
              color: ThemeColor.get(context).appBarBackground,
              startWidth: 10,
              endWidth: 10,
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          '$title: $value',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildWatGauge({
    required String title,
    required double value,
    required double minValue,
    required double maxValue,
  }) {
    return Column(
      children: [
        SfLinearGauge(
          minimum: minValue,
          maximum: maxValue,
          orientation: LinearGaugeOrientation.vertical,
          axisTrackStyle: LinearAxisTrackStyle(thickness: 10),
          // showLabels: false,
          // showTicks: false,
          ranges: [
            LinearGaugeRange(
              startValue: minValue,
              endValue: value,
              color: ThemeColor.get(context).appBarBackground,
              startWidth: 10,
              endWidth: 10,
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          '$title',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
