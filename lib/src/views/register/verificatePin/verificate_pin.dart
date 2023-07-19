// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kmello_app/src/views/register/verificatePin/phone_verificated.dart';
import 'package:kmello_app/utils/buttons.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../utils/device_info.dart';
import '../../../../utils/deviders/divider.dart';
import '../../../models/info_device_model.dart';

class VerificationCode extends StatefulWidget {
  //String mail;
  VerificationCode({/*required this.mail,*/ super.key});

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  final controllerPin = TextEditingController();
  String pinSeguridad = '';
  final txtControllerDevice = TextEditingController(text: "Cargando...");
  //final senMail = ServiceEnviarCorreo();

  late DeviceModel deviceModel;

  final infoDevice = InfoDevice();

  Duration mydDuration = const Duration(minutes: 2);
  int secondPassed = 0;
  bool countDownActive = true;
  bool loading = false;
  String? firsPin;
  String newEmail = "";

  Timer? countdownTimer;

  void startCountDownTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
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

  @override
  void initState() {
    super.initState();
    setState(() => loading = false);
    //replaceMail();
    //sendMail();

    getInfoDevice();
  }

  /*void replaceMail() {
    final parts = widget.mail.split("@");

    final mail = parts[0];
    final domain = parts[1];

    debugPrint("mail: $mail and domain: $domain");

    final replaceMail =
        mail.replaceRange(2, mail.length, "*" * (mail.length - 3));

    debugPrint("mail obscure: $replaceMail@$domain");

    setState(() => newEmail = "$replaceMail@$domain");
  }*/

  /*Future<String> sendMail() async {
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() => firsPin = (Random().nextInt(599999) + 99999).toString());

    final data = await senMail.enviarCorreoClaveTemporal(firsPin!, widget.mail);

    setState(() => loading = false);

    if (data == 'Enviado') {
      startCountDownTimer();
      flushBarGlobal(
          context,
          "Correo enviado, revise su bandeja de entrada o correo no deseado",
          const Icon(
            Icons.mark_email_read_outlined,
            color: Colors.green,
          ),
          seconds: 3);
    } else {
      flushBarGlobal(
          context,
          "No se pudo enviar el correo, intentelo de nuevo",
          const Icon(
            Icons.error,
            color: Colors.red,
          ));
    }

    return data;
  }*/

  Future getInfoDevice() async {
    final data = await infoDevice.getDeviceModel();

    setState(() {
      deviceModel = data;
      txtControllerDevice.text =
          Platform.isAndroid ? deviceModel.model! : deviceModel.name!;
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
                    width: 150,
                    height: 60,
                    child: Image.asset("assets/kmello_logo.png"),
                  ),
                ),
                const SizedBox(height: 10),
                divider(true),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios)),
                    Row(children: const [
                      Icon(Icons.abc),
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
                      "Ingrese el pin temporal enviado por sms al 0994911674",
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

  Widget securityPin() => Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: PinCodeTextField(
          controller: controllerPin,
          textStyle: const TextStyle(fontSize: 30),
          errorTextSpace: 2,
          onCompleted: (text) {
            pinSeguridad = text;
            //validacion();
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
          onChanged: (String value) {
            if (value.isEmpty) {
              setState(() => pinSeguridad = "");
            }
          },
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
                    setState(() => loading = true);
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
        onPressed: () {
          if (pinSeguridad == "102030") {
            Navigator.push(context,
                MaterialPageRoute(builder: (builder) => PhoneVerificated()));
          } else {}
          /*if (pinSeguridad.isNotEmpty) {
            if (pinSeguridad == firsPin) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (builder) => const GeneratePin()));
            } else {
              Platform.isAndroid
                  ? dialogErrorPinValidationAndroid(context)
                  : dialogErrorPinValidationIos(context);
            }
          }*/
        },
        width: 300,
        text: "VERIFICAR",
      );
}
