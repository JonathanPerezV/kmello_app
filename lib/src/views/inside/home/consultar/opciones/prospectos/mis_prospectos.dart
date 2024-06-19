import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kmello_app/src/controller/dataBase/operations.dart';
import 'package:kmello_app/src/models/prospectos_model.dart';
import 'package:kmello_app/src/views/inside/home/consultar/opciones/prospectos/agregar_prospecto.dart';
import 'package:kmello_app/src/views/inside/home/consultar/opciones/prospectos/info_contacto.dart';
import 'package:kmello_app/utils/flushbar.dart';

class MisProspectos extends StatefulWidget {
  const MisProspectos({super.key});

  @override
  State<MisProspectos> createState() => _MisProspectosState();
}

class _MisProspectosState extends State<MisProspectos> {
  final op = Operations();
  List<ProspectosModel> contacts = [];
  List<Contact> phoneContacts = [];
  bool hasPermission = false;

  Future<void> getData() async {
    var data = await op.obtenerProspectos();

    setState(() => contacts = data);
  }

  Future<void> permissionContacts() async {
    var res = await FlutterContacts.requestPermission();

    setState(() => hasPermission = res);

    if (res) {
      final allContacts =
          await FlutterContacts.getContacts(withProperties: true);

      setState(() {
        phoneContacts = allContacts;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    permissionContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: options(),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.only(right: 15, bottom: 15),
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              onPressed: () async => await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) =>
                              AgregarEditarProspecto(edit: false)))
                  .then((_) async => getData()),
              backgroundColor: Colors.black,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget options() => Column(
        children: [
          Expanded(
              child: contacts.isEmpty
                  ? const Center(
                      child: Text("No tiene prospectos."),
                    )
                  : ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        String initial = "";
                        if (contacts[index].nombres != "") {
                          initial = contacts[index].nombres.split("")[0];
                          return Slidable(
                            key: UniqueKey(),
                            startActionPane:
                                ActionPane(motion: ScrollMotion(), children: [
                              if (hasPermission)
                                SlidableAction(
                                  onPressed: (_) async {
                                    List<Contact>? contact = phoneContacts
                                        .where((c) =>
                                            c.phones.isNotEmpty &&
                                            c.phones[0].number.toString() ==
                                                contacts[index]
                                                    .celular
                                                    .toString())
                                        .toList();

                                    if (contact.isNotEmpty) {
                                      await FlutterContacts.updateContact(
                                          Contact(
                                              id: contact[0].id,
                                              displayName:
                                                  contacts[index].nombres,
                                              name: Name(
                                                  first:
                                                      contacts[index].nombres),
                                              phones: [
                                            Phone(contacts[index].celular),
                                            Phone(contacts[index].celular2),
                                          ],
                                              addresses: [
                                            Address(contacts[index].direccion)
                                          ],
                                              organizations: [
                                            Organization(
                                                company:
                                                    contacts[index].empresa)
                                          ],
                                              emails: [
                                            Email(contacts[index].mail)
                                          ]));

                                      flushBarGlobal(
                                          context,
                                          "Se actualizó un contacto existente en su dispositivo",
                                          const Icon(Icons.check,
                                              color: Colors.green));
                                    } else {
                                      await FlutterContacts.insertContact(
                                          Contact(
                                              name: Name(
                                                  first:
                                                      contacts[index].nombres),
                                              displayName:
                                                  contacts[index].nombres,
                                              phones: [
                                            Phone(contacts[index].celular),
                                            Phone(contacts[index].celular2),
                                          ],
                                              addresses: [
                                            Address(contacts[index].direccion)
                                          ],
                                              organizations: [
                                            Organization(
                                                company:
                                                    contacts[index].empresa)
                                          ],
                                              emails: [
                                            Email(contacts[index].mail)
                                          ]));
                                      flushBarGlobal(
                                          context,
                                          "Se guardo un contacto nuevo en su dispositivo",
                                          const Icon(Icons.check,
                                              color: Colors.green));
                                    }
                                  },
                                  icon: Icons.save_alt_rounded,
                                  backgroundColor: Colors.blue,
                                ),
                              SlidableAction(
                                backgroundColor: Colors.red,
                                onPressed: (_) async {
                                  await op
                                      .eliminarProspecto(
                                          contacts[index].idProspecto!)
                                      .then((value) {
                                    debugPrint("eliminado?: $value");
                                    if (value == 1) {
                                      flushBarGlobal(
                                          context,
                                          "Prospecto eliminado correctamente",
                                          const Icon(Icons.check,
                                              color: Colors.green));
                                    } else {
                                      flushBarGlobal(
                                          context,
                                          "No se eliminó el prospecto, inténtelo más tarde",
                                          const Icon(Icons.error,
                                              color: Colors.red));
                                    }
                                    getData();
                                  });
                                },
                                icon: Icons.delete,
                                foregroundColor: Colors.white,
                              )
                            ]),
                            child: InkWell(
                              onTap: () async => await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) => InfoContacto(
                                              prospecto: contacts[index])))
                                  .then((_) => getData()),
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
                                          borderRadius:
                                              BorderRadius.circular(100)),
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
                                        contacts[index].nombres!,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                    const Icon(Icons.navigate_next_outlined)
                                  ],
                                ),
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
