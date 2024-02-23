import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kmello_app/main.dart';
import 'package:kmello_app/utils/app_bar.dart';
import 'package:kmello_app/utils/buttons.dart';
import 'package:kmello_app/utils/deviders/divider.dart';
import 'package:kmello_app/utils/footer.dart';
import 'package:kmello_app/utils/header.dart';
import 'package:kmello_app/utils/header_container.dart';
import 'package:kmello_app/utils/header_form_login.dart';
import 'package:kmello_app/utils/icons/kmello_icons_icons.dart';

class InformacionComisiones extends StatefulWidget {
  const InformacionComisiones({super.key});

  @override
  State<InformacionComisiones> createState() => _InformacionComisionesState();
}

class _InformacionComisionesState extends State<InformacionComisiones> {
  String initialDate = "Desde";
  DateTime initialDateTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 31);
  DateTime? firstDate;
  String finalDate = "Hasta";
  DateTime finalDateTime = DateTime.now();
  DateTime? lastDate;
  bool data = false;
  String? textDate;

  List<Map<String, dynamic>> categories = [
    {"name": "Todas", "value": 1},
    {"name": "Suscripciones", "value": 2},
  ];

  final _sckey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _sckey, appBar: MyAppBar(key: _sckey).myAppBar(), body: options());
  }

  Widget options() {
    return Column(
      children: [
        header("Ventas y Comisiones", KmelloIcons.venta_comision,
            context: context),
        selectorFecha(),
        divider(false),
        rangoFecha(),
        divider(false),
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            children: [
              dolarGraphic(),
              const SizedBox(height: 20),
              doubleOptions(),
              const SizedBox(height: 20),
              ventas(),
              const SizedBox(height: 20),
              nextButton(
                  onPressed: () {},
                  text: "Generar Reporte Detallado",
                  width: 270),
              const SizedBox(height: 20),
              footerBaadal(),
            ],
          ),
        ))
      ],
    );
  }

  Widget selectorFecha() => Container(
        padding: const EdgeInsets.only(left: 25, right: 25),
        color: Colors.grey.shade300,
        width: double.infinity,
        height: 160,
        child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownButtonFormField<Map<String, dynamic>>(
                  hint: const Text("Seleccione"),
                  decoration: const InputDecoration(
                      alignLabelWithHint: true,
                      icon: Icon(Icons.list),
                      hintText: "Seleccione",
                      labelText: "Categoría:"),
                  //icon: Icon(Icons.abc),
                  alignment: Alignment.centerLeft,
                  items: categories
                      .map((e) => DropdownMenuItem<Map<String, dynamic>>(
                            value: e,
                            child: Text(e["name"]),
                          ))
                      .toList(),
                  onChanged: (value) {}),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: Column(children: [
                        const ListTile(
                          leading: const Icon(Icons.calendar_month),
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            "Desde:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => selectDate(1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                initialDate == "Desde"
                                    ? "Seleccione"
                                    : initialDate.replaceAll("Desde:", ""),
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.edit,
                                size: 15,
                              )
                            ],
                          ),
                        ),
                        divider(false),
                        const SizedBox(height: 5)
                      ]),
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: Column(children: [
                        ListTile(
                          minVerticalPadding: 0.0,
                          leading: const Icon(Icons.calendar_month),
                          minLeadingWidth: 12,
                          contentPadding: EdgeInsets.zero,
                          enabled: initialDate != "Desde" ? true : false,
                          title: const Text(
                            "Hasta:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => selectDate(2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                finalDate == "Hasta"
                                    ? "Seleccione"
                                    : finalDate.replaceAll("Hasta:", ""),
                                style: TextStyle(
                                    fontSize: 20,
                                    color: initialDate != "Desde"
                                        ? Colors.black
                                        : Colors.grey),
                              ),
                              const SizedBox(width: 10),
                              Icon(Icons.edit,
                                  size: 15,
                                  color: initialDate != "Desde"
                                      ? Colors.black
                                      : Colors.grey)
                            ],
                          ),
                        ),
                        divider(false),
                        const SizedBox(height: 5)
                      ]),
                    ),
                  ),
                ],
              )
            ]),
      );

  Widget rangoFecha() => Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 35,
        child: Text(
          textDate == null ? "Esperando fechas..." : textDate!,
          style: const TextStyle(fontSize: 17),
        ),
      );

  void selectDate(int type) async {
    if (type == 1) {
      final date = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: Colors.white,
              // ignore: deprecated_member_use
              colorScheme: const ColorScheme.light(
                primary: Colors.black,
              ),
              buttonTheme:
                  const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
        locale: const Locale("es"),
        context: context,
        initialDate: initialDateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        confirmText: "ACEPTAR",
        cancelText: "CANCELAR",
      );

      if (date != null) {
        setState(() => initialDateTime = date);
        setState(() => initialDate =
            "Desde: ${DateFormat("dd-MM-yyyy", "ES").format(date).replaceAll(".", "")}");
        setState(() => firstDate = date);
        if (textDate != null) {
          setState(() => textDate =
              "Del ${firstDate!.day} de ${monthConvert(firstDate!.month)} al ${lastDate!.day} de ${monthConvert(lastDate!.month)} de ${DateTime.now().year}");
        }
        setState(() => data = false);
      }
    } else {
      final date = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: Colors.white,
              // ignore: deprecated_member_use

              colorScheme: const ColorScheme.light(
                primary: Colors.black,
              ),
              buttonTheme:
                  const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
        locale: const Locale("es"),
        context: context,
        initialDate:
            DateTime(firstDate!.year, firstDate!.month, firstDate!.day + 31),
        firstDate: DateTime(firstDate!.year, firstDate!.month, firstDate!.day),
        lastDate:
            DateTime(firstDate!.year, firstDate!.month, firstDate!.day + 31),
        confirmText: "ACEPTAR",
        cancelText: "CANCELAR",
      );

      if (date != null) {
        setState(() => finalDateTime = date);
        setState(() => finalDate =
            "Hasta: ${DateFormat("dd-MM-yyyy", "ES").format(date).replaceAll(".", "")}");
        setState(() => lastDate = date);
        setState(() => textDate =
            "Del ${firstDate!.day} de ${monthConvert(firstDate!.month)} al ${lastDate!.day} de ${monthConvert(lastDate!.month)} de ${DateTime.now().year}");
        setState(() => data = false);
      }
    }
  }

  String monthConvert(int month) {
    switch (month) {
      case 01:
        return "enero";
      case 02:
        return "febrero";
      case 03:
        return "marzo";
      case 04:
        return "abril";
      case 05:
        return "mayo";
      case 06:
        return "junio";
      case 07:
        return "julio";
      case 08:
        return "agosto";
      case 09:
        return "septiembre";
      case 10:
        return "octubre";
      case 11:
        return "noviembre";
      case 12:
        return "diciembre";
      default:
        return "";
    }
  }

  Widget dolarGraphic() => HeaderContainer(
        has_header: false,
        width_container: double.infinity,
        radius: BorderRadius.circular(10),
        margin_container: const EdgeInsets.only(left: 25, right: 25),
        has_title: true,
        title: Container(
            width: 130,
            height: 40,
            color: Colors.white,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "En dólares",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.star_border_purple500_sharp)
              ],
            )),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Ventas",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text("\$ 1,456,023", style: TextStyle(fontSize: 23))
                ],
              ),
            ),
            Container(width: 1, color: Colors.black, height: 65),
            const Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Comisiones", style: TextStyle(fontSize: 20)),
                    Text("\$ 800,00", style: TextStyle(fontSize: 23))
                  ]),
            )
          ],
        ),
      );

  Widget doubleOptions() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: HeaderContainer(
                color_header: Colors.grey.shade700,
                has_title: false,
                height_container: 120,
                radius: BorderRadius.circular(10),
                margin_container: const EdgeInsets.only(left: 25),
                has_header: true,
                header: Container(
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Cantidad",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.white,
                        )
                      ]),
                ),
                body: const Center(
                  child: Text(
                    "10",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                )),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: HeaderContainer(
                color_header: Colors.grey.shade700,
                has_title: false,
                height_container: 120,
                radius: BorderRadius.circular(10),
                margin_container: const EdgeInsets.only(right: 25),
                has_header: true,
                header: Container(
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Puntos",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.white,
                        )
                      ]),
                ),
                body: const Center(
                  child: Text(
                    "33",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                )),
          )
        ],
      );

  Widget ventas() => Row(
        children: [
          const Icon(Icons.keyboard_arrow_left_outlined),
          Expanded(
            child: HeaderContainer(
                has_header: true,
                has_title: false,
                width_container: double.infinity,

                //margin_container: const EdgeInsets.only(left: 25, right: 25),
                height_container: 200,
                radius: BorderRadius.circular(10),
                color_header: Colors.grey.shade700,
                header: const Text(
                  "VENTAS POR TIPO DE PRODUCTO",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                body: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Créditos", style: TextStyle(fontSize: 17)),
                        Text("5", style: TextStyle(fontSize: 25)),
                        Text("Comisiones"),
                        Text("\$ 300,0")
                      ],
                    ),
                    Container(width: 1, color: Colors.black, height: 130),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Seguros \n De Vehículos",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17)),
                        Text("2", style: TextStyle(fontSize: 25)),
                        Text("Comisiones"),
                        Text("\$ 300,0")
                      ],
                    ),
                    Container(width: 1, color: Colors.black, height: 130),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Seguros \nMédicos",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17)),
                        Text("5", style: TextStyle(fontSize: 25)),
                        Text("Comisiones"),
                        Text("\$ 300,0")
                      ],
                    ),
                  ],
                )),
          ),
          const Icon(Icons.navigate_next),
        ],
      );
}
