// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kmello_app/src/views/register/recognition/face/take_photo_face.dart';
import '../../../../../utils/deviders/divider.dart';
import '../../../../../utils/flushbar.dart';
import 'face_advice.dart';
import 'identity_sucess.dart';

class FaceValidation extends StatefulWidget {
  String pathCI;
  FaceValidation({super.key, required this.pathCI});

  @override
  State<FaceValidation> createState() => _FaceValidationState();
}

class _FaceValidationState extends State<FaceValidation> {
  String pathFoto = "";
  bool loading = false;
  //final awsRecog = AmazonRecognitionUpload();

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
                    width: 150,
                    height: 60,
                    child: Image.asset("assets/kmello_logo.png"),
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
                      Icon(Icons.abc),
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
                  "Tomar foto facial",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                pathFoto.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final value = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          const FaceAdvice()));

                              if (value != null) {
                                setState(() => pathFoto = value);
                              }
                            },
                            child: SizedBox(
                              width: 200,
                              child: Image.asset("assets/test.png"),
                            ),
                          ),
                          const SizedBox(height: 35),
                          Container(
                            margin: const EdgeInsets.only(left: 75, right: 75),
                            child: const Text(
                              "Pulse sobre el ícono de la cámara para tomar la foto.",
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
                            child: Container(
                              color: Colors.black,
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
                            onPressed: () async => await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => FaceWidget(
                                          advice: null,
                                        ))).then((value) {
                              if (value != null) {
                                setState(() => pathFoto = value);
                              }
                            }),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25))),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.only(
                                      left: 75,
                                      right: 75,
                                      top: 15,
                                      bottom: 15)),
                            ),
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
          if (loading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color.fromRGBO(0, 0, 0, 80),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                  backgroundColor: Colors.grey,
                ),
              ),
            )
        ],
      );

  Widget button() => TextButton(
        onPressed: () async {
          if (pathFoto.isNotEmpty) {
            setState(() => loading = true);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => const IdentitySuccess()));

            setState(() => loading = false);

            /*final res = await awsRecog.amazonRecognition(File(pathFoto));

            setState(() => loading = false);

            if (res == "ok") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const IdentitySuccess()));
            } else if (res == "repeat") {
              flushBarGlobal(
                  context,
                  "No se pudo reconocer su rostro, por favor intente subir nuevamente su cédula y procure tomarse bien la foto.",
                  const Icon(Icons.warning, color: Colors.yellow),
                  seconds: 4);
            } else {
              flushBarGlobal(
                  context,
                  "Ocurrió un error, intentelo más tarde.",
                  const Icon(
                    Icons.error,
                    color: Colors.red,
                  ));
            }*/
          } else {
            flushBarGlobal(
                context,
                "Tome la foto antes de continuar.",
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
                left: 75, right: 75, top: 15, bottom: 15)),
            backgroundColor: MaterialStateProperty.all(
                pathFoto.isEmpty ? Colors.grey : Colors.black)),
        child: const Text(
          "Siguiente",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      );
}
