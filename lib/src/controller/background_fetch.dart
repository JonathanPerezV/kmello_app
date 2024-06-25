// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';

const fetchBackground = "current_location";

@pragma('vm:entry-point')
void callbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case "current_location":
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        print(
            "BackgroundFetch/Ubicación actual: ${position.latitude},${position.longitude}");
        break;
      default:
    }
    return Future.value(true);
  });
}
