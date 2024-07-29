// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:abi_praxis/src/controller/aws/ws_usuario.dart';
import 'package:abi_praxis/src/models/user_moderl.dart';
import 'package:abi_praxis/src/views/register/login.dart';
import 'package:abi_praxis/utils/deviders/divider.dart';
import 'package:abi_praxis/utils/flushbar.dart';
import 'package:abi_praxis/utils/header.dart';
import 'package:abi_praxis/utils/icons/kmello_icons_icons.dart';
import 'package:abi_praxis/utils/loading.dart';

class IdentitySuccess extends StatefulWidget {
  UserModel usuario;
  String pathCi;
  IdentitySuccess({super.key, required this.usuario, required this.pathCi});

  @override
  State<IdentitySuccess> createState() => _IdentitySuccessState();
}

class _IdentitySuccessState extends State<IdentitySuccess> {
  bool loading = false;
  final wsUser = WSUsuario();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: options(),
      );

  Widget options() => Column(
        children: [
          Column(children: [
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: 170,
                height: 60,
                child: Image.asset("assets/abi_praxis_logo.png"),
              ),
            ),
            const SizedBox(height: 10),
            header("Validar identidad", KmelloIcons.validar_identidad,
                context: context),
          ]),
          Expanded(
              child: Stack(
            children: [
              Center(
                  child: Column(
                children: [
                  const SizedBox(height: 60),
                  SizedBox(
                    width: 110,
                    child: Image.asset("assets/validated.png"),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    color: Colors.yellow.shade400,
                    width: double.infinity,
                    child: const Center(
                      child: Text(
                        "IDENTIDAD VÁLIDA",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  button()
                ],
              )),
              if (loading)
                loadingWidget(text: "Creando su usuario, por favor espere...")
            ],
          )),
        ],
      );

  Widget button() => TextButton(
        onPressed: () async {
          setState(() => loading = true);

          debugPrint("CÉDULA PATH: ${widget.pathCi}");
          debugPrint("NOMBRE PERSONA: ${widget.usuario.nombres}");

          final data = await wsUser.insertarUsuario(widget.usuario);

          if (data == "si") {
            Navigator.push(context,
                MaterialPageRoute(builder: (builder) => const LoginPage()));
            flushBarGlobal(
                context,
                "Usuario creado correctamente",
                const Icon(
                  Icons.check,
                  color: Colors.green,
                ));
          } else {
            flushBarGlobal(
                context,
                "No se creo el usuario, intentelo más tarde...",
                const Icon(
                  Icons.check,
                  color: Colors.green,
                ));
          }

          setState(() => loading = false);
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))),
            padding: MaterialStateProperty.all(const EdgeInsets.only(
                left: 75, right: 75, top: 15, bottom: 15)),
            backgroundColor: MaterialStateProperty.all(Colors.black)),
        child: const Text(
          "ENTENDIDO",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      );
}
