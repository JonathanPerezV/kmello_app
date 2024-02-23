// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kmello_app/src/controller/app_preferences.dart';
import 'package:kmello_app/src/controller/aws/ws_usuario.dart';
import 'package:kmello_app/src/views/inside/home/home_page.dart';
import 'package:kmello_app/src/views/inside/school/select_profile.dart';
import 'package:kmello_app/utils/alerts/and_alert.dart';
import 'package:kmello_app/utils/alerts/ios_alert.dart';
import 'package:kmello_app/utils/buttons.dart';
import 'package:kmello_app/utils/header_form_login.dart';
import 'package:kmello_app/utils/icons/kmello_icons_icons.dart';
import 'package:kmello_app/utils/loading.dart';

import '../../../utils/header_login.dart';
import '../../../utils/responsive.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final wsUser = WSUsuario();

  final alertIos = IosAlert();
  final alertAnd = AndroidAlert();

  final txtControllerCI = TextEditingController();
  final txtControllerPassword = TextEditingController();
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
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();

          setState(() => opacity = 1000);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: options(),
        ),
      ),
    );
  }

  Widget options() => Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: Responsive.of(context).hp(45),
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
              height: Responsive.of(context).hp((55)),
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: formRegister(),
            ),
          ),
          if (loading) loadingWidget(text: "Cargando...")
        ],
      );

  Widget formRegister() => Column(
        children: [
          HeaderFormLogin(
            widthPath: 180,
            path: "assets/kmello_logo.png",
            child: Form(
              key: formKey,
              child: Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const SizedBox(height: 10),
                  TextFormField(
                    onTap: () {
                      setState(() => opacity = 50);
                    },
                    controller: txtControllerCI,
                    validator: (value) =>
                        value!.isEmpty ? "Campo obligatorio *" : null,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: false, signed: false),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      labelText: "Número de cédula",
                      prefixIcon: Icon(
                        Icons.person_pin,
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
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        return null;
                      } else {
                        return "Campo obligatorio *";
                      }
                    },
                    focusNode: focusNode,
                    controller: txtControllerPassword,
                    //textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () => setState(() => obscure = !obscure),
                          icon: Icon(!obscure
                              ? Icons.remove_red_eye
                              : Icons.remove_red_eye_outlined)),
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      labelText: "Contraseña",
                      prefixIcon: const Icon(
                        Icons.password_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  nextButton(
                      onPressed: validateButton,
                      text: "ACCEDER",
                      width: 160,
                      fontSize: 22),
                  const SizedBox(height: 10),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 15),
          aditionaslButtons(),
          //const SizedBox(height: 10),
        ],
      );

  Widget aditionaslButtons() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, 'forgot_password'),
          child: const Text(
            '¿Olvidó su contraseña?',
            style: TextStyle(
              fontSize: 12,
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
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              //: EdgeInsets.zero,
              onTap: () => Navigator.pushNamed(context, 'registro'),
              child: const Text(
                'Regístrese',
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void validateButton() async {
    final appPreferences = AppPreferences();

    if (formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      setState(() => loading = true);

      final data = await wsUser.autenticarUser(
          identification: txtControllerCI.text,
          password: txtControllerPassword.text);

      if (data == "ok") {
        await appPreferences.saveLoginPage(true);

        if (await appPreferences.getAcademyPage()) {
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => const HomePage()));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => const SelectProfile()));
        }
      } else {
        final separate = data.split(",");

        final title = separate[0];
        final error = separate[1];

        Platform.isAndroid
            ? alertAnd.errorLogin(context, title, error)
            : alertIos.errorLogin(context, title, error);
      }

      setState(() => loading = false);
    } else {
      return;
    }
  }
}
