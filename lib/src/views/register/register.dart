// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_null_comparison, missing_required_param, use_build_context_synchronously
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:abi_praxis/src/controller/aws/ws_usuario.dart';
import 'package:abi_praxis/src/controller/sms/ws_sms.dart';
import 'package:abi_praxis/src/models/user_moderl.dart';
import 'package:abi_praxis/src/views/register/verificatePin/verificate_pin.dart';
import 'package:abi_praxis/utils/alerts/and_alert.dart';
import 'package:abi_praxis/utils/alerts/ios_alert.dart';
import 'package:abi_praxis/utils/buttons.dart';
import 'package:abi_praxis/utils/flushbar.dart';
import 'package:abi_praxis/utils/icons/kmello_icons_icons.dart';
import 'package:abi_praxis/utils/loading.dart';
import '../../../utils/paisesHabiles/paises.dart';
import '../../../utils/paisesHabiles/retornar_resultados.dart';
import '../../../utils/responsive.dart';
import '../../../utils/textFields/input_text_form_fields.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final wsUsuario = WSUsuario();
//= DateTime.utc(1950, 1, 1);
  final focusName = FocusNode();
  final focusLastName = FocusNode();
  final focusId = FocusNode();
  final focusCountry = FocusNode();
  final focusProv = FocusNode();
  final focusCity = FocusNode();
  final focusPhone = FocusNode();
  final focusMail = FocusNode();
  final focsPass1 = FocusNode();
  final focusPass2 = FocusNode();

  var fechaActual = DateTime.now();
  var edad;
  var mesNacimiento;
  var anoNacimiento;
  var diaNacimiento;
  var anoActual;
  var diaActual;
  var mesActual;
  //todos opciones de interes bool
  bool vehiculo = false;
  bool tecnologia = false;
  bool seguro = false;
  bool mascota = false;
  bool hogar = false;
  bool salud = false;
  bool otros = false;
  bool fechaBool = false;
  bool color = false;

  bool conditions = false;
  bool autorization = false;
  DateTime? autorizationDate;
  //todo variables para guardar usuario
  final TextEditingController txtUsuarioEmail = TextEditingController();
  final TextEditingController txtNombres = TextEditingController();
  final TextEditingController txtApellidos = TextEditingController();
  final TextEditingController txtCedula = TextEditingController();
  final TextEditingController txtCelular = TextEditingController();
  final TextEditingController txtContrasena = TextEditingController();
  final TextEditingController txtConfContrasena = TextEditingController();
  final TextEditingController txtEdad = TextEditingController();
  final controllerCodigoPais = TextEditingController();
  DateTime? _formatDate;

  List<int> categoryList = [];

  bool contrasena = true;
  bool confContrasena = true;
  bool loading = false;
  bool sendPin = false;
  String? fechaNac;
  //String _value = 'Ecuador';

  String? nombre;
  String? apellido;
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

  Icon? icon;
  String? imagePais;

  @override
  void initState() {
    super.initState();
    //dataExample();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Theme(
          data: ThemeData.light(),
          child: Scaffold(
            body: body(),
          ),
        ));
  }

  Widget body() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Center(
          child: SizedBox(
            width: 170,
            height: 60,
            child: Image.asset("assets/abi_praxis_logo.png"),
          ),
        ),
        SizedBox(
          height: 60,
          width: double.infinity,
          child: Column(
            children: [
              const Divider(
                height: 1,
                color: Colors.black,
                thickness: 1,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: const Icon(Icons.arrow_back_ios,
                                color: Colors.black, size: 25),
                          ),
                        ),
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  const Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Icon(KmelloIcons.registrarse, size: 25),
                          SizedBox(width: 5),
                          Text('Registrarse',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 21)),
                        ],
                      )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                height: 1,
                color: Colors.black,
                thickness: 1,
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: formulario(context)),
                    const SizedBox(height: 10),
                    botonIngresar(context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              if (loading) loadingWidget(text: "Consultando..."),
              if (sendPin) loadingWidget(text: "Enviando pin..")
            ],
          ),
        ),
      ],
    );
  }

  Widget formulario(BuildContext context) {
    final rsp = Responsive.of(context);
    return Form(
      key: formKey,
      child: Column(
        children: [
          InputTextFormFields(
              focus: focusName,
              validacion: (value) {
                if (value!.isEmpty) {
                  focusName.requestFocus();
                  return 'Campo obligatorio *';
                } else {
                  return null;
                }
              },
              capitalization: TextCapitalization.words,
              controlador: txtNombres,
              placeHolder: 'Ingrese sus nombres',
              nombreCampo: 'Nombres:',
              accionCampo: TextInputAction.next),
          const SizedBox(
            height: 15,
          ),
          //todo APELLIDOS
          InputTextFormFields(
              focus: focusLastName,
              validacion: (value) {
                if (value!.isEmpty) {
                  focusLastName.requestFocus();
                  return 'Campo obligatorio *';
                } else {
                  return null;
                }
              },
              controlador: txtApellidos,
              capitalization: TextCapitalization.words,
              placeHolder: 'Ingrese sus apellidos',
              nombreCampo: 'Apellidos:',
              accionCampo: TextInputAction.next),
          const SizedBox(
            height: 15,
          ),
          //todo CÉDULA DE IDENTIDAD
          InputTextFormFields(
            focus: focusId,
            controlador: txtCedula,
            validacion: (value) {
              if (value!.isEmpty) {
                focusId.requestFocus();
                return 'Campo obligatorio *';
              } else {
                return null;
              }
            },
            listaFormato: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10)
            ],
            tipoTeclado: TextInputType.number,
            placeHolder: 'Ingrese su número de identificación',
            nombreCampo: 'Cédula de identidad:',
            accionCampo: TextInputAction.next,
          ),
          const SizedBox(
            height: 20,
          ),
          //todo FECHA DE NACIMIENTO
          Container(
              width: rsp.wp(90),
              alignment: Alignment.centerLeft,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              height: 45,
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Text('Fecha Nacimiento:',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  // ignore: deprecated_member_use
                  TextButton(
                    onPressed: () async {
                      await showDatePicker(
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Colors.white,
                              // ignore: deprecated_member_use

                              colorScheme: const ColorScheme.light(
                                primary: Colors.black,
                              ),
                              buttonTheme: const ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary),
                            ),
                            child: child!,
                          );
                        },
                        context: context,
                        locale: const Locale('es'),
                        fieldHintText: "dd/mm/yyyy",
                        initialDate: //_formatDate == DateTime.now()
                            /*?*/ DateTime(2006, 12, 31),
                        //: _formatDate,
                        firstDate: DateTime(1930),
                        lastDate: DateTime(2006, 12, 31),
                      ).then((date) {
                        if (date != null) {
                          setState(() {
                            fechaBool = false;
                          });
                          _formatDate = date;
                          fechaNac =
                              DateFormat('yyyy-MM-dd').format(_formatDate!);
                        }
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    _formatDate == null
                                        ? 'Escoja la fecha'
                                        : DateFormat()
                                            .addPattern("dd-MM-yyyy")
                                            .format(_formatDate!),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
          Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Divider(
                  height: 2, color: fechaBool ? Colors.red : Colors.black)),
          const SizedBox(
            height: 10,
          ),
          //todo SELECTOR DE PAIS
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: DropdownButtonFormField<String>(
                focusNode: focusCountry,
                value: pais,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    focusCountry.requestFocus();
                    return 'Campo obligatorio *';
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.location_city),
                  label: Text('País de residencia'),
                ),
                items: listPaises.map((e) {
                  return DropdownMenuItem(child: Text(e), value: e);
                }).toList(),
                onChanged: (value) async {
                  setState(() {
                    pais = value;
                    if (value == 'Ecuador') {
                      controllerCodigoPais.text = '+593';
                      icon = const Icon(Icons.abc);
                      imagePais = 'assets/paises/ecuador.jpg';
                    } else if (value == 'Panamá') {
                      controllerCodigoPais.text = '+507';
                      imagePais = 'assets/paises/panama.jpg';
                      icon = const Icon(Icons.share);
                    }
                    if (provincia != null || ciudad != null) {
                      provincia = null;
                      ciudad = null;
                    }
                    provinciasVisible = true;
                  });

                  funcionPais(pais);
                }),
          ),
          const SizedBox(
            height: 15,
          ),
          Visibility(
            visible: provinciasVisible,
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: AbsorbPointer(
                absorbing: hintTextProvincia != 'cargando...' ? false : true,
                child: DropdownButtonFormField<String>(
                    focusNode: focusProv,
                    validator: (value) {
                      if (pais != null) {
                        if (value == null || value.isEmpty) {
                          focusProv.requestFocus();
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
                    value: provincia,
                    hint: Text(hintTextProvincia ?? 'Seleccione'),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.location_city),
                      label: Text('Provincia de residencia'),
                    ),
                    items: listaProvincias.map((e) {
                      return DropdownMenuItem<String>(
                        child: Text("${e['nombre']}"),
                        value: e['nombre'],
                      );
                    }).toList(),
                    onChanged: (value) async {
                      setState(() {
                        provincia = value;
                        ciudad = null;
                      });
                      ciudadesVisible = true;

                      funcionProvincia(provincia!);
                    }),
              ),
            ),
          ),
          Visibility(
            visible: provinciasVisible,
            child: const SizedBox(
              height: 15,
            ),
          ),
          Visibility(
            visible: ciudadesVisible,
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: AbsorbPointer(
                absorbing: hintTextCiudad != 'cargando...' ? false : true,
                child: DropdownButtonFormField<String>(
                    focusNode: focusCity,
                    validator: (value) {
                      if (provincia != null) {
                        if (value == null || value.isEmpty) {
                          focusCity.requestFocus();
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
                    hint: Text(hintTextCiudad ?? 'Seleccione'),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.location_city),
                      label: Text('Ciudad de residencia'),
                    ),
                    items: listaCiudades.map((e) {
                      return DropdownMenuItem<String>(
                        child: Text(e),
                        value: e,
                      );
                    }).toList(),
                    onChanged: (value) async {
                      setState(() {
                        ciudad = value;
                      });
                    }),
              ),
            ),
          ),
          Visibility(
            visible: ciudadesVisible,
            child: const SizedBox(
              height: 15,
            ),
          ),

          //todo NÚMERO DE TELÉFONO
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Row(
                      children: [
                        if (imagePais != null)
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            width: 25,
                            height: 25,
                            child: Center(child: Image.asset(imagePais!)),
                          ),
                        Expanded(
                          flex: 1,
                          child: InputTextFormFields(
                            placeHolder: '+593',
                            accionCampo: null,
                            controlador: controllerCodigoPais,
                            habilitado: false,
                            inputBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 5),
                      child: const Divider(
                        thickness: 0.5,
                        height: 0.5,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: InputTextFormFields(
                  focus: focusPhone,
                  validacion: (value) {
                    if (value!.isEmpty) {
                      focusPhone.requestFocus();
                      return 'Campo obligatorio *';
                    } else {
                      if (value.length == 10) {
                        return null;
                      } else {
                        focusPhone.requestFocus();
                        return "Complete los 10 dígitos*";
                      }
                    }
                  },
                  controlador: txtCelular,
                  accionCampo: TextInputAction.next,
                  nombreCampo: 'Teléfono Celular:',
                  placeHolder: 'Ingrese su número celular',
                  listaFormato: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10)
                  ],
                  tipoTeclado: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),

          //todo CORREO ELECTRÓNICO
          InputTextFormFields(
              focus: focusMail,
              validacion: (value) {
                if (value!.isEmpty) {
                  focusMail.requestFocus();
                  return 'Campo obligatorio *';
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                if (value!.characters.length > 1) {
                  setState(() {
                    color = false;
                  });
                }
              },
              estilo: TextStyle(color: !color ? Colors.black : Colors.red),
              accionCampo: TextInputAction.next,
              controlador: txtUsuarioEmail,
              nombreCampo: 'Correo:',
              placeHolder: 'Ingrese su dirección de correo electrónico.',
              tipoTeclado: TextInputType.emailAddress),
          const SizedBox(
            height: 20,
          ),
          //todo INGRESAR CONTRASEÑA
          InputTextFormFields(
            focus: focsPass1,
            accionCampo: TextInputAction.next,
            nombreCampo: 'Contraseña',
            placeHolder: 'Ingrese una contraseña',
            controlador: txtContrasena,
            oscurecerTexto: contrasena,
            prefixIcon: const Icon(Icons.lock),
            icon: contrasena ? iconVisibleOff() : iconVisible(),
            validacion: (value) {
              return _funtionValidator(
                  value,
                  'Es necesario ingrear un valor',
                  'Las contraseñas no coinciden',
                  txtContrasena,
                  txtConfContrasena);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          //todo CONFIRMAR CONTRASEÑA
          InputTextFormFields(
            focus: focusPass2,
            accionCampo: TextInputAction.go,
            nombreCampo: 'Confirmar contraseña',
            placeHolder: 'Repita la contraseña',
            controlador: txtConfContrasena,
            oscurecerTexto: confContrasena,
            prefixIcon: const Icon(Icons.lock),
            icon: confContrasena
                ? iconVisibleOffConfContra()
                : iconVisibleConfContra(),
            validacion: (value) {
              return _funtionValidator(
                  value,
                  'Es necesario ingrear un valor',
                  'Las contraseñas no coinciden',
                  txtContrasena,
                  txtConfContrasena);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Checkbox(
                  activeColor: Colors.grey,
                  checkColor: Colors.white,
                  value: conditions,
                  onChanged: (value) async {
                    setState(() => conditions = value!);
                    //if (value!) await pfrc.saveTermsAcepted(value);
                  }),
              const Text("Aceptar los", style: TextStyle(fontSize: 16)),
              GestureDetector(
                onTap: () async {},
                child: const Text(
                  " Términos y condiciones",
                  style: TextStyle(color: Colors.blue, fontSize: 17),
                ),
              )
            ],
          ),
          Row(
            children: [
              Checkbox(
                  activeColor: Colors.grey,
                  checkColor: Colors.white,
                  value: autorization,
                  onChanged: (value) async {
                    setState(() => autorization = value!);

                    autorization
                        ? setState(() => autorizationDate = DateTime.now())
                        : setState(() => autorizationDate = null);

                    debugPrint(
                        "date autorization: " + autorizationDate.toString());
                  }),
              GestureDetector(
                onTap: () async {},
                child: const Text(
                  "Autorización de datos",
                  style: TextStyle(color: Colors.blue, fontSize: 17),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.info_outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _funtionValidator(value, rtnTextIf, rtnTextElse,
      TextEditingController controllerC1, TextEditingController controllerC2) {
    if (value.isEmpty || value == null) {
      return rtnTextIf;
    } else if (controllerC1.text == controllerC2.text) {
      return null;
    } else {
      return rtnTextElse;
    }
  }

  Widget iconVisible() {
    return IconButton(
      icon: const Icon(Icons.visibility),
      onPressed: () {
        if (contrasena == false) {
          setState(() {
            contrasena = true;
          });
        }
      },
    );
  }

  Widget iconVisibleOff() {
    return IconButton(
        icon: const Icon(Icons.visibility_off_outlined),
        onPressed: () {
          if (contrasena == true) {
            setState(() {
              contrasena = false;
            });
          }
        });
  }

  Widget iconVisibleConfContra() {
    return IconButton(
      icon: const Icon(Icons.visibility),
      onPressed: () {
        if (confContrasena == false) {
          setState(() {
            confContrasena = true;
          });
        }
      },
    );
  }

  Widget iconVisibleOffConfContra() {
    return IconButton(
      icon: const Icon(Icons.visibility_off_outlined),
      onPressed: () {
        if (confContrasena == true) {
          setState(() {
            confContrasena = false;
          });
        }
      },
    );
  }

  Widget botonIngresar(BuildContext context) {
    final alertIos = IosAlert();
    final alertAnd = AndroidAlert();
    final wsms = WSSms();
    return Column(
      children: [
        // ignore: deprecated_member_use
        nextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                if (conditions && autorization) {
                  setState(() => loading = true);
                  final value = await wsUsuario.validarUsuarioExiste(
                      celular: txtCelular.text);

                  if (value == "si") {
                    setState(() => loading = false);
                    Platform.isAndroid
                        ? alertAnd.accountExists(context)
                        : alertIos.accountExists(context);
                  } else if (value == "no") {
                    setState(() => loading = false);
                    setState(() => sendPin = true);

                    final pin = (Random().nextInt(599999) + 99999).toString();

                    final resultPin =
                        await wsms.enviarMensaje(txtCelular.text, pin);

                    if (resultPin == "OK") {
                      setState(() => sendPin = false);
                      debugPrint("pin: $pin");

                      final usuario = UserModel(
                        apellidos: txtApellidos.text,
                        cedula: txtCedula.text,
                        celular: txtCelular.text,
                        ciudad: ciudad!,
                        contrasena: txtContrasena.text,
                        correo: txtUsuarioEmail.text,
                        fechaNacimiento: fechaNac,
                        nombres: txtNombres.text,
                        pais: pais!,
                        provincia: provincia!,
                      );

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => VerificationCode(
                                    updateUser: false,
                                    usuario: usuario,
                                    pin: pin,
                                    phoneNumber: txtCelular.text,
                                  )));
                    } else {
                      setState(() => sendPin = false);
                      flushBarGlobal(context, resultPin,
                          const Icon(Icons.error, color: Colors.red));
                    }
                  } else {}
                } else {
                  Platform.isAndroid
                      ? alertAnd.acceptTermCondsAnd(context)
                      : alertIos.acceptTermCondsIos(context);
                }
              } else {
                return;
              }
            },
            width: 180,
            text: 'Continuar',
            fontSize: 25),
      ],
    );
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

  void registroExitoso() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (builder) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            title: const Text('Cuenta creada'),
            content: const Text('Su cuenta se ha creado exitosamente.'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pushNamed(context, 'login'),
                      child: const Text('Iniciar sesión'))
                ],
              )
            ],
          );
        });
  }

  void errorAlCrearCuenta(error) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (builder) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            title: const Text('Error al registrar usuario'),
            content: Text(error),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'login');
                      },
                      child: const Text('Iniciar sesión')),*/
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Regresar'))
                ],
              )
            ],
          );
        });
  }
}
