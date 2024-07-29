import 'package:flutter/material.dart';
import 'package:abi_praxis/utils/buttons.dart';
import 'package:abi_praxis/utils/deviders/divider.dart';
import 'package:abi_praxis/utils/header.dart';

class Aproved extends StatefulWidget {
  String asset;
  int idCourse;
  Aproved({super.key, required this.asset, required this.idCourse});

  @override
  State<Aproved> createState() => _AprovedState();
}

class _AprovedState extends State<Aproved> {
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

  Widget options() => SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: 170,
                height: 60,
                child: Image.asset("assets/abi_praxis_logo.png"),
              ),
            ),
            Container(
              width: double.infinity,
              height: 40,
              alignment: Alignment.center,
              color: const Color.fromRGBO(93, 97, 98, 1),
              child: const Text(
                "ESCUELA DE NEGOCIOS / E-LEARNING",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
            ),
            header(title, null, path: widget.asset, context: context),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: RichText(
                text: const TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                          text: "FELICIDADES! \n",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: "Has aprobado el curso.",
                          style: TextStyle(fontSize: 25))
                    ]),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(45),
                child: Image.asset("assets/school/aprobado_curso.png")),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: const Text(
                "TU PUNTAJE ES 8/10",
                style: TextStyle(fontSize: 25),
              ),
            ),
            const SizedBox(height: 40),
            divider(true),
            const SizedBox(height: 20),
            nextButton(
                onPressed: () {},
                text: "DESCARGAR CERTIFICADO",
                width: 350,
                fontSize: 25)
          ],
        ),
      );
}
