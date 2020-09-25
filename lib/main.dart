import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'view/home.dart';
import 'view/notification.dart';
import 'manager/ble.dart';
import 'navigator.dart';

GetIt locator = GetIt.instance;

void main() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => BleManager());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLE Prototype',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => HomePage(title: 'Flutter Demo Home Page'),
        "notification": (context) => NotificationPage(),
      },
      navigatorKey: locator<NavigationService>().navigatorKey,
    );
  }
}

