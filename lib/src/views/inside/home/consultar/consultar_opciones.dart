import 'package:flutter/material.dart';
import 'package:abi_praxis/src/views/inside/home/consultar/opciones/agenda/agenda.dart';
import 'package:abi_praxis/src/views/inside/home/consultar/opciones/beneficios/opciones_beneficios.dart';
import 'package:abi_praxis/src/views/inside/home/consultar/opciones/productos/product_list.dart';
import 'package:abi_praxis/src/views/inside/home/consultar/opciones/prospectos/clientes/mis_clientes.dart';
import 'package:abi_praxis/src/views/inside/home/consultar/opciones/prospectos/prospectos/mis_prospectos.dart';
import 'package:abi_praxis/src/views/inside/home/consultar/opciones/prospectos/options.dart';
import 'package:abi_praxis/src/views/inside/home/consultar/opciones/solicitudes_curso/solicitudes_ingresadas.dart';
import 'package:abi_praxis/src/views/inside/home/consultar/opciones/ventas_comisiones/informacion.dart';
import 'package:abi_praxis/src/views/inside/school/what_sell/view_category.dart';
import 'package:abi_praxis/utils/deviders/divider.dart';
import 'package:abi_praxis/utils/icons/kmello_icons_icons.dart';
import 'package:abi_praxis/utils/textFields/input_text_fields.dart';

class ConsultarOpciones extends StatefulWidget {
  const ConsultarOpciones({super.key});

  @override
  State<ConsultarOpciones> createState() => _ConsultarOpcionesState();
}

class _ConsultarOpcionesState extends State<ConsultarOpciones> {
  List optionsList = [
    {
      "name": "Prospectos",
      "icon": KmelloIcons.prospectos,
      "route": const MisProspectos(),
    },
    {
      "name": "Cartera",
      "icon": KmelloIcons.prospectos,
      "route": const MisClientes()
    },
    {
      "name": "Agenda",
      "icon": KmelloIcons.agenda,
      "route": const Agenda() //const Calendario(),
    },
    {
      "name": "Solicitudes",
      "icon": KmelloIcons.solucitudes,
      "route": const SolicitudesIngresadas()
    },
    {
      "name": "Productos",
      "icon": KmelloIcons.productos,
      "route": const CategoryProductList()
    },
    {
      "name": "Academia",
      "icon": KmelloIcons.academia,
      "route": ViewCategory(
        inside: true,
      )
    },
    {
      "name": "Ventas y Comisiones",
      "icon": KmelloIcons.venta_comision,
      "route": const InformacionComisiones()
    },

    /*{
      "name": "Mis cobros",
      "icon": KmelloIcons.cobros,
      "route": const OpcionesCobros()
    },*/

    {
      "name": "Beneficios",
      "icon": KmelloIcons.beneficios,
      "route": const OpcionesBeneficios()
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          const SizedBox(height: 10),
          //buscador(),
          Expanded(
            child: ListView.builder(
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
                                builder: (builder) =>
                                    optionsList[index]["route"])),
                        leading: Icon(optionsList[index]["icon"]),
                        title: Text(
                          optionsList[index]["name"],
                          style: const TextStyle(fontSize: 19),
                        ),
                        trailing: const Icon(Icons.navigate_next),
                      ),
                      divider(false, color: Colors.grey)
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget buscador() => Container(
        child: InputTextFields(
            icon: const Icon(Icons.search),
            padding: const EdgeInsets.only(left: 15),
            inputBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            placeHolder: "Buscar en cartera de la institución",
            style: const TextStyle(fontSize: 15),
            nombreCampo: "Buscador",
            accionCampo: TextInputAction.done),
      );
}
