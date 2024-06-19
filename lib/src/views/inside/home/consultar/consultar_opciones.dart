import 'package:flutter/material.dart';
import 'package:kmello_app/src/views/inside/home/consultar/opciones/agenda/agenda.dart';
import 'package:kmello_app/src/views/inside/home/consultar/opciones/beneficios/opciones_beneficios.dart';
import 'package:kmello_app/src/views/inside/home/consultar/opciones/productos/product_list.dart';
import 'package:kmello_app/src/views/inside/home/consultar/opciones/prospectos/options.dart';
import 'package:kmello_app/src/views/inside/home/consultar/opciones/solicitudes_curso/solicitudes_ingresadas.dart';
import 'package:kmello_app/src/views/inside/home/consultar/opciones/ventas_comisiones/informacion.dart';
import 'package:kmello_app/src/views/inside/school/what_sell/view_category.dart';
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
      "name": "Solicitudes Ingresadas",
      "icon": KmelloIcons.solucitudes,
      "route": const SolicitudesIngresadas()
    },
    /*{
      "name": "Mis cobros",
      "icon": KmelloIcons.cobros,
      "route": const OpcionesCobros()
    },*/
    {
      "name": "Productos",
      "icon": KmelloIcons.productos,
      "route": const CategoryProductList()
    },
    {
      "name": "Prospectos",
      "icon": KmelloIcons.prospectos,
      "route": const OptionsProsp(),
    },
    {
      "name": "Agenda",
      "icon": KmelloIcons.agenda,
      "route": const Agenda() //const Calendario(),
    },
    {
      "name": "Academia",
      "icon": KmelloIcons.academia,
      "route": ViewCategory(
        inside: true,
      )
    },
    {
      "name": "Beneficios",
      "icon": KmelloIcons.beneficios,
      "route": const OpcionesBeneficios()
    },
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
