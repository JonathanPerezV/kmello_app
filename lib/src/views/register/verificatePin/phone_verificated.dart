import 'package:flutter/material.dart';
import 'package:kmello_app/src/views/register/recognition/identifcation/upload_identification.dart';
import 'package:kmello_app/utils/buttons.dart';
import 'package:kmello_app/utils/icons/kmello_icons_icons.dart';

import '../../../../utils/deviders/divider.dart';

class PhoneVerificated extends StatefulWidget {
  const PhoneVerificated({super.key});

  @override
  State<PhoneVerificated> createState() => _PhoneVerificatedState();
}

class _PhoneVerificatedState extends State<PhoneVerificated> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: options(),
        persistentFooterButtons: [
          SizedBox(
              height: 50,
              child: Center(
                  child: Image.asset("assets/byBaadal.png", fit: BoxFit.cover)))
        ],
      );

  Widget options() => SingleChildScrollView(
        child: Column(
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
            divider(true),
            Row(
              children: [
                const SizedBox(width: 10),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios)),
                const Row(children: [
                  Icon(KmelloIcons.codigo_de_verifiacion),
                  SizedBox(width: 5),
                  Text(
                    "Código de verificación",
                    style: TextStyle(fontSize: 23.5),
                  )
                ])
              ],
            ),
            divider(true),
            const SizedBox(height: 60),
            Center(
                child: Column(
              children: [
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
                      "TELÉFONO VERIFICADO",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 70),
                button()
              ],
            ))
          ],
        ),
      );

  Widget button() => nextButton(
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (builder) => const UploadCI())),
      width: 250,
      text: "CONTINUAR",
      fontSize: 25);
}
