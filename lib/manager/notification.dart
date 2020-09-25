import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import '../navigator.dart';

GetIt locator = GetIt.instance;

enum NotificationAction {
  battery
}

class NotificationManager {
  static const String CHANNEL_ID = "Channel ID";
  static const String CHANNEL_NAME = "Channel Name";
  static const String CHANNEL_DESC = "Channel description";


  FlutterLocalNotificationsPlugin plugin;
  NotificationDetails specifics;

  void init() async {
    plugin = FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    await plugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        CHANNEL_ID, CHANNEL_NAME, CHANNEL_DESC,
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker'
    );
    const iOSPlatformChannelSpecifics = IOSNotificationDetails();
    specifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  }

  void notify(String title, String body, NotificationAction action) async {
    await plugin.show(0, title, body, specifics, payload: action.toString());
  }

  Future<dynamic> onSelectNotification(String payload) {
    if (payload == null) payload = "empty payload";

    print("Notification: $payload");

    if (payload == NotificationAction.battery.toString()) {
      print("Navigating to notification");
      locator<NavigationService>().navigate("notification");
    }
  }
}