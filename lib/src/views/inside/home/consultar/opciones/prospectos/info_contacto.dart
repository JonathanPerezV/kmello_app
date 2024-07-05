// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kmello_app/src/controller/dataBase/operations.dart';
import 'package:kmello_app/src/models/prospectos_model.dart';
import 'package:kmello_app/src/views/inside/home/consultar/opciones/prospectos/agregar_prospecto.dart';
import 'package:kmello_app/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:kmello_app/utils/app_bar.dart';
import 'package:kmello_app/utils/buttons.dart';
import 'package:kmello_app/utils/deviders/divider.dart';
import 'package:kmello_app/utils/flushbar.dart';
import 'package:kmello_app/utils/header.dart';
import 'package:kmello_app/utils/header_container.dart';
import 'package:kmello_app/utils/loading.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../../utils/geolocator/geolocator.dart';
import '../../../../../../../utils/icons/kmello_icons_icons.dart';

class InfoContacto extends StatefulWidget {
  ProspectosModel prospecto;
  InfoContacto({super.key, required this.prospecto});

  @override
  State<InfoContacto> createState() => _InfoContactoState();
}

class _InfoContactoState extends State<InfoContacto> {
  final _sckey = GlobalKey<ScaffoldState>();
  final op = Operations();
  bool loading = false;
  String latitud = "";
  String longitud = "";

  String latitudTrabajo = "";
  String longitudTrabajo = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _sckey,
      appBar: MyAppBar(key: _sckey).myAppBar(),
      drawer: drawerMenu(context),
      body: options(),
    );
  }

  Widget options() {
    String initial = widget.prospecto.nombres.split("")[0];
    return Stack(
      children: [
        Column(
          children: [
            header("Prospectos", KmelloIcons.prospectos, context: context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: double.infinity,
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          AgregarEditarProspecto(
                                            edit: true,
                                            prospecto: widget.prospecto,
                                          ))),
                              icon: const Icon(Icons.edit)),
                          IconButton(
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (builder) {
                                      return Platform.isAndroid
                                          ? AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                              title: const Text(
                                                  "Eliminar prospecto"),
                                              content: const Text(
                                                  "¿Desea eliminar este prospecto?"),
                                              actions: [
                                                nextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    text: "Cancelar",
                                                    background: Colors.black,
                                                    width: 80,
                                                    fontSize: 12),
                                                nextButton(
                                                    onPressed: () async {
                                                      await op
                                                          .eliminarProspecto(
                                                              widget.prospecto
                                                                  .idProspecto!)
                                                          .then((value) {
                                                        if (value == 1) {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          flushBarGlobal(
                                                              context,
                                                              "Prospecto eliminado correctamente",
                                                              const Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .green));
                                                        } else {
                                                          Navigator.pop(
                                                              context);
                                                          flushBarGlobal(
                                                              context,
                                                              "No se eliminó el prospecto, inténtelo más tarde",
                                                              const Icon(
                                                                  Icons.error,
                                                                  color: Colors
                                                                      .red));
                                                        }
                                                      });
                                                    },
                                                    text: "Eliminar",
                                                    background: Colors.red,
                                                    width: 80,
                                                    fontSize: 12)
                                              ],
                                            )
                                          : CupertinoAlertDialog(
                                              title: const Text(
                                                  "Eliminar prospecto"),
                                              content: const Text(
                                                  "¿Desea eliminar este prospecto?"),
                                              actions: [
                                                nextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    text: "Cancelar",
                                                    background: Colors.black,
                                                    width: 80,
                                                    fontSize: 12),
                                                nextButton(
                                                    onPressed: () async {
                                                      await op
                                                          .eliminarProspecto(
                                                              widget.prospecto
                                                                  .idProspecto!)
                                                          .then((value) {
                                                        if (value == 1) {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          flushBarGlobal(
                                                              context,
                                                              "Prospecto eliminado correctamente",
                                                              const Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .green));
                                                        } else {
                                                          Navigator.pop(
                                                              context);
                                                          flushBarGlobal(
                                                              context,
                                                              "No se eliminó el prospecto, inténtelo más tarde",
                                                              const Icon(
                                                                  Icons.error,
                                                                  color: Colors
                                                                      .red));
                                                        }
                                                      });
                                                    },
                                                    text: "Eliminar",
                                                    background: Colors.red,
                                                    width: 80,
                                                    fontSize: 12)
                                              ],
                                            );
                                    });
                              },
                              icon: const Icon(Icons.delete))
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.black),
                      child: Center(
                        child: Text(
                          initial,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 35),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        widget.prospecto.nombres,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onLongPress: () async {
                              if (widget.prospecto.celular.isNotEmpty) {
                                await Clipboard.setData(ClipboardData(
                                    text: widget.prospecto.celular));
                                flushBarGlobal(
                                    context,
                                    "Celular copiado en el portapapeles",
                                    const Icon(
                                      Icons.copy,
                                      color: Colors.green,
                                    ));
                              }
                            },
                            child: Text(
                              widget.prospecto.celular.isNotEmpty
                                  ? widget.prospecto.celular
                                  : "no phone number",
                              style: const TextStyle(
                                  fontSize: 27, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () async {
                              final phone = "tel:${widget.prospecto.celular}";

                              if (await canLaunchUrl(Uri.parse(phone))) {
                                await launchUrl(Uri.parse(phone));
                              } else {
                                flushBarGlobal(
                                    context,
                                    "No se pudo llamar al prospecto",
                                    const Icon(Icons.error, color: Colors.red));
                              }
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black,
                              ),
                              child: const Icon(
                                Icons.phone,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    divider(true),
                    const SizedBox(height: 20),
                    HeaderContainer(
                      margin_container:
                          const EdgeInsets.only(left: 20, right: 20),
                      height_container: 50,
                      body: InkWell(
                        onTap: () async {
                          final phone = "tel:${widget.prospecto.celular2}";

                          if (await canLaunchUrl(Uri.parse(phone))) {
                            await launchUrl(Uri.parse(phone));
                          } else {
                            flushBarGlobal(
                                context,
                                "No se pudo llamar al prospecto",
                                const Icon(Icons.error, color: Colors.red));
                          }
                        },
                        onLongPress: () async {
                          if (widget.prospecto.celular.isNotEmpty) {
                            await Clipboard.setData(
                                ClipboardData(text: widget.prospecto.celular));
                            flushBarGlobal(
                                context,
                                "Celular copiado en el portapapeles",
                                const Icon(
                                  Icons.copy,
                                  color: Colors.green,
                                ));
                          }
                        },
                        child: Text(
                          widget.prospecto.celular2.isNotEmpty
                              ? widget.prospecto.celular2
                              : "No se ha agregado otro número",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      has_header: false,
                      has_title: true,
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          //alignment: Alignment.center,
                          width: 110,
                          color: Colors.white,
                          margin: const EdgeInsets.only(left: 25, top: 8),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.person),
                              Text(
                                "Celular 2:",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    HeaderContainer(
                      margin_container:
                          const EdgeInsets.only(left: 20, right: 20),
                      height_container: 50,
                      body: Text(
                        widget.prospecto.empresa.isNotEmpty
                            ? widget.prospecto.empresa
                            : "No se ha agregado una empresa",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      has_header: false,
                      has_title: true,
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          //alignment: Alignment.center,
                          width: 110,
                          color: Colors.white,
                          margin: const EdgeInsets.only(left: 25, top: 8),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.person),
                              Text(
                                "Empresa:",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    HeaderContainer(
                      margin_container:
                          const EdgeInsets.only(left: 20, right: 20),
                      height_container: 50,
                      body: Text(
                        widget.prospecto.mail.isNotEmpty
                            ? widget.prospecto.mail
                            : "No se ha agregado un correo",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      has_header: false,
                      has_title: true,
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          //alignment: Alignment.center,
                          width: 110,
                          color: Colors.white,
                          margin: const EdgeInsets.only(left: 25, top: 8),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.person),
                              Text(
                                "Email:",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: HeaderContainer(
                            margin_container: const EdgeInsets.only(left: 20),
                            height_container: 100,
                            body: Text(
                              widget.prospecto.direccion.isNotEmpty
                                  ? widget.prospecto.direccion
                                      .replaceAll("  ", " ")
                                  : "No se ha agregado una dirección",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            has_header: false,
                            has_title: true,
                            title: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                //alignment: Alignment.center,
                                width: 175,
                                color: Colors.white,
                                margin: const EdgeInsets.only(left: 25, top: 8),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.person),
                                    Text(
                                      "Dirección domicilio:",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        //
                        (widget.prospecto.longitud != "" || longitud != "") &&
                                (widget.prospecto.latitud != "" ||
                                    latitud != "")
                            ? IconButton(
                                onPressed: () async {
                                  var url =
                                      "https://maps.google.com/maps?q=loc:${widget.prospecto.latitud},${widget.prospecto.longitud}";
                                  /*var url =
                                      "https://www.google.com/maps/@$latitud,$longitud,6z";*/
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url));
                                  } else {
                                    flushBarGlobal(
                                        context,
                                        "No se pudo ejecutar la acción",
                                        const Icon(Icons.error,
                                            color: Colors.red));
                                  }
                                },
                                icon: const Icon(Icons.map_sharp,
                                    color: Colors.green))
                            : IconButton(
                                onPressed: () async {
                                  setState(() => loading = true);

                                  var res = await GeolocatorConfig()
                                      .requestPermission(context);

                                  if (res != null) {
                                    var loc =
                                        await Geolocator.getCurrentPosition();

                                    setState(() {
                                      latitud = loc.latitude.toString();
                                      longitud = loc.longitude.toString();
                                      widget.prospecto.latitud = latitud;
                                      widget.prospecto.longitud = longitud;
                                    });

                                    debugPrint("$latitud, $longitud");

                                    flushBarGlobal(
                                        context,
                                        "Se han guardado las coordenadas de tu ubicación actual.",
                                        const Icon(Icons.check,
                                            color: Colors.green));

                                    await op.actualizarProspecto(
                                        widget.prospecto.idProspecto!,
                                        widget.prospecto);

                                    setState(() {});
                                  } else {
                                    flushBarGlobal(
                                        context,
                                        "Ocurrió un error, no hemos podido guardar tu ubicación actual",
                                        const Icon(Icons.error,
                                            color: Colors.red));
                                  }

                                  setState(() => loading = false);
                                },
                                icon: (widget.prospecto.longitud != "" ||
                                            longitud != "") &&
                                        (widget.prospecto.latitud != "" ||
                                            latitud != "")
                                    ? const Icon(
                                        Icons.location_on,
                                        color: Colors.green,
                                      )
                                    : const Icon(Icons.add_location_alt)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: HeaderContainer(
                            margin_container: const EdgeInsets.only(left: 20),
                            height_container: 100,
                            body: Text(
                              widget.prospecto.direccionTrabajo.isNotEmpty
                                  ? widget.prospecto.direccionTrabajo
                                      .replaceAll("  ", " ")
                                  : "No se ha agregado una dirección",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            has_header: false,
                            has_title: true,
                            title: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                //alignment: Alignment.center,
                                width: 175,
                                color: Colors.white,
                                margin: const EdgeInsets.only(left: 25, top: 8),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.person),
                                    Text(
                                      "Dirección trabajo:",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        //
                        (widget.prospecto.longitudTrabajo != "" ||
                                    longitudTrabajo != "") &&
                                (widget.prospecto.latitudTrabajo != "" ||
                                    latitudTrabajo != "")
                            ? IconButton(
                                onPressed: () async {
                                  var url =
                                      "https://maps.google.com/maps?q=loc:${widget.prospecto.latitudTrabajo},${widget.prospecto.longitudTrabajo}";
                                  /*var url =
                                      "https://www.google.com/maps/@$latitud,$longitud,6z";*/
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url));
                                  } else {
                                    flushBarGlobal(
                                        context,
                                        "No se pudo ejecutar la acción",
                                        const Icon(Icons.error,
                                            color: Colors.red));
                                  }
                                },
                                icon: const Icon(Icons.map_sharp,
                                    color: Colors.green))
                            : IconButton(
                                onPressed: () async {
                                  setState(() => loading = true);

                                  var res = await GeolocatorConfig()
                                      .requestPermission(context);

                                  if (res != null) {
                                    var loc =
                                        await Geolocator.getCurrentPosition();

                                    setState(() {
                                      latitudTrabajo = loc.latitude.toString();
                                      longitudTrabajo =
                                          loc.longitude.toString();
                                      widget.prospecto.latitudTrabajo =
                                          latitudTrabajo;
                                      widget.prospecto.longitudTrabajo =
                                          longitudTrabajo;
                                    });

                                    debugPrint(
                                        "$latitudTrabajo, $longitudTrabajo");

                                    flushBarGlobal(
                                        context,
                                        "Se han guardado las coordenadas de tu ubicación actual.",
                                        const Icon(Icons.check,
                                            color: Colors.green));

                                    await op.actualizarProspecto(
                                        widget.prospecto.idProspecto!,
                                        widget.prospecto);

                                    setState(() {});
                                  } else {
                                    flushBarGlobal(
                                        context,
                                        "Ocurrió un error, no hemos podido guardar tu ubicación actual",
                                        const Icon(Icons.error,
                                            color: Colors.red));
                                  }

                                  setState(() => loading = false);
                                },
                                icon: (widget.prospecto.longitudTrabajo != "" ||
                                            longitudTrabajo != "") &&
                                        (widget.prospecto.latitudTrabajo !=
                                                "" ||
                                            latitudTrabajo != "")
                                    ? const Icon(
                                        Icons.location_on,
                                        color: Colors.green,
                                      )
                                    : const Icon(Icons.add_location_alt)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    HeaderContainer(
                      margin_container:
                          const EdgeInsets.only(left: 20, right: 20),
                      height_container: 100,
                      body: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          widget.prospecto.referencia.isNotEmpty
                              ? widget.prospecto.referencia
                                  .replaceAll("  ", " ")
                              : "No se ha agregado una referencia",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      has_header: false,
                      has_title: true,
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          //alignment: Alignment.center,
                          width: 115,
                          color: Colors.white,
                          margin: const EdgeInsets.only(left: 25, top: 8),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.person),
                              Text(
                                "Referencia:",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
        if (loading) loadingWidget(text: "Cargando...")
      ],
    );
  }
}
