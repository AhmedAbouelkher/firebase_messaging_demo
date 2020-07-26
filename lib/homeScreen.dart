import 'package:firebase_messaging_demo/MockPage.dart';
import 'package:firebase_messaging_demo/firebaseMessaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  final PushNotificationService pushNotificationService =
      PushNotificationService();
  @override
  Widget build(BuildContext context) {
    pushNotificationService.initialise(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("demo"),
        centerTitle: true,
      ),
      body: Center(
        child: RaisedButton(
            child: Text("Go to..."),
            onPressed: () {
              Navigator.push(
                Get.overlayContext,
                platformPageRoute(
                  context: Get.overlayContext,
                  builder: (context) => MockScreen(
                    title: "title",
                  ),
                ),
              );
            }),
      ),
    );
  }
}
