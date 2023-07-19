// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kmello_app/src/views/inside/school/select_profile.dart';
import 'package:kmello_app/utils/buttons.dart';
import 'package:kmello_app/utils/header_form_login.dart';

import '../../../utils/header_login.dart';
import '../../../utils/responsive.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final txtControllerCI = TextEditingController();
  final txtControllerCellPhone = TextEditingController();
  final txtControllerMail = TextEditingController();

  final focusNode = FocusNode();
  final mailFocusNode = FocusNode();

  bool conditions = false;
  bool autorization = false;

  bool loading = false;

  bool obscure = true;

  double opacity = 1000;

  DateTime? autorizationDate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();

        setState(() => opacity = 1000);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        persistentFooterButtons: [
          SizedBox(
              height: 50,
              child: Center(
                  child: Image.asset("assets/byBaadal.png", fit: BoxFit.cover)))
        ],
        body: options(),
      ),
    );
  }

  Widget options() => Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: Responsive.of(context).hp(48),
              width: double.infinity,
              child: Image.asset(
                "assets/imagen_principal.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Color.fromRGBO(255, 255, 255, opacity),
            width: double.infinity,
            height: double.infinity,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: Responsive.of(context).hp((45)),
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: formRegister(),
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

  Widget formRegister() => SingleChildScrollView(
        child: Column(
          children: [
            HeaderFormLogin(
              widthPath: 180,
              path: "assets/kmello_logo.png",
              child: Form(
                key: formKey,
                child: Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    SizedBox(height: 30),
                    TextFormField(
                      onTap: () {
                        setState(() => opacity = 50);
                      },
                      controller: txtControllerCI,
                      validator: (value) =>
                          value!.isEmpty ? "Campo obligatorio *" : null,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        labelText: "Correo electrónico",
                        prefixIcon: Icon(
                          Icons.mail_outline,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: obscure,
                      onTap: () {
                        setState(() => opacity = 50);
                      },
                      focusNode: focusNode,
                      controller: txtControllerCellPhone,
                      //textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () => setState(() => obscure = !obscure),
                            icon: Icon(!obscure
                                ? Icons.remove_red_eye
                                : Icons.remove_red_eye_outlined)),
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        labelText: "Contraseña",
                        prefixIcon: Icon(
                          Icons.password_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    nextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => SelectProfile())),
                        text: "ACCEDER",
                        width: 160,
                        fontSize: 22),
                    SizedBox(height: 30),
                  ]),
                ),
              ),
            ),
            SizedBox(height: 30),
            aditionaslButtons(),
          ],
        ),
      );

  Widget aditionaslButtons() {
    return Column(
      children: [
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, 'forgot_password'),
          child: const Text(
            '¿Olvidó su contraseña?',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¿No posee cuenta?',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              //: EdgeInsets.zero,
              onTap: () => Navigator.pushNamed(context, 'registro'),
              child: Text(
                'Registrese',
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void validateButton() async {}
}
