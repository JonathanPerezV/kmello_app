import 'package:flutter/material.dart';
import 'package:kmello_app/src/views/inside/home/consultar/opciones/prospectos/mis_contactos.dart';
import 'package:kmello_app/src/views/inside/home/consultar/opciones/solicitudes_curso/solicitudes_ingresadas.dart';
import 'package:kmello_app/src/views/inside/home/consultar/opciones/ventas_comisiones/informacion.dart';
import 'package:kmello_app/utils/deviders/divider.dart';
import 'package:kmello_app/utils/icons/kmello_icons_icons.dart';

class ConsultarOpciones extends StatefulWidget {
  const ConsultarOpciones({super.key});

  @override
  State<ConsultarOpciones> createState() => _ConsultarOpcionesState();
}

class _ConsultarOpcionesState extends State<ConsultarOpciones> {
  List optionsList = [
    {
      "name": "Ventas y Comisiones",
      "icon": KmelloIcons.venta_comision,
      "route": const InformacionComisiones()
    },
    {
      "name": "Solicitudes en curso",
      "icon": KmelloIcons.solucitudes,
      "route": const SolicitudesIngresadas()
    },
    {"name": "Mis cobros", "icon": KmelloIcons.cobros, "route": () {}},
    {"name": "Productos", "icon": KmelloIcons.productos, "route": () {}},
    {
      "name": "Prospectos",
      "icon": KmelloIcons.prospectos,
      "route": const MisContactos(),
    },
    {"name": "Agenda", "icon": KmelloIcons.agenda, "route": () {}},
    {"name": "Academia", "icon": KmelloIcons.academia, "route": () {}},
    {"name": "Beneficios", "icon": KmelloIcons.beneficios, "route": () {}},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: optionsList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => optionsList[index]["route"])),
                leading: Icon(optionsList[index]["icon"]),
                title: Text(
                  optionsList[index]["name"],
                  style: const TextStyle(fontSize: 19),
                ),
                trailing: const Icon(Icons.navigate_next),
              ),
              divider(false)
            ],
          );
        });
  }
}
