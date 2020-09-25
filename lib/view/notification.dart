import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Notification Window")
      ),
      body: Center(
        child: RaisedButton(
          child: Text("Click me"),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ),
    );
  }
}
