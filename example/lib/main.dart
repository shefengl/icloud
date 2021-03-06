import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:icloud/icloud.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String test;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Icloud.platformVersion;
      test = await Icloud.getTextNumber();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = test;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          children: [
            RaisedButton(
              onPressed: () async {
                bool isAvailable = await Icloud.isIcloudAvailable();
                if (isAvailable) {
                  await Icloud.upLoadFile(
                      dir: 'myName',
                      subDir: 'walletId',
                      fileName: 'privateKey',
                      privateKey: 'dkdkdkadfadfeafaefaefaf');
                } else {}
                print(isAvailable);
              },
              child: Text('uplaod file'),
              color: Colors.red,
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: () async {
                if (await Icloud.isIcloudAvailable()) {
                  String value = await Icloud.readFile(
                      dir: 'myName', subDir: 'walletId', fileName: 'privateKey');
                  print(value);
                }
              },
              child: Text('read from icloud'),
              color: Colors.green,
            ),
            Text('Running on: $_platformVersion\n'),
          ],
        )),
      ),
    );
  }
}
