import 'package:flutter/material.dart';
import 'package:kmello_app/src/controller/dataBase/operations.dart';
import 'package:kmello_app/utils/flushbar.dart';

class ResultadoAgenda extends StatefulWidget {
  int idAgenda;
  ResultadoAgenda({super.key, required this.idAgenda});

  @override
  State<ResultadoAgenda> createState() => _ResultadoAgendaState();
}

class _ResultadoAgendaState extends State<ResultadoAgenda> {
  final op = Operations();

  List<Map<String, dynamic>> listOptions = [
    {"nombre": "Llenó solicitud", "id": 1},
    {"nombre": "Analizará la decisión", "id": 2},
    {"nombre": "No desea", "id": 3},
    {"nombre": "Coordinar otra visita", "id": 4},
  ];
  Map<String, dynamic>? optionSelected;

  Future<void> obtenerResultado() async {
    final res = await op.obtenerAgenda(widget.idAgenda);

    if (res != null) {
      setState(() {
        optionSelected = res.resultadoReunion == ""
            ? null
            : listOptions
                .where((e) => e["nombre"] == res.resultadoReunion)
                .toList()[0];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    obtenerResultado();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 15),
        child: DropdownButtonFormField<Map<String, dynamic>>(
          value: optionSelected,
          elevation: 1,
          hint: const Text("Seleccione"),
          decoration: const InputDecoration(
            labelText: "Resultado de reunión",
          ),
          onChanged: (value) async {
            final res =
                await op.actualizarResultado(widget.idAgenda, value!["nombre"]);

            if (res == 1) {
              flushBarGlobal(context, "Resultado actualizado correctamente",
                  const Icon(Icons.check, color: Colors.green));
            } else {
              flushBarGlobal(context, "No se pudo acutualizar el resultado",
                  const Icon(Icons.error, color: Colors.red));
            }
          },
          items: listOptions
              .map((e) => DropdownMenuItem<Map<String, dynamic>>(
                  value: e, child: Text(e["nombre"])))
              .toList(),
        ));
  }
}
