import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kmello_app/src/controller/data_prueba/solicitudes_ingresadas.dart';
import 'package:kmello_app/utils/app_bar.dart';
import 'package:kmello_app/utils/deviders/divider.dart';
import 'package:kmello_app/utils/footer.dart';
import 'package:kmello_app/utils/header.dart';
import 'package:kmello_app/utils/icons/kmello_icons_icons.dart';

class DetalleSolicitud extends StatefulWidget {
  int id;
  DetalleSolicitud({super.key, required this.id});

  @override
  State<DetalleSolicitud> createState() => _DetalleSolicitudState();
}

class _DetalleSolicitudState extends State<DetalleSolicitud> {
  final scKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> transaction = {};

  void getCurrentTransaction() {
    final data = solicitudes_ingresadas
        .where((element) => element["id"] == widget.id)
        .toList();

    setState(() => transaction = data[0]);
  }

  @override
  void initState() {
    super.initState();
    getCurrentTransaction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scKey,
      appBar: MyAppBar(key: scKey).myAppBar(),
      body: options(),
    );
  }

  Widget options() => Column(
        children: [
          header("Resumen de Transacción", KmelloIcons.solucitudes,
              context: context),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 30),
                card(),
                const SizedBox(height: 25),
                details(),
                const SizedBox(height: 25),
              ],
            ),
          ),
          footerBaadal()
        ],
      );

  Widget card() => Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        padding: const EdgeInsets.only(left: 25, right: 15),
        width: 350,
        height: 190,
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  blurRadius: 0.3, offset: Offset(2, 2), color: Colors.grey)
            ],
            color: const Color.fromRGBO(238, 238, 238, 1),
            borderRadius: BorderRadius.circular(25)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const Text(
                      "Comisión",
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      "\$${transaction["comision"].toString()}",
                      style: const TextStyle(fontSize: 30),
                    )
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "Monto",
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        "\$${transaction["valor"].toString()}",
                        style: const TextStyle(fontSize: 30),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                DateFormat.yMMMMEEEEd("es")
                    .format(DateTime.parse(transaction["fecha_solicitud"])),
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Sponsor:",
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    transaction["establecimiento"],
                    style: const TextStyle(fontSize: 25),
                  ),
                )
              ],
            )
          ],
        ),
      );

  Widget details() => Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: double.infinity,
              child: Text(
                "Detalles",
                style: TextStyle(fontSize: 35),
              ),
            ),
            const SizedBox(height: 15),
            divider(false),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Expanded(
                  child: Text("Concepto:"),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    transaction["informacion"],
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            divider(false),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Expanded(
                  child: Text("Usuario:"),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    transaction["usuario_solicitud"],
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            divider(false),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Expanded(
                  child: Text("# Transacción:"),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    transaction["numero_transaccion"],
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            divider(false),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Expanded(
                  child: Text("Detalles:"),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    transaction["detalles"],
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            divider(false),
          ],
        ),
      );
}
