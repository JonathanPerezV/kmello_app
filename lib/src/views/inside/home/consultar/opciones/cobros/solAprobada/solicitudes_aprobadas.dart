import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:abi_praxis/src/controller/data_prueba/solicitudes_ingresadas.dart';
import 'package:abi_praxis/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:abi_praxis/utils/app_bar.dart';
import 'package:abi_praxis/utils/buttons.dart';
import 'package:abi_praxis/utils/footer.dart';
import 'package:abi_praxis/utils/header.dart';
import 'package:abi_praxis/utils/icons/kmello_icons_icons.dart';

import '../../../../../../../../utils/textFields/input_text_fields.dart';

class SolicitudesAprobadas extends StatefulWidget {
  const SolicitudesAprobadas({super.key});

  @override
  State<SolicitudesAprobadas> createState() => _SolicitudesAprobadasState();
}

class _SolicitudesAprobadasState extends State<SolicitudesAprobadas> {
  final sckey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  String searchText = "";
  bool hideOptions = false;

  List<Map<String, dynamic>> _searchList = [];
  List<bool> valueListBool = [];
  bool selectAll = false;

  @override
  void initState() {
    super.initState();
    setState(() => _searchList = solicitudes_ingresadas);
    setState(() =>
        valueListBool = List.generate(_searchList.length, (index) => false));
  }

  List<Map<String, dynamic>> _buildSearch() {
    if (searchText.isEmpty) {
      return _searchList = solicitudes_ingresadas;
    } else {
      _searchList = solicitudes_ingresadas
          .where((element) =>
              element["establecimiento"]
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              element["informacion"]
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();

      return _searchList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() => hideOptions = false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        key: sckey,
        appBar: MyAppBar(key: sckey).myAppBar(),
        drawer: drawerMenu(context),
        body: Column(
          children: [
            Expanded(child: options()),
            if (!hideOptions) footerBaadal(),
          ],
        ),
      ),
    );
  }

  Widget options() => Column(
        children: [
          header("Solicitudes aprobadas", KmelloIcons.solucitudes,
              context: context),
          Container(
            color: Colors.grey.shade400,
            child: InputTextFields(
                onSubmitted: (_) {
                  setState(() => hideOptions = false);
                },
                onTap: () {
                  setState(() => hideOptions = true);
                },
                controlador: _searchController,
                inputBorder:
                    const OutlineInputBorder(borderSide: BorderSide.none),
                style: const TextStyle(color: Colors.black),
                placeHolder: "BUSCAR SOLICITUDES",
                nombreCampo: null,
                onChanged: (value) {
                  setState(() => searchText = value);
                  _buildSearch();
                },
                icon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          setState(() => _searchList = solicitudes_ingresadas);
                          setState(() => _searchController.clear());
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.black,
                        )),
                accionCampo: TextInputAction.done),
          ),
          Container(
            color: Colors.white,
            child: Row(
              children: [
                Checkbox(
                    value: selectAll,
                    onChanged: (value) {
                      setState(() => selectAll = value!);
                      for (var i = 0; i < valueListBool.length; i++) {
                        setState(() => valueListBool.setAll(i, [selectAll]));
                      }
                    }),
                const Text("Seleccionar todas")
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _searchList.length,
                itemBuilder: (itemBuilder, index) {
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 10),
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          DateFormat.yMMMMEEEEd("es").format(DateTime.parse(
                              _searchList[index]["fecha_solicitud"])),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(color: Colors.black)),
                          leading: Checkbox(
                            onChanged: (value) {
                              setState(() => valueListBool[index] = value!);
                            },
                            value: valueListBool[index],
                          ),
                          title: Text(_searchList[index]["establecimiento"]),
                          subtitle: Text(_searchList[index]["informacion"]),
                          trailing: Text(
                            "\$${_searchList[index]["valor"]}",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          ),
          if (!hideOptions)
            nextButton(
                onPressed: () {},
                text: "Generar Preliquidación",
                width: 210,
                fontSize: 16)
        ],
      );
}
