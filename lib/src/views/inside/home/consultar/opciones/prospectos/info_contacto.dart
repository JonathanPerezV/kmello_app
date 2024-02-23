import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:kmello_app/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:kmello_app/utils/app_bar.dart';
import 'package:kmello_app/utils/deviders/divider.dart';
import 'package:kmello_app/utils/header.dart';
import 'package:kmello_app/utils/header_container.dart';

class InfoContacto extends StatefulWidget {
  Contact contact;
  InfoContacto({super.key, required this.contact});

  @override
  State<InfoContacto> createState() => _InfoContactoState();
}

class _InfoContactoState extends State<InfoContacto> {
  final _sckey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _sckey,
      appBar: MyAppBar(key: _sckey).myAppBar(),
      drawer: drawerMenu(context),
      body: options(),
    );
  }

  Widget options() {
    String initial = widget.contact.displayName.split("")[0];
    return Column(
      children: [
        header("Prospectos", Icons.abc, context: context),
        Container(
          margin: const EdgeInsets.only(right: 10),
          width: double.infinity,
          alignment: Alignment.centerRight,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(Icons.edit), Icon(Icons.delete)],
          ),
        ),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100), color: Colors.black),
          child: Center(
            child: Text(
              initial,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 50),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            widget.contact.displayName,
            style: const TextStyle(fontSize: 30),
          ),
        ),
        const SizedBox(height: 30),
        Center(
            child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.contact.phones.isNotEmpty
                  ? widget.contact.phones.first.number
                  : "no phone number",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            IconButton(
                onPressed: () async {
                  if (widget.contact.phones.isNotEmpty) {
                    await Clipboard.setData(ClipboardData(
                        text: widget.contact.phones.first.number));
                  }
                },
                icon: const Icon(Icons.copy))
          ],
        )),
        divider(true),
        const SizedBox(height: 30),
        HeaderContainer(
          margin_container: const EdgeInsets.only(left: 20, right: 20),
          height_container: 50,
          body: Text(
            widget.contact.organizations.isNotEmpty
                ? widget.contact.organizations.first.company
                : "No se ha agregado una empresa",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          has_header: false,
          has_title: true,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              //alignment: Alignment.center,
              width: 110,
              color: Colors.white,
              margin: const EdgeInsets.only(left: 25, top: 8),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person),
                  Text(
                    "Empresa:",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        HeaderContainer(
          margin_container: const EdgeInsets.only(left: 20, right: 20),
          height_container: 50,
          body: Text(
            widget.contact.emails.isNotEmpty
                ? widget.contact.emails.first.address
                : "No se ha agregado un correo",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          has_header: false,
          has_title: true,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              //alignment: Alignment.center,
              width: 110,
              color: Colors.white,
              margin: const EdgeInsets.only(left: 25, top: 8),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person),
                  Text(
                    "Email:",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        HeaderContainer(
          margin_container: const EdgeInsets.only(left: 20, right: 20),
          height_container: 100,
          body: Text(
            widget.contact.addresses.isNotEmpty
                ? widget.contact.addresses.first.address.replaceAll("  ", " ")
                : "No se ha agregado una dirección",
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          has_header: false,
          has_title: true,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              //alignment: Alignment.center,
              width: 110,
              color: Colors.white,
              margin: const EdgeInsets.only(left: 25, top: 8),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person),
                  Text(
                    "Dirección:",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
