import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
      iosConfiguration: IosConfiguration(
          autoStart: true,
          onForeground: onStart,
          onBackground: onBackGroundIos),
      androidConfiguration:
          AndroidConfiguration(onStart: onStart, isForegroundMode: true));
}

@pragma('vm:entry-point')
Future<bool> onBackGroundIos(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  await logicToServer(service);
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(minutes: 1), (timer) async {
    if (DateTime.now().hour > 09) {
      await logicToServer(service);
    } else {
      service.stopSelf();
    }
  });
}

Future<void> logicToServer(ServiceInstance service) async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  if (service is AndroidServiceInstance) {
    if (await service.isForegroundService()) {
      service.setForegroundNotificationInfo(
          title: "Estado", content: "Actualizando ubicación...");

      await Future.delayed(const Duration(seconds: 5));

      service.setForegroundNotificationInfo(
          title: "Estado", content: "Ubicación actualizada");
      debugPrint(
          "envío de latitud y longitud: ${position.latitude},${position.longitude}");
    }
  } else {
    debugPrint(
        "envío de latitud y longitud: ${position.latitude},${position.longitude}");
  }
  debugPrint(
      "envío de latitud y longitud: ${position.latitude},${position.longitude}");
  service.invoke('update');
}
