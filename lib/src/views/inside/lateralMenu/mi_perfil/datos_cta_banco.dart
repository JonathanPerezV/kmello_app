// ignore_for_file: use_build_context_synchronously

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:kmello_app/src/controller/aws/ws_banks.dart';
import 'package:kmello_app/src/controller/user_preferences.dart';
import 'package:kmello_app/src/models/account_model.dart';
import 'package:kmello_app/src/models/bank_model.dart';
import 'package:kmello_app/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:kmello_app/utils/buttons.dart';
import 'package:kmello_app/utils/flushbar.dart';
import 'package:kmello_app/utils/header.dart';
import 'package:kmello_app/utils/loading.dart';

import '../../../../../utils/app_bar.dart';
import '../../../../../utils/textFields/input_text_fields.dart';

class DatosCuentaBanco extends StatefulWidget {
  const DatosCuentaBanco({super.key});

  @override
  State<DatosCuentaBanco> createState() => _DatosCuentaBancoState();
}

class _DatosCuentaBancoState extends State<DatosCuentaBanco> {
  final sckey = GlobalKey<ScaffoldState>();
  bool loading = false;
  bool guardando = false;
  bool actualizando = false;
  bool editarPerfil = false;
  bool hasAccount = false;

  final wsBanks = WSBanks();
  List<BankModel>? listBanks;
  late String valueBank = "";

  List<String> typeAccounts = ["Cta. Ahorros", "Cta. Corriente"];
  String? valueAccount;
  int? idBank;
  int? idTypeAcc;
  int? idAccount;

  final txtNombres = TextEditingController();
  final txtCorreo = TextEditingController();
  final txtCedula = TextEditingController();
  final txtNumberAcc = TextEditingController();
  TextEditingController _textEditingControllerBanks = TextEditingController();

  Future<void> getDatos() async {
    final pfrc = UserPreferences();

    setState(() => loading = true);

    txtNombres.text = await pfrc.getFullName();
    txtCedula.text = await pfrc.getUserIdentification();
    txtCorreo.text = await pfrc.getUserMail();

    final data = await wsBanks.getAllBanks();
    final account = await wsBanks.getAccountUserBank();

    if (account != null) {
      setState(() {
        valueAccount = account.tipoCuenta!;
        _textEditingControllerBanks.text = account.descripcion!;
        idBank = account.idBanco;
        idTypeAcc = account.idTipoCuenta;
        txtNumberAcc.text = account.numeroCuenta!;
        idAccount = account.idCuenta!;
        hasAccount = true;
      });
    }

    setState(() => listBanks = data ?? []);
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    getDatos();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: sckey,
        appBar: MyAppBar(key: sckey).myAppBar(),
        drawer: drawerMenu(context),
        body: options(),
      ),
    );
  }

  Widget options() => Column(
        children: [
          header("Datos de cuenta bancaria", null,
              context: context, color: Colors.grey.shade600),
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(children: [
                    formulario(),
                  ]),
                ),
                if (loading) loadingWidget(text: "Cargando..."),
                if (guardando) loadingWidget(text: "Guardando..."),
                if (actualizando) loadingWidget(text: "Actualizando...")
              ],
            ),
          )
        ],
      );

  Widget formulario() => Container(
        margin: const EdgeInsets.only(left: 15, right: 10),
        child: Form(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text(
                        "Nombres:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: InputTextFields(
                        controlador: txtNombres,
                        habilitado: false,
                        placeHolder: "Ingrese sus nombres",
                        nombreCampo: "",
                        accionCampo: TextInputAction.next),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text(
                        "Banco:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: AbsorbPointer(
                        absorbing: editarPerfil ? false : true,
                        child: Container(
                          margin: const EdgeInsets.only(right: 5, left: 5),
                          child: Autocomplete(
                            initialValue: TextEditingValue(text: valueBank),
                            optionsBuilder: (value) {
                              final filteredBanks = listBanks!.where((element) {
                                return element.descripcion!
                                    .toLowerCase()
                                    .contains(value.text.toLowerCase());
                              }).toList();

                              return filteredBanks.isNotEmpty
                                  ? filteredBanks
                                  : listBanks!;
                            },
                            onSelected: (BankModel selection) {
                              print(
                                  'Usuario seleccionó: ${selection.descripcion}');
                              // Actualiza el texto del TextField con la descripción seleccionada
                              _updateTextField(selection.descripcion!);
                            },
                            fieldViewBuilder: (context, controller, focusNode,
                                onFieldSubmitted) {
                              _textEditingControllerBanks = controller;
                              return TextField(
                                controller: controller,
                                focusNode: focusNode,
                                style: TextStyle(
                                    color: editarPerfil
                                        ? Colors.black
                                        : Colors.grey),
                                decoration: InputDecoration(
                                  hintText: "Seleccione o busque...",
                                  hintStyle: TextStyle(
                                      color: editarPerfil
                                          ? Colors.black
                                          : Colors.grey),
                                  suffixIcon: controller.text.isEmpty
                                      ? null
                                      : IconButton(
                                          onPressed: () {
                                            FocusScope.of(context).unfocus();
                                            setState(() => controller.clear());
                                          },
                                          icon: Icon(
                                            Icons.clear,
                                            color: editarPerfil
                                                ? Colors.black
                                                : Colors.grey,
                                          )),
                                  //labelText: 'Buscar',
                                ),
                              );
                            },
                            optionsViewBuilder: (context, onSelect, options) {
                              if (options.isEmpty || options.length == 1) {
                                return Container();
                              }
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  elevation: 4.0,
                                  //shadowColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  child: SizedBox(
                                    width: 260,
                                    height: 250,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        BankModel option =
                                            options.elementAt(index);

                                        return ListTile(
                                          title: Text(option.descripcion!),
                                          onTap: () {
                                            setState(
                                                () => idBank = option.idBanco);
                                            onSelect(option);
                                          },
                                        );
                                      },
                                      itemCount: listBanks!.length,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text(
                        "Tipo de cuenta:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: AbsorbPointer(
                      absorbing: editarPerfil ? false : true,
                      child: Container(
                          margin: const EdgeInsets.only(right: 10, left: 10),
                          child: DropdownButton<String>(
                            hint: const Text("Seleccione el tipo"),
                            iconEnabledColor: Colors.grey,
                            iconDisabledColor: Colors.black,
                            style: TextStyle(
                                color:
                                    editarPerfil ? Colors.black : Colors.grey),
                            isExpanded: true,
                            onChanged: (val) {
                              setState(() => valueAccount = val);
                              if (val!.contains("Aho")) {
                                setState(() => idTypeAcc = 1);
                              } else {
                                setState(() => idTypeAcc = 2);
                              }
                              debugPrint("id cuenta: $idTypeAcc");
                            },
                            //textFieldDecoration: InputDecoration(in),
                            value: valueAccount,
                            items: typeAccounts
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                          )),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text(
                        "Número de cuenta:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: InputTextFields(
                        controlador: txtNumberAcc,
                        habilitado: editarPerfil,
                        placeHolder: "Ingrese su número de cuenta",
                        nombreCampo: editarPerfil
                            ? ""
                            : txtNumberAcc.text.isEmpty
                                ? "xxxxxxxxxxx"
                                : "",
                        accionCampo: TextInputAction.next),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text(
                        "Cédula:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: InputTextFields(
                        controlador: txtCedula,
                        habilitado: false,
                        placeHolder: "Ingrese sus nombres",
                        nombreCampo: "",
                        accionCampo: TextInputAction.next),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text(
                        "Correo:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: InputTextFields(
                        controlador: txtCorreo,
                        habilitado: false,
                        placeHolder: "Ingrese sus nombres",
                        nombreCampo: "",
                        accionCampo: TextInputAction.next),
                  )
                ],
              ),
              const SizedBox(height: 30),
              if (!editarPerfil)
                nextButton(
                    onPressed: () {
                      setState(() => editarPerfil = true);
                    },
                    text: "Editar perfil",
                    width: 125),
              if (editarPerfil)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    nextButton(
                        background: Colors.red,
                        onPressed: () => setState(() => editarPerfil = false),
                        text: "Cancelar",
                        width: 125),
                    nextButton(
                        onPressed: () => actualizarDatos(),
                        text: hasAccount ? "Actualizar" : "Agregar",
                        width: 125)
                  ],
                )
            ],
          ),
        ),
      );

  void _updateTextField(String newValue) {
    setState(() {
      _textEditingControllerBanks.text = newValue;
    });
  }

  void actualizarDatos() async {
    final pfrc = UserPreferences();

    final id = await pfrc.getIdPerson();

    if (hasAccount) {
      setState(() => actualizando = true);

      final update = await wsBanks.updateUserBankAccount(
          AccountModel(
              idBanco: idBank,
              idTipoCuenta: idTypeAcc,
              numeroCuenta: txtNumberAcc.text),
          idAccount!);
      setState(() => actualizando = false);

      if (update == "ok") {
        setState(() => editarPerfil = false);
        flushBarGlobal(
            context,
            "Cuenta actualizada correctamente",
            const Icon(
              Icons.check,
              color: Colors.green,
            ));
      } else {
        flushBarGlobal(
            context,
            "No se pudo actualizar la cuenta, intentelo más tarde",
            const Icon(
              Icons.error,
              color: Colors.red,
            ));
      }
    } else {
      setState(() => guardando = true);

      final insert = await wsBanks.insertUserBankAccount(AccountModel(
          idBanco: idBank,
          idTipoCuenta: idTypeAcc,
          idUsuario: id,
          numeroCuenta: txtNumberAcc.text));

      setState(() => guardando = false);

      if (insert != 0) {
        setState(() => editarPerfil = false);
        setState(() => idAccount = insert);
        setState(() => hasAccount = true);
        flushBarGlobal(
            context,
            "Número de cuenta registrado correctamente",
            const Icon(
              Icons.check,
              color: Colors.green,
            ));
      } else {
        flushBarGlobal(
            context,
            "No se pudo registrar el número de cuenta, intentelo más tarde",
            const Icon(
              Icons.clear,
              color: Colors.red,
            ));
      }
    }
  }
}
