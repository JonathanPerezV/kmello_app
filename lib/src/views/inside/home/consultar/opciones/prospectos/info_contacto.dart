// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:abi_praxis/src/controller/dataBase/operations.dart';
import 'package:abi_praxis/src/models/prospectos_model.dart';
import 'package:abi_praxis/src/views/inside/home/consultar/opciones/prospectos/agregar_prospecto.dart';
import 'package:abi_praxis/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:abi_praxis/utils/app_bar.dart';
import 'package:abi_praxis/utils/buttons.dart';
import 'package:abi_praxis/utils/deviders/divider.dart';
import 'package:abi_praxis/utils/flushbar.dart';
import 'package:abi_praxis/utils/header.dart';
import 'package:abi_praxis/utils/header_container.dart';
import 'package:abi_praxis/utils/loading.dart';
import 'package:abi_praxis/utils/responsive.dart';
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

  Color grey = Colors.grey;

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
    String initials = widget.prospecto.nombres.split("")[0];
    String lastname = widget.prospecto.nombres.split(" ").length > 2
        ? (widget.prospecto.nombres.split(" ")[2].split("")[0]) ?? ""
        : "";

    setState(() => initials += lastname);
    return Stack(
      children: [
        Column(
          children: [
            header(widget.prospecto.cliente == 1 ? "Cartera" : "Prospectos",
                KmelloIcons.prospectos,
                context: context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //const SizedBox(height: 10),
                    botonesGestionar(),
                    const SizedBox(height: 5),
                    infoPrincipal(initials),
                    const SizedBox(height: 10),
                    HeaderContainer(
                      borderColor: Colors.grey.shade400,
                      margin_container:
                          const EdgeInsets.only(left: 20, right: 20),
                      height_container: 45,
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
                        child: Row(
                          children: [
                            const SizedBox(width: 15),
                            Icon(Icons.phone_android, color: grey, size: 20),
                            Text(
                              widget.prospecto.celular2.isNotEmpty
                                  ? widget.prospecto.celular2
                                  : "No se ha agregado otro número",
                              style: TextStyle(
                                color: grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      has_header: false,
                      has_title: true,
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            alignment: Alignment.center,
                            width: 90,
                            color: Colors.white,
                            margin: const EdgeInsets.only(left: 35, top: 8),
                            child: Text(
                              "Celular 2",
                              style: TextStyle(
                                color: grey,
                                fontSize: 17,
                              ),
                            )),
                      ),
                    ),
                    HeaderContainer(
                      borderColor: Colors.grey.shade400,
                      margin_container:
                          const EdgeInsets.only(left: 20, right: 20),
                      height_container: 55,
                      body: Row(
                        children: [
                          const SizedBox(width: 15),
                          Icon(Icons.work, color: grey),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              widget.prospecto.empresa.isNotEmpty
                                  ? widget.prospecto.empresa
                                  : "No se ha agregado una empresa",
                              style: TextStyle(
                                color: grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      has_header: false,
                      has_title: true,
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            alignment: Alignment.center,
                            width: 160,
                            color: Colors.white,
                            margin: const EdgeInsets.only(left: 35, top: 8),
                            child: Text(
                              "Negocio / Empresa",
                              style: TextStyle(
                                color: grey,
                                fontSize: 17,
                              ),
                            )),
                      ),
                    ),
                    HeaderContainer(
                      borderColor: Colors.grey.shade400,
                      margin_container:
                          const EdgeInsets.only(left: 20, right: 20),
                      height_container: 50,
                      body: Row(
                        children: [
                          const SizedBox(width: 15),
                          Icon(Icons.mail, color: grey),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              widget.prospecto.mail.isNotEmpty
                                  ? widget.prospecto.mail
                                  : "No se ha agregado un correo",
                              style: TextStyle(
                                color: grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      has_header: false,
                      has_title: true,
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            alignment: Alignment.center,
                            width: 65,
                            color: Colors.white,
                            margin: const EdgeInsets.only(left: 35, top: 8),
                            child: Text(
                              "Email",
                              style: TextStyle(
                                color: grey,
                                fontSize: 17,
                              ),
                            )),
                      ),
                    ),

                    HeaderContainer(
                      borderColor: Colors.grey.shade400,
                      margin_container:
                          const EdgeInsets.only(left: 20, right: 20),
                      height_container: 60,
                      body: Row(
                        children: [
                          const SizedBox(width: 15),
                          Icon(Icons.home, color: grey),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              widget.prospecto.direccion.isNotEmpty
                                  ? widget.prospecto.direccion
                                      .replaceAll("  ", " ")
                                  : "No se ha agregado una dirección",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: grey,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          (widget.prospecto.longitud != "" || longitud != "") &&
                                  (widget.prospecto.latitud != "" ||
                                      latitud != "")
                              ? IconButton(
                                  onPressed: () async {
                                    final coor =
                                        await Geolocator.getCurrentPosition();

                                    String url =
                                        'comgooglemaps://?q=${widget.prospecto.latitud},${widget.prospecto.longitud}';

                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      await launchUrl(Uri.parse(url));
                                    } else {
                                      const String playStoreUrl =
                                          'https://play.google.com/store/apps/details?id=com.google.android.apps.maps';
                                      const String appStoreUrl =
                                          'https://apps.apple.com/us/app/google-maps/id585027354';

                                      if (Platform.isAndroid) {
                                        if (await canLaunchUrl(
                                            Uri.parse(playStoreUrl))) {
                                          await launchUrl(
                                              Uri.parse(playStoreUrl));
                                        } else {
                                          flushBarGlobal(
                                              context,
                                              "No se pudo ejecutar la acción",
                                              const Icon(Icons.error));
                                        }
                                      } else if (Platform.isIOS) {
                                        if (await canLaunchUrl(
                                            Uri.parse(appStoreUrl))) {
                                          await launchUrl(
                                              Uri.parse(appStoreUrl));
                                        } else {
                                          flushBarGlobal(
                                              context,
                                              "No se pudo ejecutar la acción",
                                              const Icon(Icons.error));
                                        }
                                      }
                                    }
                                  },
                                  icon: const Icon(Icons.map_sharp,
                                      color: Colors.green))
                              : Container() /*IconButton(
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
                                      : const Icon(Icons.add_location_alt)),*/
                        ],
                      ),
                      has_header: false,
                      has_title: true,
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            alignment: Alignment.center,
                            width: 175,
                            color: Colors.white,
                            margin: const EdgeInsets.only(left: 35, top: 8),
                            child: Text(
                              "Dirección domicilio",
                              style: TextStyle(
                                color: grey,
                                fontSize: 17,
                              ),
                            )),
                      ),
                    ),
                    HeaderContainer(
                      borderColor: Colors.grey.shade400,
                      margin_container:
                          const EdgeInsets.only(left: 20, right: 20),
                      height_container: 60,
                      body: Row(
                        children: [
                          const SizedBox(width: 15),
                          Icon(Icons.home, color: grey),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              widget.prospecto.referencia.isNotEmpty
                                  ? widget.prospecto.referencia
                                      .replaceAll("  ", " ")
                                  : "No se ha agregado una referencia",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          widget.prospecto.fotoRefCasa != null
                              ? IconButton(
                                  onPressed: () => verFoto(
                                      widget.prospecto.fotoRefCasa!,
                                      "domicilio"),
                                  icon:
                                      const Icon(Icons.remove_red_eye_outlined))
                              : Container()
                        ],
                      ),
                      has_header: false,
                      has_title: true,
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            alignment: Alignment.center,
                            width: 175,
                            color: Colors.white,
                            margin: const EdgeInsets.only(left: 35, top: 8),
                            child: Text(
                              "Referencia domicilio",
                              style: TextStyle(
                                color: grey,
                                fontSize: 17,
                              ),
                            )),
                      ),
                    ),

                    HeaderContainer(
                      borderColor: Colors.grey.shade400,
                      margin_container:
                          const EdgeInsets.only(left: 20, right: 20),
                      height_container: 60,
                      has_header: false,
                      has_title: true,
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            alignment: Alignment.center,
                            width: 155,
                            color: Colors.white,
                            margin: const EdgeInsets.only(left: 35, top: 8),
                            child: Text(
                              "Dirección trabajo",
                              style: TextStyle(
                                color: grey,
                                fontSize: 17,
                              ),
                            )),
                      ),
                      body: Row(children: [
                        SizedBox(width: 15),
                        Icon(Icons.work, color: grey),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            widget.prospecto.direccionTrabajo.isNotEmpty
                                ? widget.prospecto.direccionTrabajo
                                    .replaceAll("  ", " ")
                                : "No se ha agregado una dirección",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: grey,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        (widget.prospecto.longitudTrabajo != "" ||
                                    longitudTrabajo != "") &&
                                (widget.prospecto.latitudTrabajo != "" ||
                                    latitudTrabajo != "")
                            ? IconButton(
                                onPressed: () async {
                                  String url =
                                      'comgooglemaps://?q=${widget.prospecto.latitudTrabajo},${widget.prospecto.longitudTrabajo}';

                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url));
                                  } else {
                                    const String playStoreUrl =
                                        'https://play.google.com/store/apps/details?id=com.google.android.apps.maps';
                                    const String appStoreUrl =
                                        'https://apps.apple.com/us/app/google-maps/id585027354';

                                    if (Platform.isAndroid) {
                                      if (await canLaunchUrl(
                                          Uri.parse(playStoreUrl))) {
                                        await launchUrl(
                                            Uri.parse(playStoreUrl));
                                      } else {
                                        flushBarGlobal(
                                            context,
                                            "No se pudo ejecutar la acción",
                                            const Icon(Icons.error));
                                      }
                                    } else if (Platform.isIOS) {
                                      if (await canLaunchUrl(
                                          Uri.parse(appStoreUrl))) {
                                        await launchUrl(Uri.parse(appStoreUrl));
                                      } else {
                                        flushBarGlobal(
                                            context,
                                            "No se pudo ejecutar la acción",
                                            const Icon(Icons.error));
                                      }
                                    }
                                  }
                                },
                                icon: const Icon(Icons.map_sharp,
                                    color: Colors.green))
                            : Container() /*IconButton(
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
                                    : const Icon(Icons.add_location_alt)),*/
                      ]),
                    ),
                    HeaderContainer(
                      borderColor: Colors.grey.shade400,
                      margin_container:
                          const EdgeInsets.only(left: 20, right: 20),
                      height_container: 60,
                      body: Row(
                        children: [
                          const SizedBox(width: 15),
                          Icon(Icons.work, color: grey),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              widget.prospecto.referenciaTrabajo != null &&
                                      widget.prospecto.referenciaTrabajo!
                                          .isNotEmpty
                                  ? widget.prospecto.referenciaTrabajo!
                                      .replaceAll("  ", " ")
                                  : "No se ha agregado una referencia",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          widget.prospecto.fotoRefTrabajo != null
                              ? IconButton(
                                  onPressed: () => verFoto(
                                      widget.prospecto.fotoRefTrabajo!,
                                      "trabajo"),
                                  icon:
                                      const Icon(Icons.remove_red_eye_outlined))
                              : Container()
                        ],
                      ),
                      has_header: false,
                      has_title: true,
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            alignment: Alignment.center,
                            width: 175,
                            color: Colors.white,
                            margin: const EdgeInsets.only(left: 35, top: 8),
                            child: Text(
                              "Referencia trabajo",
                              style: TextStyle(
                                color: grey,
                                fontSize: 17,
                              ),
                            )),
                      ),
                    ),
                    //
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
        if (loading) loadingWidget(text: "Cargando...")
      ],
    );
  }

  Widget botonesGestionar() {
    return Container(
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
                      builder: (builder) => AgregarEditarProspecto(
                            edit: true,
                            prospecto: widget.prospecto,
                          ))),
              icon: const Icon(Icons.edit)),
          if (widget.prospecto.cliente == 0)
            IconButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (builder) {
                        return Platform.isAndroid
                            ? AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                title: const Text("Eliminar prospecto"),
                                content: const Text(
                                    "¿Desea eliminar este prospecto?"),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Cancelar")),
                                  TextButton(
                                      onPressed: () async {
                                        await op
                                            .eliminarProspecto(
                                                widget.prospecto.idProspecto!)
                                            .then((value) {
                                          if (value == 1) {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            flushBarGlobal(
                                                context,
                                                "Prospecto eliminado correctamente",
                                                const Icon(Icons.check,
                                                    color: Colors.green));
                                          } else {
                                            Navigator.pop(context);
                                            flushBarGlobal(
                                                context,
                                                "No se eliminó el prospecto, inténtelo más tarde",
                                                const Icon(Icons.error,
                                                    color: Colors.red));
                                          }
                                        });
                                      },
                                      child: Text(
                                        "Eliminar",
                                        style: TextStyle(color: Colors.red),
                                      ))
                                ],
                              )
                            : CupertinoAlertDialog(
                                title: const Text("Eliminar prospecto"),
                                content: const Text(
                                    "¿Desea eliminar este prospecto?"),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancelar")),
                                  TextButton(
                                      onPressed: () async {
                                        await op
                                            .eliminarProspecto(
                                                widget.prospecto.idProspecto!)
                                            .then((value) {
                                          if (value == 1) {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            flushBarGlobal(
                                                context,
                                                "Prospecto eliminado correctamente",
                                                const Icon(Icons.check,
                                                    color: Colors.green));
                                          } else {
                                            Navigator.pop(context);
                                            flushBarGlobal(
                                                context,
                                                "No se eliminó el prospecto, inténtelo más tarde",
                                                const Icon(Icons.error,
                                                    color: Colors.red));
                                          }
                                        });
                                      },
                                      child: Text(
                                        "Eliminar",
                                        style: TextStyle(color: Colors.red),
                                      ))
                                ],
                              );
                      });
                },
                icon: const Icon(Icons.delete))
        ],
      ),
    );
  }

  Widget infoPrincipal(initials) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 15),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100), color: Colors.black),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    widget.prospecto.nombres,
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                //const SizedBox(height: 5),
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
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
                        widget.prospecto.celular.isNotEmpty
                            ? widget.prospecto.celular
                            : "no phone number",
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
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
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
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
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  verFoto(String path, String from) {
    final rsp = Responsive.of(context);
    Uint8List bytes = base64Decode(path);
    showModalBottomSheet(
        showDragHandle: true,
        context: context,
        builder: (builder) {
          return Container(
            height: rsp.hp(60),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(child: Text("Foto referencia del $from")),
                SizedBox(height: 15),
                Expanded(child: Image.memory(bytes)),
                SizedBox(height: 15),
              ],
            ),
          );
        });
  }
}
