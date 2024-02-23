// ignore_for_file: non_constant_identifier_names, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:kmello_app/src/controller/aws/ws_usuario.dart';
import 'package:kmello_app/src/views/inside/school/introduction.dart';
import 'package:kmello_app/src/views/inside/school/what_sell/view_category.dart';
import 'package:kmello_app/utils/buttons.dart';
import 'package:kmello_app/utils/deviders/divider.dart';
import 'package:kmello_app/utils/flushbar.dart';
import 'package:kmello_app/utils/footer.dart';
import 'package:kmello_app/utils/header.dart';
import 'package:kmello_app/utils/icons/kmello_icons_icons.dart';
import 'package:kmello_app/utils/loading.dart';

class SelectProfile extends StatefulWidget {
  const SelectProfile({super.key});

  @override
  State<SelectProfile> createState() => _SelectProfileState();
}

class _SelectProfileState extends State<SelectProfile> {
  bool vendedor_profesional = false;
  bool vendedor_aficionado = false;
  bool referidor = false;

  bool loading = false;

  int idProfile = 0;

  String descripcion =
      "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum ";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: options(),
      ),
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
        header("Terminar proceso de registro", KmelloIcons.validar_identidad,
            context: context, back: true),
        Expanded(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          message(),
                          const SizedBox(height: 40),
                          profiles(),
                        ],
                      ),
                    ),
                  ),
                  footerBaadal()
                ],
              ),
              if (loading) loadingWidget(text: "Cargando...")
            ],
          ),
        ),
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
                const Icon(
                  KmelloIcons.vendedor_profesional,
                  size: 70,
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
                    onChanged: (value) => cbx_vendedor_profesional(value)),
                IconButton(
                    onPressed: () => showInformationModal(
                        titulo: "Vendedor profesional",
                        image: "assets/vendedor/vendedor_profesional.png",
                        descripcion: descripcion),
                    icon: const Icon(Icons.info))
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(
                  KmelloIcons.vendedor_aficionado,
                  size: 70,
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
                    onChanged: (value) => cbx_vendedor_aficionado(value)),
                IconButton(
                    onPressed: () => showInformationModal(
                        titulo: "Vendedor aficionado",
                        image: "assets/vendedor/vendedor_afisionado.png",
                        descripcion: descripcion),
                    icon: const Icon(Icons.info))
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(
                  KmelloIcons.referidor,
                  size: 70,
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
                    onChanged: (value) => cbx_referidor(value)),
                IconButton(
                    onPressed: () => showInformationModal(
                        titulo: "Referidor",
                        image: "assets/vendedor/referidor.png",
                        descripcion: descripcion),
                    icon: const Icon(Icons.info))
              ],
            ),
            const SizedBox(height: 20),
            nextButton(
                onPressed: () => idProfile == 0 ? null : updateStatus(),
                text: "SIGUIENTE",
                fontSize: 30,
                background: idProfile == 0 ? Colors.grey : null,
                width: 220)
          ],
        ),
      );

  void updateStatus() async {
    final wsUser = WSUsuario();

    setState(() => loading = true);

    final data = await wsUser.insertarPerfil(idProfile);

    if (data == "si") {
      Navigator.push(context,
          MaterialPageRoute(builder: (builder) => const ViewCategory()));
    } else {
      flushBarGlobal(
          context,
          "Ocurrió un error, inténtelo de nuevo más tarde.",
          const Icon(
            Icons.error,
            color: Colors.red,
          ));
    }

    setState(() => loading = false);
  }

  void cbx_vendedor_profesional(value) {
    setState(() => vendedor_profesional = value);
    setState(() => idProfile = 1);

    if (vendedor_profesional) {
      setState(() {
        vendedor_aficionado = false;
        referidor = false;
      });
    }
    if (!vendedor_profesional && !vendedor_aficionado && !referidor) {
      setState(() => idProfile = 0);
    }
  }

  void cbx_vendedor_aficionado(value) {
    setState(() => vendedor_aficionado = value);
    setState(() => idProfile = 2);

    if (vendedor_aficionado) {
      setState(() {
        vendedor_profesional = false;
        referidor = false;
      });
    }
    if (!vendedor_profesional && !vendedor_aficionado && !referidor) {
      setState(() => idProfile = 0);
    }
  }

  void cbx_referidor(value) {
    setState(() => referidor = value);
    setState(() => idProfile = 3);

    if (referidor) {
      setState(() {
        vendedor_aficionado = false;
        vendedor_profesional = false;
      });
    }
    if (!vendedor_profesional && !vendedor_aficionado && !referidor) {
      setState(() => idProfile = 0);
    }
  }

  void showInformationModal(
      {required String titulo,
      required String image,
      required String descripcion}) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              titulo,
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  child: Image.asset(image),
                ),
                SizedBox(height: 5),
                Text(descripcion)
              ],
            ),
            actions: [
              Center(
                child: nextButton(
                  width: 150,
                  onPressed: () => Navigator.pop(context),
                  text: "Entendido",
                ),
              )
            ],
          );
        });
  }
}
