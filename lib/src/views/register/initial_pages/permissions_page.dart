// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kmello_app/utils/buttons.dart';
import 'package:kmello_app/utils/header_login.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../utils/responsive.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({Key? key}) : super(key: key);

  @override
  _PermissionsPageState createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage>
    with WidgetsBindingObserver {
  bool _fromSettings = false;
  bool location = false, camera = false, gallery = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('AppliFecycleState:::::: $state');
    if (state == AppLifecycleState.resumed && _fromSettings) {
      _check();
      Navigator.pushReplacementNamed(context, 'login');
    }
  }

  _check() async {
    final bool hasAccess = await Permission.locationWhenInUse.isGranted;
    if (hasAccess) {
      _goToLogin();
    } else {
      Navigator.pushReplacementNamed(context, 'permiso');
    }
  }

  _goToLogin() {
    Navigator.pushReplacementNamed(context, 'welcome');
  }

  Future<void> _requestPermissionLocation() async {
    final PermissionStatus status = await Permission.location.request();
    //print(status);
    switch (status) {
      case PermissionStatus.limited:
        setState(() {
          location = false;
          camera = true;
        });
        _requestPermissionCamera();
        break;
      case PermissionStatus.granted:
        setState(() {
          location = false;
          camera = true;
        });
        _requestPermissionCamera();
        break;
      case PermissionStatus.denied:
        setState(() {
          location = false;
          camera = true;
        });
        _requestPermissionCamera();
        break;
      case PermissionStatus.restricted:
        setState(() {
          location = false;
          camera = true;
        });
        _requestPermissionCamera();
        break;
      case PermissionStatus.permanentlyDenied:
        setState(() {
          location = false;
          camera = true;
        });
        _requestPermissionCamera();
        _fromSettings = true;
        break;
      default:
        break;
    }
  }

  Future<void> _requestPermissionCamera() async {
    final PermissionStatus status = await Permission.camera.request();
    //print(status);
    switch (status) {
      case PermissionStatus.limited:
        setState(() {
          camera = false;
          gallery = true;
        });
        _requestPermissionPhotos();
        break;
      case PermissionStatus.granted:
        setState(() {
          camera = false;
          gallery = true;
        });
        _requestPermissionPhotos();
        break;
      case PermissionStatus.denied:
        setState(() {
          camera = false;
          gallery = true;
        });
        _requestPermissionPhotos();
        break;
      case PermissionStatus.restricted:
        setState(() {
          camera = false;
          gallery = true;
        });
        _requestPermissionPhotos();
        break;
      case PermissionStatus.permanentlyDenied:
        setState(() {
          camera = false;
          gallery = true;
        });
        _requestPermissionPhotos();
        _fromSettings = true;
        break;
      default:
        break;
    }
  }

  Future<void> _requestPermissionPhotos() async {
    final PermissionStatus status = await Permission.photos.request();
    //print(status);
    switch (status) {
      case PermissionStatus.limited:
        if (Platform.isAndroid) {
          setState(() {
            gallery = false;
          });
          _requestPermissionStorage();
        } else {
          _goToLogin();
        }

        break;
      case PermissionStatus.granted:
        if (Platform.isAndroid) {
          setState(() {
            gallery = false;
          });
          _requestPermissionStorage();
        } else {
          _goToLogin();
        }
        break;
      case PermissionStatus.denied:
        if (Platform.isAndroid) {
          setState(() {
            gallery = false;
          });
          _requestPermissionStorage();
        } else {
          _goToLogin();
        }
        break;
      case PermissionStatus.restricted:
        if (Platform.isAndroid) {
          setState(() {
            gallery = false;
          });
          _requestPermissionStorage();
        } else {
          _goToLogin();
        }
        break;
      case PermissionStatus.permanentlyDenied:
        if (Platform.isAndroid) {
          setState(() {
            gallery = false;
          });
          _requestPermissionStorage();
          _fromSettings = true;
        } else {
          _goToLogin();
        }

        break;
      default:
        break;
    }
  }

  Future<void> _requestPermissionStorage() async {
    final PermissionStatus status = await Permission.storage.request();
    //print(status);
    switch (status) {
      case PermissionStatus.limited:
        _goToLogin();
        break;
      case PermissionStatus.granted:
        _goToLogin();
        break;
      case PermissionStatus.denied:
        _goToLogin();
        break;
      case PermissionStatus.restricted:
        _goToLogin();
        break;
      case PermissionStatus.permanentlyDenied:
        _goToLogin();
        _fromSettings = true;
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rsp = Responsive.of(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: <Widget>[
              customHeaderLogin("assets/kmello_logo_white.png"),
              Container(
                margin: const EdgeInsets.only(left: 40, right: 40),
                color: Colors.black,
                height: 0.5,
                width: double.infinity,
              ),
              const SizedBox(height: 20),
              SizedBox(
                  height: 250,
                  child: Image.asset('assets/initial_pages/permisos.png')),
              const SizedBox(height: 20),
              const Column(
                children: [
                  Text(
                    'ANTES DE CONTINUAR',
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    width: 300,
                    child: Text(
                      'Para que puedas utilizar en forma óptima todas las ventajas que ofrecemos, es necesario que nos permitas acceder a la siguiente información:',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                color: Colors.black,
                height: 0.5,
                width: double.infinity,
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Ubicación',
                      style: TextStyle(
                          fontSize: rsp.wp(4), fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      height: 60,
                      width: 0.5,
                      child: const VerticalDivider(
                        thickness: 0.5,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Galería',
                      style: TextStyle(
                          fontSize: rsp.wp(4), fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      height: 60,
                      width: 0.5,
                      child: const VerticalDivider(
                        thickness: 0.5,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Almacenamiento',
                      style: TextStyle(
                          fontSize: rsp.wp(4), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.black,
                height: 0.5,
                width: double.infinity,
              ),
              const SizedBox(
                height: 20,
              ),
              nextButton(
                  onPressed: () async {
                    //_goToLogin();
                    /*setState(() {
                    location = true;
                  });
                  final spc = Preferences();
                  await _requestPermissionLocation();
                  spc.guardarSplash('confirmado');*/
                    await _requestPermissionLocation();
                  },
                  text: "Permitir acceso",
                  fontSize: 25,
                  width: 230),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}
