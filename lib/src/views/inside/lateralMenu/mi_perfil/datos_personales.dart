// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:abi_praxis/src/controller/aws/recognition/upload_image_s3.dart';
import 'package:abi_praxis/src/controller/aws/ws_usuario.dart';
import 'package:abi_praxis/src/controller/preferences/user_preferences.dart';
import 'package:abi_praxis/src/models/user_moderl.dart';
import 'package:abi_praxis/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:abi_praxis/src/views/register/verificatePin/verificate_pin.dart';
import 'package:abi_praxis/utils/app_bar.dart';
import 'package:abi_praxis/utils/buttons.dart';
import 'package:abi_praxis/utils/datePicker/date_picker_platform.dart';
import 'package:abi_praxis/utils/deviders/divider.dart';
import 'package:abi_praxis/utils/flushbar.dart';
import 'package:abi_praxis/utils/header.dart';
import 'package:abi_praxis/utils/loading.dart';
import 'package:abi_praxis/utils/paisesHabiles/retornar_resultados.dart';
import 'package:abi_praxis/utils/selectFile/select_file.dart';
import 'package:abi_praxis/utils/textFields/input_text_fields.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../../utils/paisesHabiles/paises.dart';
import '../../../../controller/sms/ws_sms.dart';

class DatosPersonales extends StatefulWidget {
  const DatosPersonales({super.key});

  @override
  State<DatosPersonales> createState() => _DatosPersonalesState();
}

class _DatosPersonalesState extends State<DatosPersonales> {
  final wsUser = WSUsuario();
  final aws = UploadImageS3();
  String currentPhone = "";
  final sckey = GlobalKey<ScaffoldState>();
  final txtNombres = TextEditingController();
  final txtApellidos = TextEditingController();
  final txtCedula = TextEditingController();
  final txtPais = TextEditingController();
  final txtProvincia = TextEditingController();
  final txtCiudad = TextEditingController();
  final txtFechaNac = TextEditingController();
  final txtCelular = TextEditingController();
  final txtCorreo = TextEditingController();

  String? pathImage;

  List<String> listPaises = ['Ecuador'];
  String? pais;

  List<Map<String, dynamic>> listaProvincias = [];
  String? provincia;
  bool provinciasVisible = false;
  String? hintTextProvincia;

  List<String> listaCiudades = [];
  String? ciudad;
  bool ciudadesVisible = false;
  String? hintTextCiudad;

  bool editarPerfil = false;
  bool loading = false;
  bool updating = false;
  bool sendPin = false;

  DateTime? _formatDate;
  String? fechaNac;

  @override
  void initState() {
    super.initState();
    obtenerDatos();
  }

  void obtenerDatos() async {
    setState(() => loading = true);
    final data = await wsUser.obtenerDatosUsuario();

    if (data["status"] == "ok") {
      UserModel usuarioData = data["data"];

      setState(() {
        txtNombres.text = usuarioData.nombres!;
        txtApellidos.text = usuarioData.apellidos!;
        txtCedula.text = usuarioData.cedula!;
        txtPais.text = usuarioData.pais!;
        if (usuarioData.foto != null && usuarioData.foto != "") {
          pathImage = usuarioData.foto;
        }
        pais = usuarioData.pais;
        if (pais != null) {
          provinciasVisible = true;
          funcionPais(pais);
        }
        txtProvincia.text = usuarioData.provincia!;
        provincia = usuarioData.provincia;
        if (provincia != null) {
          ciudadesVisible = true;
          funcionProvincia(provincia!);
        }
        txtCiudad.text = usuarioData.ciudad!;
        ciudad = usuarioData.ciudad;
        txtFechaNac.text = DateFormat("dd/MM/yyyy")
            .format(DateTime.parse(usuarioData.fechaNacimiento!));
        _formatDate = DateTime.parse(usuarioData.fechaNacimiento!);
        txtCelular.text = usuarioData.celular!;
        currentPhone = usuarioData.celular!;
        txtCorreo.text = usuarioData.correo!;
      });
    } else {
      Navigator.pop(context);
      flushBarGlobal(
          context,
          "No se pudo obtener los datos, inténtelo más tarde.",
          const Icon(
            Icons.error,
            color: Colors.red,
          ));
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        key: sckey,
        appBar: MyAppBar(key: sckey).myAppBar(),
        drawer: drawerMenu(context, inicio: false),
        body: options(),
      ),
    );
  }

  Widget options() => Column(
        children: [
          header("Datos personales", null,
              context: context, color: Colors.grey.shade600),
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(children: [
                    foto(),
                    divider(false, color: Colors.grey),
                    formulario(),
                  ]),
                ),
                if (loading) loadingWidget(text: "Cargando datos..."),
                if (updating) loadingWidget(text: "Actualizando..."),
                if (sendPin) loadingWidget(text: "Enviando pin...")
              ],
            ),
          ),
        ],
      );

  Widget foto() => SizedBox(
        width: double.infinity,
        height: 105,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(100),
              onLongPress: () {
                if (pathImage != null) {
                  //onLongPressPhoto(dotenv.env["ws_dominio"]! + pathImage!);
                }
              },
              onTap: () => showModal(),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey.shade300,
                ),
                width: 60,
                height: 60,
                child: pathImage == null
                    ? const Icon(Icons.person)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          "${dotenv.env["ws_dominio"]! + pathImage!}?timestamp=${DateTime.now().millisecondsSinceEpoch}",
                          key: UniqueKey(),
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                                child: LoadingAnimationWidget.discreteCircle(
                                    color: Colors.black, size: 30));
                          },
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(onTap: () => showModal(), child: const Text("Editar foto"))
          ],
        ),
      );

  Widget formulario() => Container(
        margin: const EdgeInsets.only(left: 15, right: 10),
        child: Form(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text(
                        "Nombres:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: InputTextFields(
                        controlador: txtNombres,
                        habilitado: editarPerfil,
                        placeHolder: "Ingrese sus nombres",
                        nombreCampo: "",
                        accionCampo: TextInputAction.next),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text(
                        "Apellidos:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: InputTextFields(
                        controlador: txtApellidos,
                        habilitado: editarPerfil,
                        placeHolder: "Ingrese sus apellidos",
                        nombreCampo: "",
                        accionCampo: TextInputAction.next),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text(
                        "Cédula de identidad:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: InputTextFields(
                        controlador: txtCedula,
                        habilitado: false,
                        placeHolder: "Ingrese sus cédula",
                        nombreCampo: "",
                        accionCampo: TextInputAction.next),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text(
                        "País:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  editarPerfil
                      ? Expanded(
                          flex: 3,
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: DropdownButtonFormField<String>(
                                value: pais,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Campo obligatorio *';
                                  } else {
                                    return null;
                                  }
                                },
                                items: listPaises.map((e) {
                                  return DropdownMenuItem(
                                      child: Text(e), value: e);
                                }).toList(),
                                onChanged: (value) async {
                                  setState(() {
                                    pais = value;
                                    txtPais.text = pais!;
                                    if (provincia != null || ciudad != null) {
                                      provincia = null;
                                      ciudad = null;
                                    }
                                    provinciasVisible = true;
                                  });
                                  funcionPais(pais);
                                }),
                          ),
                        )
                      : Expanded(
                          flex: 3,
                          child: InputTextFields(
                              controlador: txtPais,
                              habilitado: editarPerfil,
                              placeHolder: "Ingrese su país de residencia",
                              nombreCampo: "",
                              accionCampo: TextInputAction.next),
                        )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text(
                        "Provincia:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  editarPerfil
                      ? Visibility(
                          visible: provinciasVisible,
                          child: Expanded(
                            flex: 3,
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: AbsorbPointer(
                                absorbing: hintTextProvincia != 'cargando...'
                                    ? false
                                    : true,
                                child: DropdownButtonFormField<String>(
                                    value: provincia,
                                    validator: (value) {
                                      if (pais != null) {
                                        if (value == null || value.isEmpty) {
                                          return 'Llene este campo para continuar';
                                        } else {
                                          return null;
                                        }
                                      } else {
                                        return null;
                                      }
                                    },
                                    menuMaxHeight: 300,
                                    enableFeedback: false,
                                    hint:
                                        Text(hintTextProvincia ?? 'Seleccione'),
                                    items: listaProvincias.map((e) {
                                      return DropdownMenuItem<String>(
                                        child: Text("${e['nombre']}"),
                                        value: e['nombre'],
                                      );
                                    }).toList(),
                                    onChanged: (value) async {
                                      setState(() {
                                        provincia = value;
                                        txtProvincia.text = provincia!;
                                        ciudad = null;
                                      });
                                      ciudadesVisible = true;

                                      funcionProvincia(provincia!);
                                    }),
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          flex: 3,
                          child: InputTextFields(
                              controlador: txtProvincia,
                              habilitado: editarPerfil,
                              placeHolder: "Ingrese su provincia de residencia",
                              nombreCampo: "",
                              accionCampo: TextInputAction.next),
                        )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text(
                        "Ciudad:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  editarPerfil
                      ? Visibility(
                          visible: ciudadesVisible,
                          child: Expanded(
                            flex: 3,
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: AbsorbPointer(
                                absorbing: hintTextCiudad != 'cargando...'
                                    ? false
                                    : true,
                                child: DropdownButtonFormField<String>(
                                    validator: (value) {
                                      if (provincia != null) {
                                        if (value == null || value.isEmpty) {
                                          return 'Llene este campo para continuar';
                                        } else {
                                          return null;
                                        }
                                      } else {
                                        return null;
                                      }
                                    },
                                    menuMaxHeight: 300,
                                    enableFeedback: false,
                                    value: ciudad,
                                    items: listaCiudades.map((e) {
                                      return DropdownMenuItem<String>(
                                        child: Text(e),
                                        value: e,
                                      );
                                    }).toList(),
                                    onChanged: (value) async {
                                      setState(() {
                                        ciudad = value;
                                        txtCiudad.text = ciudad!;
                                      });
                                    }),
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          flex: 3,
                          child: InputTextFields(
                              controlador: txtCiudad,
                              habilitado: editarPerfil,
                              placeHolder: "Ingrese su ciudad de residencia",
                              nombreCampo: "",
                              accionCampo: TextInputAction.next),
                        )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text(
                        "Fecha de nacimiento:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Expanded(
                          child: InputTextFields(
                              controlador: txtFechaNac,
                              habilitado: false,
                              placeHolder: "Ingrese su fecha",
                              nombreCampo: "",
                              accionCampo: TextInputAction.next),
                        ),
                        if (editarPerfil)
                          IconButton(
                              onPressed: () async {
                                Platform.isAndroid
                                    ? await datePickerForAndroid(
                                            context: context,
                                            initialDate: _formatDate)
                                        .then((value) {
                                        if (value != null) {
                                          setState(() {
                                            _formatDate = value["date"];
                                            txtFechaNac.text =
                                                value["date_string"];
                                          });
                                        }
                                      })
                                    : await datePickerForIos(
                                            context: context,
                                            initialDate: _formatDate)
                                        .then((value) {
                                        if (value != null) {
                                          setState(() {
                                            _formatDate = value["date"];
                                            txtFechaNac.text =
                                                value["date_string"];
                                          });
                                        }
                                      });
                              },
                              icon: const Icon(Icons.edit))
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text(
                        "Número celular:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: InputTextFields(
                        textInputFormatter: [
                          LengthLimitingTextInputFormatter(10)
                        ],
                        tipoTeclado: TextInputType.number,
                        controlador: txtCelular,
                        habilitado: editarPerfil,
                        placeHolder: "Ingrese su número de celular",
                        nombreCampo: "",
                        accionCampo: TextInputAction.next),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text(
                        "Correo:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: InputTextFields(
                        controlador: txtCorreo,
                        habilitado: false,
                        placeHolder: "Ingrese su correo electrónico",
                        nombreCampo: "",
                        accionCampo: TextInputAction.next),
                  ),
                ],
              ),
              const Row(
                children: [],
              ),
              const SizedBox(height: 30),
              if (!editarPerfil)
                nextButton(
                    onPressed: () {
                      setState(() => editarPerfil = true);
                    },
                    text: "Editar perfil",
                    width: 125),
              if (editarPerfil)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    nextButton(
                        background: Colors.red,
                        onPressed: () => setState(() => editarPerfil = false),
                        text: "Cancelar",
                        width: 125),
                    nextButton(
                        onPressed: () => actualizarDatos(),
                        text: "Actualizar",
                        width: 125)
                  ],
                ),
              const SizedBox(height: 30)
            ],
          ),
        ),
      );

  void actualizarDatos() async {
    final wsms = WSSms();
    bool? verificado;

    if (currentPhone != txtCelular.text) {
      setState(() => sendPin = true);
      final pin = (Random().nextInt(599999) + 99999).toString();

      final resultPin = await wsms.enviarMensaje(txtCelular.text, pin);

      if (resultPin == "OK") {
        setState(() => sendPin = false);
        debugPrint("pin: $pin");

        bool? result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => VerificationCode(
                      pin: pin,
                      phoneNumber: txtCelular.text,
                      updateUser: true,
                    )));

        setState(() => verificado = result ?? false);
      }
    }

    if (currentPhone != txtCelular.text && !verificado!) {
      flushBarGlobal(
          context,
          "No se verifico el número de celular",
          const Icon(
            Icons.phonelink_erase_rounded,
            color: Colors.red,
          ));
      return;
    }

    setState(() => updating = true);
    final model = UserModel(
        apellidos: txtApellidos.text,
        cedula: txtCedula.text,
        celular: txtCelular.text,
        ciudad: ciudad!,
        correo: txtCorreo.text,
        fechaNacimiento: _formatDate.toString(),
        nombres: txtNombres.text,
        pais: pais!,
        provincia: provincia!);
    final user = await wsUser.actualizarUsuario(model);

    if (user == "si") {
      setState(() => currentPhone = txtCelular.text);
      flushBarGlobal(context, "Usuario actualizado",
          const Icon(Icons.check, color: Colors.green));
    } else {
      flushBarGlobal(context, user, const Icon(Icons.error, color: Colors.red));
    }

    setState(() {
      updating = false;
      editarPerfil = false;
    });
  }

  void funcionPais(String? pais) async {
    listaProvincias.clear();
    if (pais == 'Ecuador') {
      final provincias = listaProvinciasEcuador['provincias'];
      for (var item in provincias) {
        setState(() {
          listaProvincias.add(item);
        });
      }
      setState(() {
        hintTextProvincia = null;
      });
    } else {
      final provincias = listaProvinciasPanama['provincias'];
      for (var item in provincias) {
        setState(() {
          listaProvincias.add(item);
        });
      }
    }
  }

  void funcionProvincia(String provincia) async {
    if (pais == 'Ecuador') {
      final res = obtenerCiudadesEcuadorDe(provincia);
      listaCiudades = res;
    } else {
      final res = obtenerCiudadesPanama(provincia);
      listaCiudades = res;
    }
  }

  void showModal() {
    showModalBottomSheet(
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text(
                    "SELECCIONE UNA OPCIÓN",
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: () async => await SeleccionArchivos()
                                .selectOrCaptureImage(
                                    ImageSource.gallery, context)
                                .then((value) async {
                              if (value != null) {
                                await actionUpdateImage(value);
                              }
                            }),
                        child: const Icon(Icons.photo_album_rounded, size: 60)),
                    const SizedBox(
                        height: 70,
                        child: VerticalDivider(
                            color: Colors.grey, thickness: 1, width: 1)),
                    GestureDetector(
                      onTap: () async => await SeleccionArchivos()
                          .selectOrCaptureImage(ImageSource.camera, context)
                          .then((value) async {
                        if (value != null) {
                          await actionUpdateImage(value);
                        }
                      }),
                      child: const Icon(Icons.camera_alt, size: 60),
                    ),
                    if (pathImage != null)
                      const SizedBox(
                          height: 70,
                          child: VerticalDivider(
                              color: Colors.grey, thickness: 1, width: 1)),
                    if (pathImage != null)
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.delete_forever,
                          size: 60,
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 45),
              ],
            );
          });
        });
  }

  Future<void> actionUpdateImage(String path) async {
    final pfrc = UserPreferences();
    Navigator.pop(context);
    setState(() => pathImage = path);
    debugPrint("path: $pathImage");

    setState(() => updating = true);
    final upload = await aws.uploadImage(File(pathImage!), context,
        bucket: "kmello-dev", folder: "${txtCedula.text}/perfil");

    if (upload.contains("http")) {
      final newPath = upload.split(dotenv.env["ws_dominio"]!);

      setState(() => pathImage = newPath[1]);
      debugPrint("path: $pathImage");

      await pfrc.savePathPhoto(newPath[1]);

      setState(() {});

      final update = await wsUser.actualizarDatoUsuario(
          parametro: newPath[1], dato: "foto");
      if (update == "actualizado") {
        flushBarGlobal(context, "Imagen actualizada",
            const Icon(Icons.check, color: Colors.green));
      } else {
        flushBarGlobal(context, "No se pudo actualizar la imagen",
            const Icon(Icons.error, color: Colors.red));
      }
    } else {
      flushBarGlobal(context, "No se pudo actualizar la imagen",
          const Icon(Icons.error, color: Colors.red));
    }

    setState(() => updating = false);
  }

  /*void onLongPressPhoto(String imagePath) {
    showAnimatedDialog(
        axis: Axis.vertical,
        alignment: Alignment.center,
        barrierDismissible: true,
        context: context,
        curve: Curves.easeInOut,
        builder: (builder) {
          return Platform.isAndroid
              ? AlertDialog(
                  content: Image.network(imagePath),
                )
              : CupertinoAlertDialog(
                  content: Image.network(imagePath),
                );
        },
        animationType: DialogTransitionType.scale,
        duration: const Duration(milliseconds: 300));
  }*/
}
