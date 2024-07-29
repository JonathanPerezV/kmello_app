import 'package:flutter/material.dart';
import 'package:abi_praxis/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:abi_praxis/utils/app_bar.dart';
import 'package:abi_praxis/utils/header.dart';
import 'package:abi_praxis/utils/icons/kmello_icons_icons.dart';

class Puntos extends StatefulWidget {
  const Puntos({super.key});

  @override
  State<Puntos> createState() => _PuntosState();
}

class _PuntosState extends State<Puntos> {
  final sckey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: sckey,
      appBar: MyAppBar(key: sckey).myAppBar(),
      drawer: drawerMenu(context, inicio: false),
      body: options(),
    );
  }

  Widget options() => Column(
        children: [header("Puntos", KmelloIcons.puntos, context: context)],
      );
}
