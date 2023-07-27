import 'package:flutter/material.dart';
import 'package:kmello_app/utils/icons/kmello_icons_icons.dart';
import '../../../../../utils/deviders/divider.dart';

class IdentitySuccess extends StatefulWidget {
  const IdentitySuccess({super.key});

  @override
  State<IdentitySuccess> createState() => _IdentitySuccessState();
}

class _IdentitySuccessState extends State<IdentitySuccess> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: options(),
      );

  Widget options() => SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: 100,
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
                  Icon(KmelloIcons.validar_identidad),
                  SizedBox(width: 5),
                  Text(
                    "Validar identidad",
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
                      "IDENTIDAD VÁLIDA",
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

  Widget button() => TextButton(
        onPressed: () =>
            {} /*Navigator.push(context,
            MaterialPageRoute(builder: (builder) => const FinalValidation()))*/
        ,
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))),
            padding: MaterialStateProperty.all(const EdgeInsets.only(
                left: 75, right: 75, top: 15, bottom: 15)),
            backgroundColor: MaterialStateProperty.all(Colors.black)),
        child: const Text(
          "CONTINUAR",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      );
}
