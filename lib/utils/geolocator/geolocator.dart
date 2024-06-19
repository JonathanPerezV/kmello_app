import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kmello_app/utils/flushbar.dart';

class GeolocatorConfig {
  Future<bool> geolocatorEnable() async {
    final res = await Geolocator.isLocationServiceEnabled();

    if (res) {
      return true;
    } else {
      return false;
    }
  }

  Future<LocationPermission?> requestPermission(context) async {
    if (await geolocatorEnable()) {
      var permission = await Geolocator.checkPermission();

      switch (permission) {
        case LocationPermission.denied:
          flushBarGlobal(
              context, "Permiso denegado", const Icon(Icons.warning));
          await Geolocator.requestPermission();
          break;
        case LocationPermission.deniedForever:
          flushBarGlobal(
              context,
              "El permiso ha sido denegado, diríjase a la configuración de su dispositivo y actívela manualmente",
              const Icon(Icons.warning));
          break;
        default:
      }

      return await Geolocator.checkPermission();
    } else {
      flushBarGlobal(
          context, "La ubicación está desacitvada", const Icon(Icons.error));
    }
  }
}
