import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:abi_praxis/src/controller/aws/ws_coordenadas.dart';
import 'package:abi_praxis/src/models/coordenadas_model.dart';

import 'preferences/user_preferences.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
      iosConfiguration: IosConfiguration(
          autoStart: true,
          onForeground: onStart,
          onBackground: onBackGroundIos),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
      ));
}

@pragma('vm:entry-point')
Future<bool> onBackGroundIos(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  DartPluginRegistrant.ensureInitialized();

  Timer.periodic(const Duration(minutes: 10), (timer) async {
    if (DateTime.now().hour > 09 && DateTime.now().hour < 23) {
      await logicToServer(service, enable: true, cancel: false);
    } else {
      await logicToServer(service, enable: false, cancel: false);
    }
  });

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  await dotenv.load(fileName: '.env');
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

  Timer.periodic(const Duration(minutes: 10), (timer) async {
    if (DateTime.now().hour > 09 && DateTime.now().hour < 23) {
      await logicToServer(service, enable: true, cancel: false);
    } else {
      await logicToServer(service, enable: false, cancel: false);
    }
  });
}

//Future<void> cancelProcess()

Future<void> logicToServer(ServiceInstance service,
    {bool? enable, required bool cancel}) async {
  final wsCoor = WsCoordenadas();
  final userpfrc = UserPreferences();
  if (cancel) {
  } else {
    if (enable != null && enable) {
      final id = await userpfrc.getIdPerson();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          service.setForegroundNotificationInfo(
              title: "Actualizando...",
              content: "Las coordenadas se están enviando");

          final res = await wsCoor.insertarCoordenada(CoordenadasModel(
              idUser: id,
              latitud: position.latitude.toString(),
              longitud: position.longitude.toString()));

          print("COORDENADAS: $res");

          service.setForegroundNotificationInfo(
              title: "Actualizado",
              content:
                  "Ubicación actualizada: ${position.latitude},${position.longitude}");
        }
      } else {
        await iosLogic(id, position);
      }
      debugPrint(
          "envío de latitud y longitud: ${position.latitude},${position.longitude}");
      service.invoke('update');
    } else {
      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
            title: "Hasta mañana",
            content: "Es momento de descansar, nos vemos mañana.");
      }
    }
  }
}

Future<void> iosLogic(int id, Position position) async {
  final wsCoor = WsCoordenadas();
  final res = await wsCoor.insertarCoordenada(CoordenadasModel(
      idUser: id,
      latitud: position.latitude.toString(),
      longitud: position.longitude.toString()));

  print("COORDENADAS: $res");
}
