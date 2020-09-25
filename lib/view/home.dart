import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../manager/ble.dart';
import '../manager/notification.dart';

GetIt locator = GetIt.instance;

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  int _counter = 0;

  final _ble = BleManager();
  final _nm = NotificationManager();

  StreamSubscription<dynamic> _batterySub;

  @override
  void initState() {
    super.initState();
    _nm.init();

    _batterySub = _ble.battery.listen((value) {
      setState(() => _counter = value);
      new Future.delayed(Duration(seconds: 3), () {
        _nm.notify("Battery", "Battery level is ${value}%", NotificationAction.battery);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Battery level is $_counter%',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _ble.connect,
        tooltip: 'Connect',
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _batterySub.cancel();
  }
}
