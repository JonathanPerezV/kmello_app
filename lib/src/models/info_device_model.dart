import 'package:intl/intl.dart';

class DeviceModel {
  DeviceModel({
    required this.model,
    required this.name,
    required this.idDevice,
  });

  String idDevice;
  String name;
  String model;

  Map<String, dynamic> toJson() => {
        "id_device": idDevice,
        "model_device": model,
        "fecha_registro": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "hora_registro": DateFormat.Hms().format(DateTime.now())
      };
}
