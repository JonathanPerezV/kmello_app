import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:kmello_app/src/models/contact_model.dart';
import 'package:kmello_app/src/views/inside/home/consultar/opciones/prospectos/info_contacto.dart';
import 'package:kmello_app/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:kmello_app/utils/app_bar.dart';
import 'package:kmello_app/utils/header.dart';

class MisContactos extends StatefulWidget {
  const MisContactos({super.key});

  @override
  State<MisContactos> createState() => _MisContactosState();
}

class _MisContactosState extends State<MisContactos> {
  final _scKey = GlobalKey<ScaffoldState>();

  List<Contact> contactos = [];

  void requestPermissionContacts() async {
    if (await FlutterContacts.requestPermission()) {
      final allContacts =
          await FlutterContacts.getContacts(withProperties: true);

      setState(() => contactos = allContacts);
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermissionContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scKey,
      appBar: MyAppBar(key: _scKey).myAppBar(),
      drawer: drawerMenu(context),
      body: options(),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () {},
        backgroundColor: Colors.black,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget options() => Column(
        children: [
          header("Prospectos", Icons.abc, context: context),
          Expanded(
              child: ListView.builder(
                  itemCount: contactos.length,
                  itemBuilder: (context, index) {
                    String initial = "";
                    if (contactos[index].displayName != "") {
                      initial = contactos[index].displayName.split("")[0];
                      return InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) =>
                                    InfoContacto(contact: contactos[index]))),
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 20, right: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade800,
                                          blurRadius: 1.1,
                                          offset: Offset(0, 0),
                                          spreadRadius: 0.5)
                                    ],
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(100)),
                                child: Text(
                                  initial,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Text(
                                  contactos[index].displayName,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                              const Icon(Icons.navigate_next_outlined)
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }))
        ],
      );
}
