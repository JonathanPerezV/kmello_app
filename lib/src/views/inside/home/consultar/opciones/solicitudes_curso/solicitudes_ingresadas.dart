import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:abi_praxis/src/controller/data_prueba/solicitudes_ingresadas.dart';
import 'package:abi_praxis/src/views/inside/home/consultar/opciones/solicitudes_curso/detalle_solicitud.dart';
import 'package:abi_praxis/utils/app_bar.dart';
import 'package:abi_praxis/utils/footer.dart';
import 'package:abi_praxis/utils/header.dart';
import 'package:abi_praxis/utils/icons/kmello_icons_icons.dart';
import 'package:abi_praxis/utils/textFields/input_text_fields.dart';

class SolicitudesIngresadas extends StatefulWidget {
  const SolicitudesIngresadas({super.key});

  @override
  State<SolicitudesIngresadas> createState() => _SolicitudesIngresadasState();
}

class _SolicitudesIngresadasState extends State<SolicitudesIngresadas> {
  final sckey = GlobalKey<ScaffoldState>();
  String? selectedName;
  Map<String, dynamic> value = options_solicitud[0];
  bool selectAllOptions = false;

  List<Map<String, dynamic>> _searchList = [];
  final _searchController = TextEditingController();
  String searchText = "";

  @override
  void initState() {
    super.initState();
    setState(() => _searchList = solicitudes_ingresadas);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppBar(key: sckey).myAppBar(),
        body: options(),
      ),
    );
  }

  Widget options() => Column(
        children: [
          header("Solicitudes Ingresadas", KmelloIcons.solucitudes,
              context: context),
          if (_searchList.isNotEmpty) buscador(),
          if (_searchList.isNotEmpty)
            Align(
                alignment: Alignment.centerRight, child: opcionesSoliciudes()),
          listaSolicitudes(),
          footerBaadal()
        ],
      );

  Container buscador() => Container(
        color: Colors.grey.shade300,
        width: double.infinity,
        height: 50,
        child: InputTextFields(
          onChanged: (value) {
            setState(() => searchText = value);
            _buildSearchList();
          },
          controlador: _searchController,
          align: TextAlign.center,
          padding: const EdgeInsets.only(right: 40),
          icon: const Icon(Icons.search),
          accionCampo: TextInputAction.done,
          placeHolder: "BUSCAR SOLICITUDES",
          //align: TextAlign.center,
          inputBorder: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
      );

  Expanded listaSolicitudes() => Expanded(
      child: _searchList.isEmpty
          ? Center(
              child: Text("No tiene solicitudes ingresadas"),
            )
          : ListView.builder(
              itemCount: _searchList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) =>
                              DetalleSolicitud(id: _searchList[index]["id"]))),
                  child: Container(
                    margin: const EdgeInsets.only(top: 15, right: 10, left: 10),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              DateFormat.yMMMMEEEEd("es").format(DateTime.parse(
                                  _searchList[index]["fecha_solicitud"])),
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding:
                              const EdgeInsets.only(right: 5, left: 10),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "\$${solicitudes_ingresadas[index]["valor"]}",
                                style: const TextStyle(fontSize: 25),
                              ),
                              const Icon(
                                Icons.navigate_next_sharp,
                                color: Colors.grey,
                              )
                            ],
                          ),
                          title: Text(_searchList[index]["establecimiento"]),
                          subtitle: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    child:
                                        Text(_searchList[index]["informacion"]),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: Text(estadoSolicitud(
                                        _searchList[index]["estado"])),
                                  )
                                ]),
                          ),
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ],
                    ),
                  ),
                );
              }));

  String estadoSolicitud(int estado) {
    String result = "Estado: ";
    switch (estado) {
      case 0:
        result += "Rechazado";
      case 2:
        result += "En revisión";
      case 3:
        result += "Con novedad";
      case 1:
        result += "Aprobado";
      default:
    }

    return result;
  }

  Container opcionesSoliciudes() => Container(
      margin: const EdgeInsets.only(right: 15),
      color: Colors.white,
      width: 130,
      child: DropdownButton<Map<String, dynamic>>(
        dropdownColor: Colors.white,
        hint: const Text("Seleccione"),
        value: value,
        items: options_solicitud
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e["name"]),
                ))
            .toList(),
        onChanged: (value) {
          setState(() => this.value = value!);

          if (value!["value"] == 4) {
            setState(() => _searchList = solicitudes_ingresadas);
          } else {
            setState(() {
              _searchList = solicitudes_ingresadas
                  .where((element) => element["estado"] == value["value"])
                  .toList();
            });
          }
        },
      ));

  List<Map<String, dynamic>> _buildSearchList() {
    //setState(() {
    if (searchText.isEmpty) {
      setState(() => value = options_solicitud[0]);
      return _searchList = solicitudes_ingresadas;
    } else {
      if (value["value"] == 4) {
        _searchList = solicitudes_ingresadas
            .where((element) => element["establecimiento"]
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()))
            .toList();
      } else {
        _searchList = solicitudes_ingresadas
            .where((element) =>
                element["establecimiento"]
                    .toString()
                    .toLowerCase()
                    .contains(searchText.toLowerCase()) &&
                element["value"] == value["value"])
            .toList();
      }

      return _searchList;
    }

    //});
  }
}
