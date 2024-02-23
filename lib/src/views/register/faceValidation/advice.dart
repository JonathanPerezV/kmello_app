// ignore_for_file: use_build_context_synchronously, unused_local_variable
import 'package:flutter/material.dart';
import 'package:kmello_app/src/models/user_moderl.dart';
import 'package:kmello_app/utils/deviders/divider.dart';
import 'package:kmello_app/utils/icons/kmello_icons_icons.dart';
import 'face_widget.dart';

/// CameraApp is the Main Application.
class FaceAdvice extends StatefulWidget {
  UserModel usuario;
  FaceAdvice({Key? key, required this.usuario}) : super(key: key);

  @override
  State<FaceAdvice> createState() => _FaceAdviceState();
}

class _FaceAdviceState extends State<FaceAdvice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: options(),
    );
  }

  Widget options() => Column(
        children: [
          const SizedBox(height: 40),
          Center(
            child: SizedBox(
              width: 170,
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
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 120,
            color: Colors.black,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: const Center(
              child: Text(
                "Antes de continuar, asegúrese de que su rostro esté dentro del recuadro.",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
          ),
          const SizedBox(height: 60),
          SizedBox(
            width: 220,
            child: Image.asset("assets/ejemplo_face_id.png"),
          ),
          const SizedBox(height: 60),
          button()
        ],
      );
  Widget button() => TextButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => FaceWidget(
                      usuario: widget.usuario,
                      advice: "yes",
                    ))),
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))),
            padding: MaterialStateProperty.all(const EdgeInsets.only(
                left: 75, right: 75, top: 15, bottom: 15)),
            backgroundColor: MaterialStateProperty.all(Colors.black)),
        child: const Text(
          "CONTINUAR",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      );
}
