// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:abi_praxis/src/controller/preferences/app_preferences.dart';
import 'package:abi_praxis/src/views/register/initial_pages/welcome_page.dart';
import 'package:abi_praxis/src/views/register/login.dart';
import 'package:abi_praxis/utils/buttons.dart';
import 'package:abi_praxis/utils/header_login.dart';
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
  bool location = true, camera = true, gallery = true, contacts = true;
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

  _goToLogin() => Navigator.pushReplacementNamed(context, 'welcome');

  @override
  Widget build(BuildContext context) {
    final rsp = Responsive.of(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                customHeaderLogin("assets/abi_praxis_logo_white.png"),
                Container(
                  margin: const EdgeInsets.only(left: 40, right: 40),
                  color: Colors.black,
                  height: 0.5,
                  width: double.infinity,
                ),
                const SizedBox(height: 20),
                SizedBox(
                    height: rsp.hp(25),
                    child: Image.asset('assets/initial_pages/permisos.png')),
                const SizedBox(height: 20),
                const Column(
                  children: [
                    Text(
                      'ANTES DE CONTINUAR',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      width: 300,
                      child: Text(
                        'Para que puedas utilizar en forma óptima todas las ventajas que ofrecemos, es necesario que nos permitas acceder a la siguiente información:',
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 15),
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
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Ubicación',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Checkbox(
                                  value: location,
                                  onChanged: (value) {
                                    setState(() => location = value!);
                                  })
                            ],
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
                          /*Row(
                            children: [
                              const Text(
                                'Galería',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Checkbox(
                                  value: gallery,
                                  onChanged: (value) {
                                    setState(() => gallery = value!);
                                  })
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            height: 60,
                            width: 0.5,
                            child: const VerticalDivider(
                              thickness: 0.5,
                              color: Colors.black,
                            ),
                          ),*/
                          Row(
                            children: [
                              const Text(
                                'Contactos',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Checkbox(
                                  value: contacts,
                                  onChanged: (value) {
                                    setState(() => contacts = value!);
                                  })
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Cámara',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Checkbox(
                                  value: camera,
                                  onChanged: (value) {
                                    setState(() => camera = value!);
                                  })
                            ],
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
                          Row(
                            children: [
                              const Text(
                                'Archivos',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Checkbox(
                                  value: gallery,
                                  onChanged: (value) {
                                    setState(() => gallery = value!);
                                  })
                            ],
                          ),
                        ],
                      )
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
                    onPressed: () => pedirPermisos(),
                    text: "Permitir acceso",
                    fontSize: 25,
                    width: 230),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ));
  }

  void pedirPermisos() async {
    final appPreferences = AppPreferences();

    if (location) {
      final data = await Permission.location.request();
      debugPrint("location: $data");
    }
    if (camera) {
      final data = await Permission.camera.request();
      debugPrint("camera: $data");
    }
    if (contacts) {
      final data = await Permission.contacts.request();
      debugPrint("contacts: $data");
    }
    if (gallery) {
      if (Platform.isIOS) {
        final data = await Permission.photos.request();
        debugPrint("storage: $data");
      } else {
        final data = await Permission.storage.request();
        debugPrint("storage: $data");
      }
    }
    /*if (storage) {
      final data = await Permission.storage.request();
      debugPrint("storage: $data");
    }*/

    await appPreferences.savePermissionsPage(true).then((value) =>
        Navigator.push(
            context, MaterialPageRoute(builder: (builder) => WelcomePage())));
  }
}
