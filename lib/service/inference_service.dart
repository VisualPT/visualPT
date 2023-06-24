import 'dart:async';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';

class InferenceService {
  static const MethodChannel _channel =
      MethodChannel('com.prod.visualpt/posedetection');

  static Future<dynamic> getPoseDetection(CameraImage image) async {
    try {
      final Uint8List imageData = _cameraImageToBytes(image);
      var args = <String, dynamic>{
        "image": imageData,
      };
      return await _channel.invokeMethod('getPoseDetection', args);
    } catch (e) {
      print('Error during pose detection: $e');
      return [];
    }
  }

  static Uint8List _cameraImageToBytes(CameraImage image) {
    final planes = image.planes;
    final numBytes = planes
        .map((plane) => plane.bytes.lengthInBytes)
        .reduce((value, element) => value + element);
    final bytes = Uint8List(numBytes);
    int offset = 0;
    for (var plane in planes) {
      bytes.setRange(offset, offset + plane.bytes.length, plane.bytes);
      offset += plane.bytes.length;
    }
    return bytes;
  }
}
