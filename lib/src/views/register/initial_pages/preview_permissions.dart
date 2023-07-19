import 'package:flutter/material.dart';
import 'package:kmello_app/src/views/register/initial_pages/permissions_page.dart';

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
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            "assets/initial_pages/explicando.jpg",
            fit: BoxFit.cover,
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            height: 45,
            margin: const EdgeInsets.only(right: 15, bottom: 50),
            child: nextButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const PermissionsPage()),
                    (route) => false),
                text: "Continuar",
                width: 260,
                fontSize: 26.5,
                iconSize: 30),
          ),
        ),
      ]),
    );
  }
}
