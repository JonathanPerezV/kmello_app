// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:abi_praxis/src/controller/dataBase/operations.dart';
import 'package:abi_praxis/src/models/prospectos_model.dart';
import 'package:abi_praxis/utils/buttons.dart';
import 'package:abi_praxis/utils/deviders/divider.dart';
import 'package:abi_praxis/utils/flushbar.dart';
import 'package:abi_praxis/utils/geolocator/geolocator.dart';
import 'package:abi_praxis/utils/header.dart';
import 'package:abi_praxis/utils/loading.dart';
import 'package:abi_praxis/utils/selectFile/select_file.dart';
import 'package:abi_praxis/utils/textFields/input_text_form_fields.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../../../../utils/app_bar.dart';
import '../../../../../../../utils/icons/kmello_icons_icons.dart';
import '../../../../lateralMenu/drawer_menu.dart';

class AgregarEditarProspecto extends StatefulWidget {
  bool edit;
  ProspectosModel? prospecto;

  AgregarEditarProspecto({super.key, required this.edit, this.prospecto}) {
    if (edit && prospecto == null) {
      throw ArgumentError("El prospecto es requerido cuando edit es true");
    }
  }

  @override
  State<AgregarEditarProspecto> createState() => _AgregarEditarProspectoState();
}

class _AgregarEditarProspectoState extends State<AgregarEditarProspecto> {
  final _sckey = GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();

  final txtContacto = TextEditingController();
  final txtNombres = TextEditingController();
  final txtEmpresa = TextEditingController();
  final txtDireccion = TextEditingController();
  final txtCelular = TextEditingController();
  final txtCelular2 = TextEditingController();
  final txtMail = TextEditingController();
  final txtReference = TextEditingController();
  final txtReferenceTrabajo = TextEditingController();
  final txtDireccionTrabajo = TextEditingController();

  //todo BORRAR ESTOS CAMPOS Y CORREGIR ERRORES
  //String francLat = "-2.165758102";
  //String francLong = "-79.87811601";

  String latitud = "";
  String longitud = "";
  String? pathCasa;

  String latitudTrabajo = "";
  String longitudTrabajo = "";
  String? pathTrabajo;

  final op = Operations();

  List<Contact> contactos = [];
  bool showContacts = false;
  List<Contact> _searchList = [];
  bool loading = false;

  bool refCasa = false;
  bool refTra = false;

  final file = SeleccionArchivos();

  void requestPermissionContacts() async {
    if (await FlutterContacts.requestPermission()) {
      final allContacts =
          await FlutterContacts.getContacts(withProperties: true);

      setState(() => contactos = allContacts);
      setState(() => _searchList = allContacts);
    }
  }

  void getData() async {
    setState(() => loading = true);

    var res = await op.obtenerProspecto(id: widget.prospecto!.idProspecto);

    if (res != null) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        txtCelular.text = res.celular;
        txtCelular2.text = res.celular2;
        txtDireccion.text = res.direccion;
        txtDireccionTrabajo.text = res.direccionTrabajo;
        txtEmpresa.text = res.empresa;
        txtMail.text = res.mail;
        txtNombres.text = res.nombres;
        txtReference.text = res.referencia;
        txtReferenceTrabajo.text = res.referenciaTrabajo ?? "";
        pathCasa = res.fotoRefCasa;
        if (pathCasa != null) refCasa = true;
        pathTrabajo = res.fotoRefTrabajo;
        if (pathTrabajo != null) refTra = true;
        latitud = res.latitud;
        longitud = res.longitud;
        latitudTrabajo = res.latitudTrabajo;
        longitudTrabajo = res.longitudTrabajo;
      });
    }
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    requestPermissionContacts();
    if (widget.edit) {
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() => showContacts = false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _sckey,
        appBar: MyAppBar(key: _sckey).myAppBar(),
        drawer: drawerMenu(context),
        body: Stack(
          children: [
            options(),
            if (loading) loadingWidget(text: "Obteniendo datos...")
          ],
        ),
      ),
    );
  }

  Widget options() {
    return Column(
      children: [
        header(
            widget.edit
                ? widget.prospecto!.cliente == 1
                    ? "Editar cliente"
                    : "Editar prospecto"
                : "Agregar prospecto",
            KmelloIcons.prospectos,
            context: context),
        Expanded(
          child: Stack(
            children: [
              Form(
                key: _formkey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 25),
                      if (contactos.isNotEmpty && !widget.edit)
                        InputTextFormFields(
                            controlador: txtContacto,
                            onChanged: (value) {
                              if (value!.isNotEmpty) {
                                setState(() => showContacts = true);
                                buildSearchList(value);
                              } else {
                                setState(() => _searchList = contactos);
                                setState(() => showContacts = false);
                              }
                            },
                            prefixIcon: const Icon(Icons.search),
                            inputBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            accionCampo: TextInputAction.done,
                            nombreCampo: "Buscar en mis contactos",
                            placeHolder: "Buscar en mis contactos"),
                      if (contactos.isNotEmpty && !widget.edit)
                        const SizedBox(height: 25),
                      if (contactos.isNotEmpty && !widget.edit) divider(true),
                      const SizedBox(height: 25),
                      InputTextFormFields(
                          controlador: txtNombres,
                          validacion: (value) => value != null && value.isEmpty
                              ? "Campo obligatorio*"
                              : null,
                          prefixIcon: const Icon(Icons.person),
                          capitalization: TextCapitalization.words,
                          inputBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0)),
                          accionCampo: TextInputAction.next,
                          nombreCampo: "Nombres",
                          placeHolder: "Ej: Jose Pérez"),
                      const SizedBox(height: 20),
                      InputTextFormFields(
                          controlador: txtEmpresa,
                          capitalization: TextCapitalization.sentences,
                          prefixIcon: const Icon(Icons.work),
                          inputBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0)),
                          accionCampo: TextInputAction.next,
                          nombreCampo: "Negocio / Empresa",
                          placeHolder: "Ej: Mi Empresa S.A"),
                      const SizedBox(height: 20),
                      InputTextFormFields(
                          controlador: txtCelular,
                          tipoTeclado: TextInputType.number,
                          validacion: (value) => value != null && value.isEmpty
                              ? "Campo obligatorio*"
                              : null,
                          prefixIcon: Platform.isAndroid
                              ? const Icon(Icons.phone_android_sharp)
                              : const Icon(Icons.phone_iphone_sharp),
                          inputBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0)),
                          accionCampo: TextInputAction.done,
                          nombreCampo: "Celular",
                          placeHolder: "Ej: 000000000"),
                      const SizedBox(height: 20),
                      InputTextFormFields(
                          controlador: txtCelular2,
                          tipoTeclado: TextInputType.number,
                          prefixIcon: Platform.isAndroid
                              ? const Icon(Icons.phone_android_sharp)
                              : const Icon(Icons.phone_iphone_sharp),
                          inputBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0)),
                          accionCampo: TextInputAction.done,
                          nombreCampo: "Celular 2",
                          placeHolder: "Ej: 000000000"),
                      const SizedBox(height: 20),
                      InputTextFormFields(
                          controlador: txtMail,
                          tipoTeclado: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.mail),
                          inputBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0)),
                          accionCampo: TextInputAction.next,
                          nombreCampo: "Correo electrónico",
                          placeHolder: "Ej: juan.perez@hotmail.com"),
                      const SizedBox(height: 20),
                      InputTextFormFields(
                        controlador: txtDireccion,
                        capitalization: TextCapitalization.sentences,
                        prefixIcon: const Icon(Icons.house),
                        inputBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                        accionCampo: TextInputAction.next,
                        nombreCampo: "Dirección Domicilio",
                        placeHolder: "Ingrese la dirección del cliente",
                        icon: IconButton(
                            onPressed: () async {
                              /* if (txtDireccion.text.isEmpty) {
                                flushBarGlobal(
                                    context,
                                    "Debe ingresar la dirección de la casa para poder geolocalizar.",
                                    const Icon(Icons.error, color: Colors.red));
                                return;
                              }*/
                              setState(() => loading = true);

                              var res = await GeolocatorConfig()
                                  .requestPermission(context);

                              if (res != null) {
                                var loc = await Geolocator.getCurrentPosition();

                                setState(() {
                                  latitud = loc.latitude.toString();
                                  longitud = loc.longitude.toString();
                                });

                                debugPrint("$latitud, $longitud");

                                flushBarGlobal(
                                    context,
                                    "Se han guardado las coordenadas de tu ubicación actual.",
                                    const Icon(Icons.check,
                                        color: Colors.green));
                              } else {
                                flushBarGlobal(
                                    context,
                                    "Ocurrió un error, no hemos podido guardar tu ubicación actual",
                                    const Icon(Icons.error, color: Colors.red));
                              }

                              setState(() => loading = false);
                            },
                            icon: latitud != "" && longitud != ""
                                ? const Icon(
                                    Icons.location_on,
                                    color: Colors.green,
                                  )
                                : const Icon(Icons.add_location_alt)),
                      ),
                      const SizedBox(height: 20),
                      InputTextFormFields(
                        controlador: txtReference,
                        prefixIcon: const Icon(Icons.add_home_work_outlined),
                        inputBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                        accionCampo: TextInputAction.done,
                        maxLines: 2,
                        nombreCampo: "Referencia domicilio",
                        placeHolder:
                            "Ej: Frente a una farmacia y diagonal a una tienda",
                        icon: IconButton(
                          icon: Icon(
                            Icons.camera_alt_outlined,
                            color: refCasa ? Colors.green : Colors.black,
                          ),
                          onPressed: () async {
                            final path = await file.selectOrCaptureImage(
                                ImageSource.camera, context);
                            if (path != null) {
                              final bytes = await File(path).readAsBytes();
                              setState(() => refCasa = true);
                              setState(() => pathCasa = base64Encode(bytes));
                              flushBarGlobal(
                                  context,
                                  "Foto de referencia del domicilio cargada.",
                                  const Icon(Icons.check, color: Colors.green));
                            } else {
                              flushBarGlobal(context, "Se canceló la acción",
                                  const Icon(Icons.error, color: Colors.red));
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      InputTextFormFields(
                        controlador: txtDireccionTrabajo,
                        capitalization: TextCapitalization.sentences,
                        prefixIcon: const Icon(Icons.house),
                        inputBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                        accionCampo: TextInputAction.next,
                        nombreCampo: "Dirección Trabajo",
                        placeHolder: "Ingrese la dirección del cliente",
                        icon: IconButton(
                            onPressed: () async {
                              /*if (txtDireccionTrabajo.text.isEmpty) {
                                flushBarGlobal(
                                    context,
                                    "Debe ingresar la dirección del trabajo para poder geolocalizar.",
                                    const Icon(Icons.error, color: Colors.red));
                                return;
                              }*/
                              setState(() => loading = true);

                              var res = await GeolocatorConfig()
                                  .requestPermission(context);

                              if (res != null) {
                                var loc = await Geolocator.getCurrentPosition();

                                setState(() {
                                  latitudTrabajo = loc.latitude.toString();
                                  longitudTrabajo = loc.longitude.toString();
                                });

                                debugPrint("$latitudTrabajo, $longitudTrabajo");

                                flushBarGlobal(
                                    context,
                                    "Se han guardado las coordenadas de tu ubicación actual.",
                                    const Icon(Icons.check,
                                        color: Colors.green));
                              } else {
                                flushBarGlobal(
                                    context,
                                    "Ocurrió un error, no hemos podido guardar tu ubicación actual",
                                    const Icon(Icons.error, color: Colors.red));
                              }

                              setState(() => loading = false);
                            },
                            icon: latitudTrabajo != "" && longitudTrabajo != ""
                                ? const Icon(
                                    Icons.location_on,
                                    color: Colors.green,
                                  )
                                : const Icon(Icons.add_location_alt)),
                      ),
                      const SizedBox(height: 20),
                      InputTextFormFields(
                        controlador: txtReferenceTrabajo,
                        prefixIcon: const Icon(Icons.add_home_work_outlined),
                        inputBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                        accionCampo: TextInputAction.done,
                        maxLines: 2,
                        nombreCampo: "Referencia trabajo",
                        placeHolder:
                            "Ej: Frente a una farmacia y diagonal a una tienda",
                        icon: IconButton(
                          icon: Icon(
                            Icons.camera_alt_outlined,
                            color: refTra ? Colors.green : Colors.black,
                          ),
                          onPressed: () async {
                            final path = await file.selectOrCaptureImage(
                                ImageSource.camera, context);
                            if (path != null) {
                              final bytes = await File(path).readAsBytes();
                              setState(() => refTra = true);
                              setState(() => pathTrabajo = base64Encode(bytes));
                              flushBarGlobal(
                                  context,
                                  "Foto de referencia del trabajo cargada.",
                                  const Icon(Icons.check, color: Colors.green));
                            } else {
                              flushBarGlobal(context, "Se canceló la acción",
                                  const Icon(Icons.error, color: Colors.red));
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (txtNombres.text.isNotEmpty && !widget.edit)
                            nextButton(
                                onPressed: clearText,
                                text: "LIMPIAR",
                                width: 100,
                                background: Colors.red),
                          if (txtNombres.text.isNotEmpty)
                            const SizedBox(width: 15),
                          nextButton(
                              onPressed: validateButton,
                              text: "GUARDAR",
                              width: 100),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              contactsContainer()
            ],
          ),
        ),
      ],
    );
  }

  Widget contactsContainer() {
    return Align(
      alignment: Alignment.center,
      child: AnimatedOpacity(
        opacity: showContacts ? 1 : 0,
        duration: const Duration(milliseconds: 500),
        child: Visibility(
          visible: showContacts,
          child: GestureDetector(
            onTap: () {
              debugPrint("hola");
            },
            child: Container(
              margin: const EdgeInsets.only(top: 62, left: 10, right: 10),
              width: double.infinity, //250,
              height: 225,
              child: Material(
                borderRadius: BorderRadius.circular(15),
                elevation: 4,
                child: Container(
                  margin: const EdgeInsets.all(3),
                  child: ListView.builder(
                      itemCount: _searchList.length,
                      itemBuilder: (itemBuilder, i) {
                        return InkWell(
                          onTap: () => setState(() {
                            showContacts = false;
                            FocusScope.of(context).unfocus();
                            txtContacto.text = _searchList[i].displayName;
                            txtNombres.text = _searchList[i].displayName;

                            txtCelular.text = (_searchList[i]
                                .phones[0]
                                .number
                                .replaceAll(" ", "-")
                                .replaceAll("+593-", "+593"));

                            if (_searchList[i].phones.length > 1) {
                              txtCelular2.text =
                                  _searchList[i].phones[1].number;
                            }
                            txtMail.text = _searchList[i].emails[0].address;
                            txtEmpresa.text =
                                _searchList[i].organizations[0].company;
                            txtDireccion.text =
                                _searchList[i].addresses[0].address;
                            txtDireccionTrabajo.text =
                                _searchList[i].addresses[1].address;
                            txtCelular.text = _searchList[i].phones[0].number;
                          }),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            color: Colors.white,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              height: 45,
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Row(
                                children: [
                                  Text(
                                    _searchList[i].displayName,
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                      child: Align(
                                    alignment: Alignment.centerRight,
                                    child:
                                        Text(_searchList[i].phones[0].number),
                                  ))
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void clearText() {
    setState(() {
      FocusScope.of(context).unfocus();
      txtCelular.clear();
      txtCelular2.clear();
      txtContacto.clear();
      txtDireccion.clear();
      txtEmpresa.clear();
      txtNombres.clear();
      txtMail.clear();
      latitud = "";
      longitud = "";
      txtReference.clear();
    });
  }

  void validateButton() async {
    if (_formkey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final prospecto = ProspectosModel(
          direccionTrabajo: txtDireccionTrabajo.text,
          celular2: txtCelular2.text,
          latitud: latitud, //francLat,
          longitud: longitud, //francLong,
          referencia: txtReference.text,
          idProspecto: widget.edit ? widget.prospecto!.idProspecto : null,
          mail: txtMail.text,
          celular: txtCelular.text,
          direccion: txtDireccion.text,
          nombres: txtNombres.text,
          empresa: txtEmpresa.text,
          latitudTrabajo: latitudTrabajo,
          longitudTrabajo: longitudTrabajo,
          fotoRefCasa: pathCasa,
          fotoRefTrabajo: pathTrabajo,
          referenciaTrabajo: txtReferenceTrabajo.text,
          cliente: 0);

      if (!widget.edit) {
        final res = await op.insertarProspecto(prospecto);

        if (res == 100) {
          flushBarGlobal(context, "Ya existe un prospecto con este número",
              const Icon(Icons.error, color: Colors.red));
        } else {
          clearText();
          flushBarGlobal(context, "Prospecto agregado correctamente",
              const Icon(Icons.check, color: Colors.green));
        }

        debugPrint("resultado: $res");
      } else {
        final res =
            await op.actualizarProspecto(prospecto.idProspecto!, prospecto);

        if (res == 1) {
          Navigator.pop(context);
          Navigator.pop(context);
          flushBarGlobal(context, "Prospecto actualizado correctamente",
              const Icon(Icons.check, color: Colors.green));
        } else {
          flushBarGlobal(context, "No se pudo actualizar el prospecto",
              const Icon(Icons.error, color: Colors.red));
        }
      }
    } else {
      return;
    }
  }

  void buildSearchList(text) {
    if (text != "") {
      final list = contactos
          .where((element) => element.displayName
              .toLowerCase()
              .contains(text.toString().toLowerCase()))
          .toList();
      if (list.isNotEmpty) {
        setState(() => _searchList = list);
      } else {
        setState(() => showContacts = false);
      }
    } else {
      setState(() => _searchList = contactos);
    }
  }
}
