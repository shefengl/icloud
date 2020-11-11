import 'dart:async';

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

  static Future<void> upLoadFile(
      {String dir, String subDir, String fileName, String privateKey}) async {
    await _channel.invokeMethod('upLoadFile', [dir, subDir, fileName, privateKey]);
    return;
  }

  static Future<bool> isIcloudAvailable() async {
    bool isAvailable = await _channel.invokeMethod('isIcloudAvailable');
    return isAvailable;
  }

  static Future<String> readFile({String dir, String subDir, String fileName}) async {
    String value = await _channel.invokeMethod('readFile', [dir, subDir, fileName]);
    return value;
  }

  static Future<void> checkIcloudStatus() async {
    await _channel.invokeMethod('checkIcloudUserStatus');
    return;
  }

  static Future<bool> checkIfUploaded({String dir, String subDir, String fileName}) async {
    bool isUploaded = await _channel.invokeMethod('checkIfUploaded', [dir, subDir, fileName]);
    return isUploaded;
  }

  static Future<bool> checkIfDownloaded({String dir, String subDir, String fileName}) async {
    bool isUploaded = await _channel.invokeMethod('checkIfDownloaded', [dir, subDir, fileName]);
    return isUploaded;
  }

  static Future<bool> downloadFile({String dir, String subDir, String fileName}) async {
    bool isUploaded = await _channel.invokeMethod('downloadFile', [dir, subDir, fileName]);
    return isUploaded;
  }
}
