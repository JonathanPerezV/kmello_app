import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

ImageCropper imageCropper = ImageCropper();

Future<String?> recortarImagen(
    {required String path, CropAspectRatio? ratio}) async {
  final recortarImagen = await imageCropper.cropImage(
    sourcePath: path,
    compressQuality: 25,
    maxHeight: 200,
    aspectRatio: ratio,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Recortar imagen',
        toolbarColor: Colors.black,
        toolbarWidgetColor: Colors.white,
        backgroundColor: Colors.white,
        activeControlsWidgetColor: Colors.grey.shade400,
        hideBottomControls: false,
        dimmedLayerColor: const Color.fromRGBO(10, 10, 10, 120),
        showCropGrid: false,
        cropFrameColor: const Color.fromRGBO(10, 10, 10, 120),
        cropGridColor: Colors.red,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: false,
      ),
      IOSUiSettings(
        showCancelConfirmationDialog: true,
        resetAspectRatioEnabled: true,
        hidesNavigationBar: false,
        aspectRatioLockDimensionSwapEnabled: false,
        aspectRatioPickerButtonHidden: false,
        resetButtonHidden: false,
        rotateButtonsHidden: false,
        doneButtonTitle: 'Hecho',
        cancelButtonTitle: 'Cancelar',
        title: 'Recortar imagen',
      ),
    ],
  );
  if (recortarImagen != null) {
    return recortarImagen.path;
  }
  return null;
}
