// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:kmello_app/src/views/inside/school/introduction.dart';
import 'package:kmello_app/utils/buttons.dart';
import 'package:kmello_app/utils/deviders/divider.dart';
import 'package:kmello_app/utils/header.dart';

class SelectProfile extends StatefulWidget {
  const SelectProfile({super.key});

  @override
  State<SelectProfile> createState() => _SelectProfileState();
}

class _SelectProfileState extends State<SelectProfile> {
  bool vendedor_profesional = false;
  bool vendedor_aficionado = false;
  bool referidor = false;

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

  Widget options() {
    return Column(
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
        header("SELECCIONAR", Icons.abc, context: context),
        message(),
        const SizedBox(height: 40),
        profiles()
      ],
    );
  }

  Widget message() => Container(
        width: 250,
        child: Column(children: [
          const SizedBox(height: 15),
          const Text("Elije tu perfil", style: TextStyle(fontSize: 27)),
          const Text("para hacer negocios", style: TextStyle(fontSize: 17)),
          const SizedBox(height: 15),
          divider(false)
        ]),
      );

  Widget profiles() => Container(
        margin: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 70,
                  child: Image.asset("assets/vendedor_profesional.png"),
                ),
                const Expanded(
                    child: Center(
                        child: Text("Vendedor Profesional",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 25)))),
                Checkbox(
                    activeColor: Colors.black,
                    checkColor: Colors.white,
                    value: vendedor_profesional,
                    onChanged: (value) => cbx_vendedor_profesional(value))
              ],
            ),
            const SizedBox(height: 50),
            Row(
              children: [
                SizedBox(
                  height: 70,
                  child: Image.asset("assets/vendedor_aficionado.png"),
                ),
                const Expanded(
                  child: Center(
                    child: Text("Vendedor Aficionado",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25)),
                  ),
                ),
                Checkbox(
                    activeColor: Colors.black,
                    checkColor: Colors.white,
                    value: vendedor_aficionado,
                    onChanged: (value) => cbx_vendedor_aficionado(value))
              ],
            ),
            const SizedBox(height: 50),
            Row(
              children: [
                SizedBox(
                  height: 70,
                  child: Image.asset("assets/test.png"),
                ),
                const Expanded(
                  child: Center(
                    child: Text("Referidor",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25)),
                  ),
                ),
                Checkbox(
                    activeColor: Colors.black,
                    checkColor: Colors.white,
                    value: referidor,
                    onChanged: (value) => cbx_referidor(value))
              ],
            ),
            const SizedBox(height: 70),
            nextButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => Introduction())),
                text: "SIGUIENTE",
                fontSize: 30,
                width: 220)
          ],
        ),
      );

  void cbx_vendedor_profesional(value) {
    setState(() => vendedor_profesional = value);

    if (vendedor_profesional) {
      setState(() {
        vendedor_aficionado = false;
        referidor = false;
      });
    }
  }

  void cbx_vendedor_aficionado(value) {
    setState(() => vendedor_aficionado = value);

    if (vendedor_aficionado) {
      setState(() {
        vendedor_profesional = false;
        referidor = false;
      });
    }
  }

  void cbx_referidor(value) {
    setState(() => referidor = value);

    if (referidor) {
      setState(() {
        vendedor_aficionado = false;
        vendedor_profesional = false;
      });
    }
  }
}
