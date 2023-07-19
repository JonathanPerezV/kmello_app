import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

import '../src/models/info_device_model.dart';

class InfoDevice {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Future<DeviceModel> getDeviceModel() async {
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;

      debugPrint(""" 
        board: ${androidInfo.board} 
        bootloader: ${androidInfo.bootloader}
        device: ${androidInfo.device}
        manufacturer: ${androidInfo.manufacturer}
        product: ${androidInfo.product}
        """);

      return DeviceModel(
        idDevice: androidInfo.id,
        model: androidInfo.model,
        name: "Android",
      );
    } else {
      final iosInfo = await deviceInfo.iosInfo;

      debugPrint("""
        id: ${iosInfo.identifierForVendor}
        model: ${iosInfo.model}
        name: ${iosInfo.name}
        machine: ${iosInfo.utsname.machine}
        system name: ${iosInfo.systemName}
        """);

      return DeviceModel(
        idDevice: iosInfo.identifierForVendor!,
        model: iosInfo.model ?? "",
        name: iosInfo.name ?? "",
      );
    }
  }
}
