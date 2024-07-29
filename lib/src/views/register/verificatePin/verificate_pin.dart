// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:abi_praxis/src/controller/sms/ws_sms.dart';
import 'package:abi_praxis/src/models/user_moderl.dart';
import 'package:abi_praxis/src/views/register/verificatePin/phone_verificated.dart';
import 'package:abi_praxis/utils/alerts/and_alert.dart';
import 'package:abi_praxis/utils/alerts/ios_alert.dart';
import 'package:abi_praxis/utils/buttons.dart';
import 'package:abi_praxis/utils/flushbar.dart';
import 'package:abi_praxis/utils/icons/kmello_icons_icons.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../utils/device_info.dart';
import '../../../../utils/deviders/divider.dart';
import '../../../models/info_device_model.dart';

class VerificationCode extends StatefulWidget {
  UserModel? usuario;
  String pin;
  String phoneNumber;
  bool updateUser;
  VerificationCode(
      {required this.pin,
      required this.phoneNumber,
      this.usuario,
      required this.updateUser,
      super.key});

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  final controllerPin = TextEditingController();
  String pinSeguridad = '';
  final txtControllerDevice = TextEditingController(text: "Cargando...");
  final formKey = GlobalKey<FormState>();

  late DeviceModel deviceModel;

  final infoDevice = InfoDevice();

  Duration mydDuration = const Duration(minutes: 2);
  int secondPassed = 0;
  bool countDownActive = true;
  bool loading = false;
  String? firsPin;
  String newNumber = "";

  bool? verificado;

  Timer? countdownTimer;

  void startCountDownTimer() {
    setState(() => countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown()));
  }

  void setCountDown() {
    int reduceSecondBy = 1;

    setState(() {
      final seconds = mydDuration.inSeconds - reduceSecondBy;

      if (seconds < 0) {
        countdownTimer!.cancel();
        countDownActive = false;
      } else {
        mydDuration = Duration(seconds: seconds);
      }
    });
  }

  void replacePhoneNumber() {
    List<String> listNumbers = [];
    String temporalNumber = "";

    final phoneNumber = widget.phoneNumber.split("");

    for (var i = 0; i < phoneNumber.length; i++) {
      if (i != 0 && i != 1 && i != 8 && i != 9) {
        listNumbers.add("*");
      }
    }

    for (var i = 0; i < listNumbers.length; i++) {
      if (listNumbers.length == 6) {
        temporalNumber = phoneNumber[0];
        listNumbers.add(temporalNumber);
      } else if (listNumbers.length == 7) {
        newNumber = phoneNumber[1];
        temporalNumber += newNumber;
        listNumbers.add(newNumber);
        newNumber = temporalNumber;
      } else {
        newNumber += listNumbers.reversed.toList()[i];
        debugPrint("numero final: $newNumber");
      }
    }

    setState(() => newNumber += "${phoneNumber[8]}${phoneNumber[9]}");
  }

  @override
  void initState() {
    super.initState();
    setState(() => loading = false);
    setState(() => pinSeguridad = widget.pin);
    replacePhoneNumber();
    getInfoDevice();
    startCountDownTimer();
  }

  Future getInfoDevice() async {
    final data = await infoDevice.getDeviceModel();

    setState(() {
      deviceModel = data;
      txtControllerDevice.text =
          Platform.isAndroid ? deviceModel.model : deviceModel.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: options(),
      ),
    );
  }

  Widget options() => Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Center(
                  child: SizedBox(
                    width: 170,
                    height: 60,
                    child: Image.asset("assets/abi_praxis_logo.png"),
                  ),
                ),
                const SizedBox(height: 10),
                divider(true),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    IconButton(
                        onPressed: () {
                          if (widget.updateUser) {
                            Navigator.pop(context, verificado);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.arrow_back_ios)),
                    const Row(children: [
                      Icon(KmelloIcons.codigo_de_verificacion),
                      SizedBox(width: 5),
                      Text(
                        "Código de verificación",
                        style: TextStyle(fontSize: 23.5),
                      )
                    ])
                  ],
                ),
                divider(true),
                const SizedBox(height: 40),
                SizedBox(
                    width: 350,
                    child: Text(
                      "Ingrese el pin temporal enviado por sms al $newNumber",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    )),
                const SizedBox(height: 40),
                securityPin(),
                const SizedBox(height: 40),
                deviceInfo(),
                const SizedBox(height: 40),
                countDown()
              ],
            ),
          ),
          if (loading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color.fromRGBO(0, 0, 0, 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${firsPin == null ? "Generando" : "Enviando"} código...",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            )
        ],
      );

  Widget securityPin() => Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: PinCodeTextField(
            validator: (value) {
              if (value!.isEmpty) {
                return "Campo obligatorio *";
              } else {
                return null;
              }
            },
            controller: controllerPin,
            textStyle: const TextStyle(fontSize: 30),
            errorTextSpace: 20,
            dialogConfig: DialogConfig(
              platform: PinCodePlatform.iOS,
              //affirmativeText: 'Aceptar',
              negativeText: 'Cancelar',
              dialogContent: '¿ Desea pegar este código ',
              dialogTitle: 'Pegar código',
            ),
            showCursor: false,
            enableActiveFill: true,
            animationType: AnimationType.scale,
            cursorColor: Colors.black,
            keyboardType: TextInputType.number,
            backgroundColor: Colors.transparent,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            pinTheme: PinTheme(
              selectedFillColor: Colors.grey.shade200,
              activeFillColor: Colors.transparent,
              inactiveFillColor: Colors.transparent,
              activeColor: Colors.black,
              inactiveColor: Colors.black,
              borderWidth: 0,
              shape: PinCodeFieldShape.box,
              fieldHeight: 75,
              fieldWidth: 50,
            ),
            pastedTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            appContext: context,
            length: 6,
          ),
        ),
      );

  Widget deviceInfo() => Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        child: TextFormField(
          style: const TextStyle(color: Colors.grey),
          controller: txtControllerDevice,
          enabled: false,
          decoration: const InputDecoration(
              label: Text("Nombre del dispositivo"),
              prefixIcon: Icon(Icons.phone_iphone_sharp)),
        ),
      );

  Widget countDown() {
    String strDigts(int n) => n.toString().padLeft(2, "0");

    final minutes = strDigts(mydDuration.inMinutes.remainder(60));
    final seconds = strDigts(mydDuration.inSeconds.remainder(60));

    return countDownActive
        ? Column(
            children: [
              RichText(
                  text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                    TextSpan(
                        text: "$minutes:$seconds ",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const TextSpan(text: "para solicitar un nuevo código")
                  ])),
              const SizedBox(height: 20),
              button(),
            ],
          )
        : Column(
            children: [
              button(),
              const SizedBox(height: 25),
              const Text(
                "¿NO RECIBIO LA CLAVE / PIN?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                  onTap: () async {
                    final wsms = WSSms();

                    final pin = (Random().nextInt(599999) + 99999).toString();

                    setState(() => pinSeguridad = pin);

                    setState(() => loading = true);
                    final resultsms =
                        await wsms.enviarMensaje(widget.phoneNumber, pin);

                    if (resultsms == "OK") {
                      setState(() => loading = false);
                      setState(() => mydDuration = const Duration(minutes: 2));
                      startCountDownTimer();
                      setState(() => countDownActive = true);
                      debugPrint("pin: $pin");
                      flushBarGlobal(context, "Pin enviado correctamente",
                          const Icon(Icons.check, color: Colors.green));
                    } else {
                      setState(() => loading = false);
                      flushBarGlobal(context, resultsms,
                          const Icon(Icons.error, color: Colors.red));
                    }
                    //sendMail();
                  },
                  child: const Text("SOLICITAR NUEVO PIN",
                      style: TextStyle(color: Colors.blue))),
              const SizedBox(height: 10),
              const Text("O"),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {},
                child: const Text("Llamar al contact center",
                    style: TextStyle(color: Colors.blue)),
              ),
            ],
          );
  }

  Widget button() => nextButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            if (controllerPin.text == pinSeguridad) {
              if (widget.updateUser) {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => PhoneVerificated(
                            usuario: widget.usuario, updateUser: true)));
                setState(() => verificado = result);
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => PhoneVerificated(
                            usuario: widget.usuario, updateUser: false)));
              }
            } else {
              Platform.isAndroid
                  ? AndroidAlert().incorrectPin(context)
                  : IosAlert().incorrectPin(context);
            }
          } else {
            return;
          }
        },
        width: 300,
        text: "VERIFICAR",
      );
}
