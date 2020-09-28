import 'dart:async';
import 'dart:ffi';

import 'package:flutter/services.dart';

class Icloud {
  static const MethodChannel _channel = const MethodChannel('icloud');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> getTextNumber() async {
    String number = await _channel.invokeMethod('getTextNumbber');
    return number;
  }

  static Future<void> upLoadFile() async {
    await _channel.invokeMethod('upLoadFile');
    return;
  }
}
