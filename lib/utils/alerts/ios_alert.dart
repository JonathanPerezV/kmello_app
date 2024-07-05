import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:intl/intl.dart';
import 'package:kmello_app/main.dart';
import 'package:kmello_app/src/controller/dataBase/operations.dart';
import 'package:kmello_app/src/views/register/login.dart';
import 'package:kmello_app/utils/buttons.dart';
import 'package:kmello_app/utils/flushbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IosAlert {
  void acceptTermCondsIos(context) {
    showDialog(
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            content: const Text(
                "Es necesario que acepte Términos y Condiciones y Autorización de Datos Personales para continuar"),
            actions: [
              Container(
                child: nextButton(
                    onPressed: () => Navigator.pop(context), text: "Entendido"),
              ),
            ],
          );
        });
  }

  void accountExists(context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: const Text('Usuario existente'),
            content: const Text(
                'Este número celular ya se encuentra almacenado en nuestra base de datos.'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  nextButton(
                      onPressed: () => Navigator.pop(context),
                      text: "Regresar",
                      width: 100,
                      fontSize: 15),
                  nextButton(
                      onPressed: () => Navigator.pushNamed(context, "login"),
                      text: "Iniciar sesión",
                      width: 110,
                      fontSize: 15),
                ],
              )
            ],
          );
        });
  }

  void incorrectPin(context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (builder) {
          return CupertinoAlertDialog(
            //title: const Text('Usuario existente'),
            content: const Text(
              'Código incorrecto',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            actions: [
              nextButton(
                  onPressed: () => Navigator.pop(context),
                  text: "Volver a intentar",
                  //width: 120,
                  fontSize: 15),
            ],
          );
        });
  }

  void errorLogin(context, String title, String error) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(
              error,
              style: const TextStyle(fontSize: 16),
            ),
            actions: [
              nextButton(
                  onPressed: () => Navigator.pop(context),
                  text: "Regresar",
                  width: 120,
                  fontSize: 15),
            ],
          );
        });
  }

  void alertaPermisoCamaraManual(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: const Text('Permiso denegado'),
            content: const Text(
                'El permiso a la cámara y galeria ha sido denegado, activelo manualmente'),
            actions: [
              Center(
                  child: TextButton(
                child: const Text('Configuración'),
                onPressed: () {
                  openAppSettings().whenComplete(() => Navigator.pop(context));
                },
              ))
            ],
          );
        });
  }

  void alertaPermisoArchivosManual(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: const Text('Permiso denegado'),
            content: const Text(
                'El permiso a los archivos ha sido denegado, activelo manualmente'),
            actions: [
              Center(
                  child: TextButton(
                child: const Text('Configuración'),
                onPressed: () {
                  openAppSettings().whenComplete(() => Navigator.pop(context));
                },
              ))
            ],
          );
        });
  }

  void cerrarSesion(context) {
    showDialog(
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: const Text('Cerrar sesión'),
            content: const Text('¿Desea cerrar su sesión?'),
            actions: [
              TextButton(
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Cerrar sesión'),
                onPressed: () async {
                  final pfrc = await SharedPreferences.getInstance();
                  await op.deleteProspectos();
                  await pfrc.remove("login");
                  FlutterBackgroundService().invoke("stopService");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const LoginPage()));
                },
              ),
            ],
          );
        });
  }

  void alertCapcitacion(context) {
    showDialog(
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            content: const Text('Debe capacitarse para empezar a vender'),
            actions: [
              TextButton(
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Iniciar'),
                onPressed: () async {},
              ),
            ],
          );
        });
  }

  void alertaAgregarEvento(context, DateTime date, Function()? onpressed) {
    showDialog(
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: const Text("Agregar evento"),
            content: Text(
                "Agregara un evento a la siguiente fecha:  ${DateFormat.MMMMEEEEd("es").format(date)}"),
            actions: [
              TextButton(
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                onPressed: onpressed,
                child: const Text('Continuar'),
              ),
            ],
          );
        });
  }

  void agendaAgregada(BuildContext context, Function() onPressed) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: const Text("Evento creado"),
            content: const Text(
                "Evento creado. ¿Desea agregar documentos al evento?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text("No")),
              TextButton(onPressed: onPressed, child: const Text("Si")),
            ],
          );
        });
  }
}
