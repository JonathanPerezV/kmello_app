import 'package:flutter/material.dart';
import 'package:kmello_app/src/views/register/initial_pages/permissions_page.dart';
import 'package:kmello_app/utils/deviders/divider.dart';
import '../../../../utils/buttons.dart';

class InformativePage extends StatefulWidget {
  const InformativePage({super.key});

  @override
  State<InformativePage> createState() => _InformativePageState();
}

class _InformativePageState extends State<InformativePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            "assets/initial_pages/explicando.jpg",
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 55),
            SizedBox(
                width: 160, child: Image.asset("assets/abi_praxis_logo.png")),
            const SizedBox(height: 35),
            SizedBox(width: 210, child: divider(false)),
            const Center(
                child: Text("Bienvenido", style: TextStyle(fontSize: 45))),
            SizedBox(width: 210, child: divider(false)),
            const SizedBox(height: 15),
            const Center(
                child: Text("Gestión Comercial,\nCrédito y Cobranza.",
                    style: TextStyle(fontSize: 20))),
            const SizedBox(height: 15),
            SizedBox(
              height: 45,
              //margin: const EdgeInsets.only(right: 15, bottom: 50),
              child: nextButton(
                  background: Color.fromRGBO(192, 76, 127, 1),
                  radius: BorderRadius.circular(10),
                  onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const PermissionsPage()),
                      (route) => false),
                  text: "Acceder",
                  width: 125,
                  fontSize: 22.5,
                  iconSize: null),
            ),
          ],
        ),
      ]),
    );
  }
}
