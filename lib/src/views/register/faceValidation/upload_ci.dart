// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmello_app/src/controller/aws/recognition/upload_image_s3.dart';
import 'package:kmello_app/src/models/user_moderl.dart';
import 'package:kmello_app/src/views/register/faceValidation/face_validation.dart';
import 'package:kmello_app/utils/cut_image.dart';
import 'package:kmello_app/utils/deviders/divider.dart';
import 'package:kmello_app/utils/flushbar.dart';
import 'package:kmello_app/utils/icons/kmello_icons_icons.dart';
import 'package:kmello_app/utils/loading.dart';

class UploadCI extends StatefulWidget {
  UserModel usuario;
  UploadCI({super.key, required this.usuario});

  @override
  State<UploadCI> createState() => _UploadCIState();
}

class _UploadCIState extends State<UploadCI> {
  String pathFoto = "";
  final imagePicker = ImagePicker();
  final uploadImage = UploadImageS3();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: options(),
    );
  }

  Widget options() => Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Center(
                  child: SizedBox(
                    width: 170,
                    height: 60,
                    child: Image.asset("assets/abi_praxis_logo.png"),
                  ),
                ),
                const SizedBox(height: 10),
                divider(true),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios)),
                    const Row(children: [
                      Icon(KmelloIcons.validar_identidad),
                      SizedBox(width: 5),
                      Text(
                        "Validar identidad",
                        style: TextStyle(fontSize: 23.5),
                      )
                    ])
                  ],
                ),
                divider(true),
                const SizedBox(height: 60),
                const Text(
                  "Foto de la cédula parte frontal",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 60),
                pathFoto.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: selectOption,
                            child: SizedBox(
                              width: 200,
                              child: Image.asset("assets/camara_marco.png"),
                            ),
                          ),
                          const SizedBox(height: 35),
                          Container(
                            margin: const EdgeInsets.only(left: 75, right: 75),
                            child: const Text(
                              "Pulse sobre el ícono de la cámara para tomar o subir la foto.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: SizedBox(
                              //color: Colors.black,
                              width: 260,
                              height: 260,
                              child: Image.file(
                                File(pathFoto),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: selectOption,
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25))),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.only(
                                        left: 75,
                                        right: 75,
                                        top: 15,
                                        bottom: 15))),
                            /* backgroundColor:
                                    MaterialStateProperty.all(Colors.black)),*/
                            child: Column(
                              children: [
                                const Text(
                                  "INTENTAR DE NUEVO",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Container(
                                  width: 175,
                                  height: 1,
                                  color: Colors.lightBlue,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 10),
                if (pathFoto.isNotEmpty) button()
              ],
            ),
          ),
          if (loading) loadingWidget(text: "Cargando imagen...")
        ],
      );

  Widget button() => SizedBox(
        width: 225,
        child: TextButton(
          onPressed: () async {
            if (pathFoto.isNotEmpty) {
              setState(() => loading = true);

              final res = await uploadImage.uploadImage(File(pathFoto), context,
                  bucket: "kmello-dev", cedula: widget.usuario.cedula);

              setState(() => loading = false);

              if (res.contains("https")) {
                final newPath =
                    res.split("https://kmello-dev.s3.amazonaws.com");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => FaceValidation(
                              usuario: widget.usuario,
                              pathCI: newPath[1],
                            )));
              } else {
                flushBarGlobal(
                    context,
                    "Ocurrió un error, intentelo de nuevo más tarde.",
                    const Icon(
                      Icons.error,
                      color: Colors.red,
                    ));
              }
            } else {
              flushBarGlobal(
                  context,
                  "Seleccione la imagen de la cédula para continuar.",
                  const Icon(
                    Icons.error,
                    color: Colors.red,
                  ));
            }
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25))),
              padding: MaterialStateProperty.all(const EdgeInsets.only(
                  left: 55, right: 55, top: 15, bottom: 15)),
              backgroundColor: MaterialStateProperty.all(
                  pathFoto.isEmpty ? Colors.grey : Colors.black)),
          child: const Text(
            "Siguiente",
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
      );

  void selectOption() => showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      context: context,
      builder: (builder) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 60,
              height: 2,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),
            const Text(
              "Seleccione una opción",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => selectOrTakePhoto(ImageSource.gallery),
                  child: const Icon(Icons.photo_album_outlined, size: 70),
                ),
                Container(color: Colors.grey, width: 2, height: 80),
                GestureDetector(
                  onTap: () => selectOrTakePhoto(ImageSource.camera),
                  child: const Icon(Icons.camera_alt_outlined, size: 70),
                )
              ],
            ),
            const SizedBox(height: 40),
          ],
        );
      });

  void selectOrTakePhoto(ImageSource source) async {
    Navigator.pop(context);
//    final status = await Permission.camera.status;

    //if (status.isGranted) {
    final imageFile = await imagePicker.pickImage(source: source);

    if (imageFile != null) {
      //if (source == ImageSource.camera) {
      await recortarImagen(
              path: imageFile.path,
              ratio: const CropAspectRatio(ratioX: 148.0, ratioY: 95.0))
          .then((value) {
        if (value != null) {
          setState(() => pathFoto = value);
        } else {
          flushBarGlobal(
              context,
              "Acción cancelada",
              const Icon(
                Icons.cancel,
                color: Colors.red,
              ));
        }
      });
    }
  }
}
