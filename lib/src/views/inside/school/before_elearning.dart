import 'package:flutter/material.dart';
import 'package:kmello_app/utils/header.dart';

class BeforeElearning extends StatefulWidget {
  String asset;
  int idCourse;
  BeforeElearning({super.key, required this.asset, required this.idCourse});

  @override
  State<BeforeElearning> createState() => _BeforeElearningState();
}

class _BeforeElearningState extends State<BeforeElearning> {
  late String title;

  @override
  void initState() {
    super.initState();
    if (widget.idCourse == 1) {
      title = "CRÉDITOS";
    } else if (widget.idCourse == 2) {
      title = "INTERNET";
    } else if (widget.idCourse == 3) {
      title = "PLANES EXEQUIALES";
    } else if (widget.idCourse == 4) {
      title = "RASTREO SATELITAL";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        SizedBox(
            height: 50,
            child: Center(
                child: Image.asset("assets/byBaadal.png", fit: BoxFit.cover)))
      ],
      body: options(),
    );
  }

  Widget options() => Column(
        children: [
          const SizedBox(height: 30),
          Center(
            child: SizedBox(
              width: 170,
              height: 60,
              child: Image.asset("assets/kmello_logo.png"),
            ),
          ),
          Container(
            width: double.infinity,
            height: 40,
            alignment: Alignment.center,
            color: const Color.fromRGBO(93, 97, 98, 1),
            child: const Text(
              "ESCUELA DE NEGOCIOS",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          header(title, null, path: widget.asset, context: context)
        ],
      );
}
