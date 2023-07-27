import 'package:flutter/material.dart';
import 'package:kmello_app/utils/icons/kmello_icons_icons.dart';
import '../../../../utils/deviders/divider.dart';

Drawer drawerMenu(context) {
  return Drawer(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(25), bottomRight: Radius.circular(25))),
    backgroundColor: Colors.white,
    elevation: 50,
    child: Column(children: [
      const SizedBox(height: 35),
      miBilletera(context),
      creditos(context),
      dividerMenuLateral(),
      infContactenos(context),
      dividerMenuLateral(),
      ListTile(
        onTap: () {
          Navigator.pop(context);
        },
        leading: const Icon(
          KmelloIcons.agenda,
          color: Colors.black,
        ),
        trailing: const Icon(
          Icons.navigate_next_sharp,
          color: Colors.black,
        ),
        title: const Text(
          "Agenda",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      dividerMenuLateral(),
      ListTile(
        onTap: () {
          Navigator.pop(context);
        },
        leading: const Icon(
          KmelloIcons.capacitacion,
          color: Colors.black,
        ),
        trailing: const Icon(
          Icons.navigate_next_sharp,
          color: Colors.black,
        ),
        title: const Text(
          "Capacitación",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      dividerMenuLateral(),
      ListTile(
        onTap: () async {},
        leading: const Icon(
          KmelloIcons.consultar_productos,
          color: Colors.black,
        ),
        trailing: const Icon(
          Icons.navigate_next_sharp,
          color: Colors.black,
        ),
        title: const Text(
          "Consultar Productos",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      dividerMenuLateral(),
      ListTile(
        onTap: () {},
        leading: const Icon(
          Icons.logout,
          color: Colors.black,
        ),
        title: const Text(
          "Cerrar sesión",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      dividerMenuLateral(),
    ]),
  );
}

Widget miBilletera(context) => Column(children: [
      //todo MI BILLETERA
      ListTile(
        onTap: () {},
        leading: const Icon(
          KmelloIcons.mi_perfil,
          color: Colors.black,
        ),
        trailing: const Icon(
          Icons.navigate_next_sharp,
          color: Colors.black,
        ),
        title: const Text(
          "Mi Perfil",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      dividerMenuLateral(),
    ]);

Widget creditos(context) => Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.pop(context);
          },
          leading: const Icon(
            KmelloIcons.estado_de_cuenta,
            color: Colors.black,
          ),
          trailing: const Icon(
            Icons.navigate_next_sharp,
            color: Colors.black,
          ),
          title: const Text(
            "Estado de cuenta",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        dividerMenuLateral(),
      ],
    );

Widget infContactenos(context) => Column(
      children: [
        //todo INFORMACIÓN CONTÁCTENOS
        ListTile(
          onTap: () {
            Navigator.pop(context);
          },
          leading: const Icon(
            KmelloIcons.mis_clientes,
            color: Colors.black,
          ),
          trailing: const Icon(
            Icons.navigate_next_sharp,
            color: Colors.black,
          ),
          title: const Text(
            "Mis Clientes",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
