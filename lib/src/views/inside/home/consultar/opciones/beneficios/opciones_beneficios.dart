import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:abi_praxis/src/views/inside/home/consultar/opciones/beneficios/mi_plan.dart';
import 'package:abi_praxis/src/views/inside/home/consultar/opciones/beneficios/puntos.dart';
import 'package:abi_praxis/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:abi_praxis/utils/app_bar.dart';
import 'package:abi_praxis/utils/deviders/divider.dart';
import 'package:abi_praxis/utils/footer.dart';
import 'package:abi_praxis/utils/header.dart';
import 'package:abi_praxis/utils/icons/kmello_icons_icons.dart';

class OpcionesBeneficios extends StatefulWidget {
  const OpcionesBeneficios({super.key});

  @override
  State<OpcionesBeneficios> createState() => _OpcionesBeneficiosState();
}

class _OpcionesBeneficiosState extends State<OpcionesBeneficios> {
  final sckey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: sckey,
      appBar: MyAppBar(key: sckey).myAppBar(),
      drawer: drawerMenu(context),
      body: options(),
    );
  }

  Widget options() => Column(
        children: [
          header("Beneficios", KmelloIcons.beneficios, context: context),
          Expanded(
            child: opciones(),
          ),
          footerBaadal()
        ],
      );

  Widget opciones() => Column(
        children: [
          ListTile(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (builder) => const MiPlan())),
            leading: const Icon(KmelloIcons.plan),
            title: const Text("Mi plan"),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),
          /*divider(false),
          ListTile(
            onTap: () {},
            leading: const Icon(KmelloIcons.club_beneficios),
            title: const Text("Club de beneficios"),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),
          divider(false),
          ListTile(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (builder) => const Puntos())),
            leading: const Icon(KmelloIcons.puntos),
            title: const Text("Puntos"),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),*/
          divider(false)
        ],
      );
}
