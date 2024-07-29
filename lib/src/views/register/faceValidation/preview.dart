// ignore_for_file: deprecated_member_use, must_be_immutable
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:abi_praxis/utils/deviders/divider.dart';
import 'package:abi_praxis/utils/flushbar.dart';
import 'package:abi_praxis/utils/icons/kmello_icons_icons.dart';

import '../../../../utils/cut_image.dart';

class Preview extends StatefulWidget {
  String? path;
  CropAspectRatio? radio;
  Preview(this.path, {Key? key, this.radio}) : super(key: key);

  @override
  State<Preview> createState() => PreviewState();
}

class PreviewState extends State<Preview> {
  final key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: 100,
                child: Image.asset("assets/logo_abi_t.png"),
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
                    "Imagen cargada",
                    style: TextStyle(fontSize: 23.5),
                  )
                ])
              ],
            ),
            divider(true),
            Expanded(
              child: Image.file(
                File(widget.path!),
                fit: BoxFit.contain,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  onPressed: () async => await recortarImagen(
                          path: widget.path!, ratio: widget.radio)
                      .then((value) {
                    if (value != null) {
                      setState(() => value = widget.path);
                    } else {
                      flushBarGlobal(
                          context,
                          "Acción cancelada por el usuario.",
                          const Icon(
                            Icons.warning,
                            color: Colors.yellow,
                          ));
                    }
                  }),
                  child: const Text(
                    'Recortar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  onPressed: () => Navigator.pop(context, widget.path!),
                  child: const Text(
                    'Guardar',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            const SizedBox(height: 40),
          ],
        ));
  }
}
