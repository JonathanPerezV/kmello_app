// ignore_for_file: deprecated_member_use, missing_required_param, avoid_types_as_parameter_names
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kmello_app/utils/buttons.dart';
import 'package:kmello_app/utils/deviders/divider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:timelines/timelines.dart';
import '../../../utils/bezie_painter.dart';
import '../../../utils/textFields/input_text_form_fields.dart';

const kTileHeight = 50.0;

const completeColor = Color(0xff5e6172);
const inProgressColor = Color.fromARGB(255, 83, 87, 85);
const todoColor = Color(0xffd1d2d7);

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final key = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  final controllerCellPhone = TextEditingController();
  final controllerPin = TextEditingController();
  final textControllerClaveNueva = TextEditingController();
  final textControllerRepClaveNueva = TextEditingController();

  int? idUser;
  String? correo;

  Color blackColor = Colors.black;
  Color whiteColor = Colors.white;

  bool loading = false;

  bool clave = true;
  bool repClave = true;

  int processIndex = 0;
  int? pinSeguridad;

  Color getColor(int index) {
    if (index == processIndex) {
      return inProgressColor;
    } else if (index < processIndex) {
      return completeColor;
    } else {
      return todoColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        persistentFooterButtons: [
          SizedBox(
              height: 50,
              child: Center(
                  child: Image.asset("assets/byBaadal.png", fit: BoxFit.cover)))
        ],
        body: listaOpciones(),
      ),
    );
  }

  Widget listaOpciones() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40),
                width: 170,
                height: 120,
                child: Image.asset(
                  'assets/kmello_logo.png',
                ),
              ),
              divider(false),
              Container(
                height: 45,
                width: double.infinity,
                child: Row(
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
                              child: Icon(Icons.arrow_back_ios,
                                  color: blackColor, size: 25),
                            ),
                          ),
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.abc,
                            color: Colors.black,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Text('Cambiar contraseña',
                                style:
                                    TextStyle(color: blackColor, fontSize: 18)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              divider(false),
              SizedBox(
                  width: double.infinity,
                  height: 120,
                  child: Center(child: timeLine())),
              if (processIndex == 0) contenedorEnviar(),
              if (processIndex == 1) contenedorIngresar(),
              if (processIndex == 2) contenedorRestablecer()
            ],
          ),
        ),
        if (loading)
          Container(
            color: const Color.fromRGBO(0, 0, 0, 60),
            width: double.infinity,
            height: double.infinity,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  Widget timeLine() {
    return Timeline.tileBuilder(
      theme: TimelineThemeData(
        direction: Axis.horizontal,
        connectorTheme: const ConnectorThemeData(
          space: 30.0,
          thickness: 5.0,
        ),
      ),
      builder: TimelineTileBuilder.connected(
        connectionDirection: ConnectionDirection.before,
        itemExtentBuilder: (_, __) =>
            MediaQuery.of(context).size.width / _processes.length,
        contentsBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              _processes[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: getColor(index),
              ),
            ),
          );
        },
        indicatorBuilder: (_, index) {
          Color? color;
          Widget? child;
          if (index == processIndex) {
            color = inProgressColor;
            child = Icon(
              Icons.circle,
              color: whiteColor,
              size: 13,
            );
          } else if (index < processIndex) {
            color = completeColor;
            child = Icon(
              Icons.check,
              color: whiteColor,
              size: 15.0,
            );
          } else {
            color = todoColor;
          }
          if (index <= processIndex) {
            return Stack(
              children: [
                CustomPaint(
                  size: const Size(30.0, 30.0),
                  painter: BezierPainter(
                    color: color,
                    drawStart: index > 0,
                    drawEnd: index < processIndex,
                  ),
                ),
                DotIndicator(
                  size: 30.0,
                  color: color,
                  child: child,
                ),
              ],
            );
          } else {
            return Stack(
              children: [
                CustomPaint(
                  size: const Size(15.0, 15.0),
                  painter: BezierPainter(
                    color: color,
                    drawEnd: index < _processes.length - 1,
                  ),
                ),
                OutlinedDotIndicator(
                  borderWidth: 4.0,
                  color: color,
                ),
              ],
            );
          }
        },
        connectorBuilder: (_, index, type) {
          if (index > 0) {
            if (index == processIndex) {
              final prevColor = getColor(index - 1);
              final color = getColor(index);
              List<Color> gradientColors;
              if (type == ConnectorType.start) {
                gradientColors = [Color.lerp(prevColor, color, 0.5)!, color];
              } else {
                gradientColors = [
                  prevColor,
                  Color.lerp(prevColor, color, 0.5)!
                ];
              }
              return DecoratedLineConnector(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                  ),
                ),
              );
            } else {
              return SolidLineConnector(
                color: getColor(index),
              );
            }
          } else {
            return null;
          }
        },
        itemCount: _processes.length,
      ),
    );
  }

  Widget contenedorEnviar() {
    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                width: 350,
                child: const Text(
                    'Ingrese el número que está asociado a su cuenta KMELLO para poder realizar el cambio de contraseña.'),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: 350,
                child: TextFormField(
                  controller: controllerCellPhone,
                  validator: (value) {
                    if (value?.isEmpty != false || value == null) {
                      return 'Ingrese su número*';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone_iphone_outlined),
                      hintText: 'Ingrese su número celular'),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              nextButton(
                  onPressed: () async {
                    setState(() => processIndex = 1);
                    /* if (formKey.currentState!.validate()) {
                    setState(() => loading = true);
                    pinSeguridad = Random().nextInt(59999) + 9999;
                    await serviceCorreo
                        .enviarCorreo(
                            pinSeguridad.toString(), controllerCorreo.text)
                        .then((value) {
                      if (value == 'Enviado') {
                        flushBarGlobal(
                            context,
                            'El correo ha sido enviado, revise su bandeja de entrada.',
                            Icon(
                              Icons.check,
                              color: greenColor,
                            ));
                        setState(() {
                          processIndex = 1;
                        });
                      } else {
                        flushBarGlobal(
                            context,
                            'El correo no se ha podido enviar, intentelo de nuevo mas tarde.',
                            Icon(
                              Icons.clear,
                              color: redColor,
                            ));
                      }
                      setState(() {
                        loading = false;
                        FocusScope.of(context).unfocus();
                      });
                    });
                  } else {
                    return;
                  }*/
                  },
                  text: "Enviar",
                  fontSize: 20,
                  width: 200),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget contenedorIngresar() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            'Ingrese el pin que se le envió por sms a su celular registrado'
                .toUpperCase(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 35, right: 35),
          child: PinCodeTextField(
            autoDisposeControllers: false,
            controller: controllerPin,
            textStyle: const TextStyle(fontSize: 35),
            errorTextSpace: 25,
            validator: (v) {
              if (v!.length < 5) {
                return "Complete los 5 campos";
              } else {
                return null;
              }
            },
            onCompleted: (text) {
              if (text == pinSeguridad.toString()) {
                /*flushBarGlobal(
                    context,
                    'Pin correcto.',
                    Icon(
                      Icons.check,
                      color: greenColor,
                    ));
                setState(() {
                  processIndex = 2;
                  controllerPin.clear();
                });
              } else {
                flushBarGlobal(
                    context,
                    'Pin ingresado incorrecto.',
                    Icon(
                      Icons.clear,
                      color: redColor,
                    ));*/
              }
            },
            dialogConfig: DialogConfig(
              affirmativeText: 'Aceptar',
              negativeText: 'Cancelar',
              dialogContent: '¿ Desea pegar este código ',
              dialogTitle: 'Pegar código',
            ),
            showCursor: false,
            enableActiveFill: true,
            animationType: AnimationType.scale,
            cursorColor: blackColor,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            pinTheme: PinTheme(
              borderRadius: BorderRadius.circular(2),
              selectedFillColor: Colors.grey.shade100,
              activeFillColor: Colors.grey.shade100,
              inactiveFillColor: Colors.grey.shade100,
              activeColor: blackColor,
              inactiveColor: blackColor,
              borderWidth: 1,
              shape: PinCodeFieldShape.box,
              fieldHeight: 75,
              fieldWidth: 50,
            ),
            pastedTextStyle: TextStyle(
              color: blackColor,
              fontWeight: FontWeight.bold,
            ),
            appContext: context,
            length: 5,
            onChanged: (_) {},
          ),
        ),
        nextButton(
            onPressed: () {
              setState(() => processIndex = 2);
              //if (controllerPin.text == pinSeguridad.toString()) {
              /*flushBarGlobal(
                  context,
                  'Pin correcto.',
                  Icon(
                    Icons.check,
                    color: greenColor,
                  ));
              setState(() => processIndex = 2);
            } else {
              flushBarGlobal(
                  context,
                  'Pin ingresado incorrecto.',
                  Icon(
                    Icons.clear,
                    color: redColor,
                  ));*/
            },
            text: "Validar pin",
            fontSize: 20,
            width: 200),
      ],
    );
  }

  Widget contenedorRestablecer() {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                width: 150,
                height: 150,
                child: Image.asset('assets/password/secure.png')),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Column(
                children: [
                  //todo CAMPO INGRESAR NUEVA CONTRASEÑA
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: double.infinity,
                    child: Text(
                      'Ingrese su nueva contraseña'.toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  InputTextFormFields(
                      validacion: (value) {
                        if (value!.isEmpty) {
                          return 'Este campo no puede estar vacío';
                        } else if (value != textControllerRepClaveNueva.text) {
                          return 'Las contraseñas no coinciden';
                        } else {
                          return null;
                        }
                      },
                      estilo: TextStyle(color: blackColor),
                      icon: GestureDetector(
                        onTap: () {
                          setState(() {
                            clave = !clave;
                          });
                        },
                        child: Icon(
                            clave ? Icons.visibility_off : Icons.visibility),
                      ),
                      oscurecerTexto: clave,
                      controlador: textControllerClaveNueva,
                      accionCampo: TextInputAction.done,
                      //nombreCampo: 'Contraseña',
                      placeHolder: 'ESCRIBA AQUÍ SU CONTRASEÑA'),
                  const SizedBox(height: 40),
                  //todo CAMPO REPETIR CONTRASEÑA NUEVA
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: double.infinity,
                    child: Text(
                      'Repita su contraseña'.toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  InputTextFormFields(
                      validacion: (value) {
                        if (value!.isEmpty) {
                          return 'Este campo no puede estar vacío';
                        } else if (value != textControllerClaveNueva.text) {
                          return 'Las contraseñas no coinciden';
                        } else {
                          return null;
                        }
                      },
                      estilo: TextStyle(color: blackColor),
                      icon: GestureDetector(
                          onTap: () {
                            setState(() {
                              repClave = !repClave;
                            });
                          },
                          child: Icon(
                            repClave ? Icons.visibility_off : Icons.visibility,
                          )),
                      oscurecerTexto: repClave,
                      controlador: textControllerRepClaveNueva,
                      accionCampo: TextInputAction.done,
                      //nombreCampo: 'Contraseña',
                      placeHolder: 'ESCRIBA AQUÍ SU CONTRASEÑA'),
                  const SizedBox(
                    height: 40,
                  ),
                  TextButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          blackColor,
                        )),
                    onPressed: () async {
                      /*if (formKey.currentState!.validate()) {
                        setState(() => loading = true);
                        final bytes =
                            utf8.encode(textControllerRepClaveNueva.text);
                        final contrasenaCodificada = md5.convert(bytes);
                        await serviceAyudaTodoApi
                            .actualizarDatoUsuario(UsuarioV2(
                          correoElectronico: controllerCorreo.text,
                          contrasena: contrasenaCodificada.toString(),
                        ))
                            .then((value) {
                          if (value != 'failed') {
                            navegarPantalla(context,
                                posicionFade: 'ITD', widget: const LoginPage());
                            flushBarGlobal(
                                context,
                                'Contraseña restablecida correctamente.',
                                Icon(
                                  Icons.check,
                                  color: greenColor,
                                ));
                          } else {
                            showDialog(
                                context: context,
                                builder: (builder) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    title: const Text('Error al cambiar'),
                                    content: const Text(
                                        'Asegurese de haber ingresado un correo que esté asociado a la cuenta.'),
                                    actions: [
                                      TextButton(
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              blackColor,
                                            )),
                                        onPressed: () {
                                          setState(() {
                                            controllerCorreo.clear();
                                            controllerPin.clear();
                                            textControllerClaveNueva.clear();
                                            textControllerRepClaveNueva.clear();
                                            clave = true;
                                            repClave = true;
                                            processIndex = 0;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Regresar',
                                          style: TextStyle(color: whiteColor),
                                        ),
                                      )
                                    ],
                                  );
                                });
                          }
                          setState(() => loading = false);
                        });
                      }*/
                    },
                    child: Text(
                      'Cambiar',
                      style: TextStyle(color: whiteColor),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final _processes = [
    'Enviar pin',
    'Ingresar pin',
    'Cambiar',
  ];
}
