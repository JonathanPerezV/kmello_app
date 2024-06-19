import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';

const fetchBackground = "fetchBackground";

@pragma('vm:entry-point')
void callbackDispatcher() async {
  Workmanager().executeTask((task, inputDate) async {
    if (task == fetchBackground) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      debugPrint(
          "BackgroundFetch/Ubicación actual: ${position.latitude},${position.longitude}");

      return Future.value(true);
    }
    return Future.value(false);
  });
}
