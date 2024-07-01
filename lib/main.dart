import 'package:flutter/material.dart';
import '/bootstrap/app.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'app/networking/background_service.dart';
import 'app/providers/sensor_provider.dart';
import 'bootstrap/boot.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Nylo nylo = await Nylo.init(setup: Boot.nylo, setupFinished: Boot.finished);
  await initializeService(); //for background_service.dart
  runApp(
    ChangeNotifierProvider(
      create: (context) => SensorDataProvider(),
      child: AppBuild(
        navigatorKey: NyNavigator.instance.router.navigatorKey,
        onGenerateRoute: nylo.router!.generator(),
        debugShowCheckedModeBanner: false,
        initialRoute: nylo.getInitialRoute(),
        navigatorObservers: nylo.getNavigatorObservers(),
      ),
    ),
  );
  // runApp(
  //   AppBuild(
  //     navigatorKey: NyNavigator.instance.router.navigatorKey,
  //     onGenerateRoute: nylo.router!.generator(),
  //     debugShowCheckedModeBanner: false,
  //     initialRoute: nylo.getInitialRoute(),
  //     navigatorObservers: nylo.getNavigatorObservers(),
  //   ),
  // );
}
