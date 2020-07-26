import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging_demo/MockPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

class PushNotificationService {
  FirebaseMessaging _fcm;

  PushNotificationService() {
    if (_fcm == null) _fcm = FirebaseMessaging();
    _getToken();
  }

  _getToken() => _fcm.getToken().then((token) => print("Device Token: $token"));

  Future<void> initialise(
    BuildContext context, {
    GlobalKey<NavigatorState> navigatorKey,
  }) async {
    print("***Notification initiated***");
    print("Context: $context");
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        print("Received Notification");
        _setMessage(message, context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        // print("onLaunch: $message");
        print("Received Notification");
        _setMessage(message, context);
      },
      onResume: (Map<String, dynamic> message) async {
        // print("onResume: $message");
        print("Received Notification");
      },
    );
  }

  _setMessage(Map<String, dynamic> message, BuildContext context) async {
    final DMessage dMessage = DMessage.fromMap(message);
    print(
        "Title: ${dMessage.notification.title}, body: ${dMessage.notification.body}, message: ${dMessage.data.message}");
    if ((dMessage.data.message)?.contains('5') ?? false) {
      final result = await _showOnMessagePlatformDialog();
      if (result) {
        Navigator.push(
          context,
          platformPageRoute(
            context: context,
            builder: (_) => MockScreen(
              title: dMessage.data.message,
            ),
          ),
        );
      }
    }
    if ((dMessage.data.message)?.contains('8') ?? false) {
      Get.defaultDialog(
          onConfirm: () => Get.back(),
          middleText: "Dialog made in 3 lines of code");
    }
    if ((dMessage.data.message)?.contains('2') ?? false) {
      Navigator.push(
        context,
        platformPageRoute(
          context: context,
          builder: (_) => MockScreen(
            title: "onResume: ${dMessage.notification.title}",
          ),
        ),
      );
    }
  }
}

/*
FLUTTER_NOTIFICATION_CLICK
 */

Future<bool> _showOnMessagePlatformDialog() {
  return showPlatformDialog<bool>(
    context: Get.overlayContext,
    builder: (_) => PlatformAlertDialog(
      title: Text(
        "title",
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              "body" * 20,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        PlatformDialogAction(
          child: PlatformText('Cancel'),
          onPressed: () => Get.back(result: false),
        ),
        PlatformDialogAction(
          child: PlatformText('Ok'),
          onPressed: () => Get.back(result: true),
        ),
      ],
    ),
  );
}

class DMessage {
  DMessage({
    this.from,
    this.id,
    this.notification,
    this.data,
  });

  String from;
  String id;
  Notification notification;
  Data data;

  factory DMessage.fromMap(Map json) {
    if (Platform.isIOS) {
      return DMessage(
        from: json["from"],
        id: json["id"],
        notification: Notification.fromMap(json["notification"]),
        data: Data.fromMap(json),
      );
    } else {
      return DMessage(
        from: json["from"],
        id: json["id"],
        notification: Notification.fromMap(json["notification"]),
        data: Data.fromMap(json["data"]),
      );
    }
  }
}

class Data {
  Data({
    this.message,
    this.collapseKey,
    this.userType,
    this.error,
    this.clickAction,
  });

  String message;
  String collapseKey;
  String userType;
  dynamic error;
  String clickAction;

  factory Data.fromMap(Map json) => Data(
        message: json["message"],
        collapseKey: json["collapse_key"],
        userType: json["userType"],
        error: json["error"],
        clickAction: json["click_action"],
      );
}

class Notification {
  Notification({
    this.body,
    this.title,
    this.sound,
  });

  String body;
  String title;
  String sound;

  factory Notification.fromMap(Map json) => Notification(
        body: json["body"],
        title: json["title"],
        sound: json["sound"],
      );
}

/*
Android
onMessage: {notification: {title: New Order, body: You have new order #464654 needs to be delivered to the client.}, data: {userType: agent, id: 464654, error: null, click_action: FLUTTER_NOTIFICATION_CLICK, message: fbkdbgkjd}}

IOS
onMessage: {from: 987978613862, id: 464654, notification: {body: You have new order #464654 needs to be delivered to the client., title: New Order, e: 1, sound2: default, sound: default}, message: nvlkdnjv, collapse_key: com.example.firebaseMessagingDemo, userType: agent, error: null, click_action: FLUTTER_NOTIFICATION_CLICK}

*/
