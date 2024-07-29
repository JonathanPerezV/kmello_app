// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:abi_praxis/utils/alerts/and_alert.dart';
import 'package:abi_praxis/utils/alerts/ios_alert.dart';
import 'package:abi_praxis/utils/flushbar.dart';
import 'package:abi_praxis/utils/selectFile/previsualizacion.dart';
import 'package:permission_handler/permission_handler.dart';

class SeleccionArchivos {
  //todo IMÁGENES
  final iosAlert = IosAlert();
  final andAlert = AndroidAlert();
  ImagePicker imagePicker = ImagePicker();

  //todo DOCUMENTOS
  List<PlatformFile>? _paths;

  Future<String?> selectOrCaptureImage(
      ImageSource imageSource, BuildContext context,
      {CropAspectRatio? radio}) async {
    String? pathImage;

    final status = await Permission.camera.status;

    if (status.isGranted) {
      final imageFile = await imagePicker.pickImage(source: imageSource);
      if (imageFile != null) {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => PreVisualizacion(
                      imageFile.path,
                      radio: radio,
                    ))).then((value) async {
          if (value != null) {
            pathImage = value;
          } else {
            flushBarGlobal(
                context,
                "Acción cancelada.",
                const Icon(
                  Icons.clear,
                  color: Colors.red,
                ));
          }
        });
      } else {
        if (imageSource == ImageSource.camera) {
          flushBarGlobal(
              context,
              "No se tomó la foto",
              const Icon(
                Icons.clear,
                color: Colors.red,
              ));
        } else {
          flushBarGlobal(
              context,
              "No seleccionó ninguna imagen",
              const Icon(
                Icons.clear,
                color: Colors.red,
              ));
        }
      }
    } else {
      Platform.isAndroid
          ? andAlert.alertaPermisoCamaraManual(context)
          : iosAlert.alertaPermisoCamaraManual(context);
    }

    return pathImage;
  }

  Future<String?> openFileExplorer(
      FileType? _pickingType, BuildContext context) async {
    String? pathDoc;
    final status = await Permission.storage.status;
    if (status.isGranted) {
      _paths = (await FilePicker.platform.pickFiles(
              type: _pickingType!,
              allowedExtensions: ['pdf'],
              allowMultiple: false,
              dialogTitle: 'Esoja su archivo'))
          ?.files;

      if (_paths != null) {
        final bytes = _paths![0].size;
        final convert = bytes / (1024 * 1024);
        final size = convert.round();

        if (size < 3) {
          pathDoc = _paths![0].path!;
        } else {
          flushBarGlobal(
              context,
              "El peso límite de un PDF es de 2 mb.",
              const Icon(
                Icons.error,
                color: Colors.red,
              ));
        }
      } else {
        flushBarGlobal(
            context,
            "Acción cancelada.",
            const Icon(
              Icons.clear,
              color: Colors.red,
            ));
      }
    } else {
      Platform.isAndroid
          ? andAlert.alertaPermisoArchivosManual(context)
          : iosAlert.alertaPermisoArchivosManual(context);
    }
    return pathDoc!;
  }
}
