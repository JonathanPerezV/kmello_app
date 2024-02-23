import 'package:flutter/material.dart';
import 'package:kmello_app/src/controller/app_preferences.dart';
import 'package:kmello_app/src/views/register/login.dart';
import 'package:kmello_app/utils/buttons.dart';
import 'package:kmello_app/utils/header_login.dart';
import 'package:kmello_app/utils/responsive.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: options(),
    );
  }

  Widget options() {
    final rsp = Responsive.of(context);
    return Column(
      children: [
        customHeaderLogin("assets/kmello_logo_white.png"),
        Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 5, right: 5),
            height: rsp.hp(45),
            child: Image.asset("assets/initial_pages/bienvenida.png")),
        SizedBox(
          width: 320,
          child: RichText(
              textAlign: TextAlign.justify,
              text: const TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                        text: "Bienvenido",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            fontStyle: FontStyle.italic)),
                    TextSpan(
                        text: " a la app para Socios Vendedores y Referidores.",
                        style: TextStyle(fontSize: 25))
                  ])),
        ),
        SizedBox(height: rsp.hp(5)),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.only(right: 15),
            child: nextButton(
                onPressed: () async {
                  final appPreferences = AppPreferences();

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const LoginPage()),
                      (route) => false);

                  await appPreferences.saveWelcomePage(true);
                },
                text: "Continuar",
                width: 260,
                fontSize: 26.5,
                iconSize: 30),
          ),
        )
      ],
    );
  }
}
