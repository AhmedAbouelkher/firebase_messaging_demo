import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

class MockScreen extends StatelessWidget {
  final String title;
  const MockScreen({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateTime.now().millisecond.toString()),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.headline4,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
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
            )
          ],
        ),
      ),
    );
  }
}
