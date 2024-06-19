// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kmello_app/src/controller/dataBase/operations.dart';
import 'package:kmello_app/src/models/prospectos_model.dart';
import 'package:kmello_app/utils/buttons.dart';
import 'package:kmello_app/utils/deviders/divider.dart';
import 'package:kmello_app/utils/flushbar.dart';
import 'package:kmello_app/utils/geolocator/geolocator.dart';
import 'package:kmello_app/utils/header.dart';
import 'package:kmello_app/utils/loading.dart';
import 'package:kmello_app/utils/textFields/input_text_form_fields.dart';
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

  String latitud = "";
  String longitud = "";

  final op = Operations();

  List<Contact> contactos = [];
  bool showContacts = false;
  List<Contact> _searchList = [];
  bool loading = false;

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
        txtEmpresa.text = res.empresa;
        txtMail.text = res.mail;
        txtNombres.text = res.nombres;
        txtReference.text = res.referencia;
        latitud = res.latitud;
        longitud = res.longitud;
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
    return Stack(
      children: [
        Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                header(widget.edit ? "Editar prospecto" : "Agregar prospecto",
                    KmelloIcons.prospectos,
                    context: context),
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
                    nombreCampo: "Empresa",
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
                Row(
                  children: [
                    Expanded(
                      child: InputTextFormFields(
                          controlador: txtDireccion,
                          capitalization: TextCapitalization.sentences,
                          prefixIcon: const Icon(Icons.house),
                          inputBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0)),
                          accionCampo: TextInputAction.next,
                          nombreCampo: "Dirección",
                          placeHolder: "Ingrese la dirección del cliente"),
                    ),
                    IconButton(
                        onPressed: () async {
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
                                const Icon(Icons.check, color: Colors.green));
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
                  ],
                ),
                const SizedBox(height: 20),
                InputTextFormFields(
                    controlador: txtReference,
                    prefixIcon: const Icon(Icons.add_home_work_outlined),
                    inputBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0)),
                    accionCampo: TextInputAction.done,
                    maxLines: 2,
                    nombreCampo: "Referencia",
                    placeHolder:
                        "Ej: Frente a una farmacia y diagonal a una tienda"),
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
                    if (txtNombres.text.isNotEmpty) const SizedBox(width: 15),
                    nextButton(
                        onPressed: validateButton, text: "GUARDAR", width: 100),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        contactsContainer()
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
          celular2: txtCelular2.text,
          latitud: latitud,
          longitud: longitud,
          referencia: txtReference.text,
          idProspecto: widget.edit ? widget.prospecto!.idProspecto : null,
          mail: txtMail.text,
          celular: txtCelular.text,
          direccion: txtDireccion.text,
          nombres: txtNombres.text,
          empresa: txtEmpresa.text);

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
