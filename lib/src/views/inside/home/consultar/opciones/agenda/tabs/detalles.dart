import 'dart:io';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:kmello_app/src/controller/dataBase/operations.dart';
import 'package:kmello_app/src/models/calendarEvento/calendar_model.dart';
import 'package:kmello_app/utils/loading.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../../../utils/buttons.dart';
import '../../../../../../../../utils/deviders/divider.dart';
import '../../../../../../../../utils/flushbar.dart';
import '../../../../../../../../utils/geolocator/geolocator.dart';
import '../../../../../../../../utils/icons/kmello_icons_icons.dart';
import '../../../../../../../../utils/responsive.dart';
import '../../../../../../../../utils/textFields/input_text_form_fields.dart';
import '../../../../../../../models/calendarEvento/categorias_agenda_model.dart';
import '../../../../../../../models/prospectos_model.dart';
import '../../prospectos/agregar_prospecto.dart';

class DetallesEvento extends StatefulWidget {
  int idAgenda;
  DetallesEvento({super.key, required this.idAgenda});

  @override
  State<DetallesEvento> createState() => _DetallesEventoState();
}

class _DetallesEventoState extends State<DetallesEvento> {
  final op = Operations();
  bool loading = false;
  bool edit = false;

  GlobalKey personKey = GlobalKey();
  final formKey = GlobalKey<FormState>();
  late CalendarModel calendario;
  late List<CalendarModel> eventList;

  //final webServiceEventos = WebServiceEventos();

  DateTime? fromDate;
  DateTime? toDate;

  int? idUser;

  List<String> listMails = [];

  final txtPersonController = TextEditingController();
  final txtEmpresaController = TextEditingController();
  final txtGestionController = TextEditingController();
  final controllerTitulo = TextEditingController();
  final controllerDescription = TextEditingController();
  final txtUbicacion = TextEditingController();
  final txtMail = TextEditingController();
  final txtAditionalMail = TextEditingController();
  final _controller = CustomPopupMenuController();
  final txtObservacion = TextEditingController();
  DateTime? horaLlegada;

  List<ProspectosModel> contactos = [];

  bool showContacts = false;
  bool allDay = false;

  List<ProspectosModel> _searchList = [];

  List<AgendaCatModel> categorias = [];
  AgendaCatModel? categorySelected;
  int idCategory = 0;

  List<AgendaProductModel> productos = [];
  AgendaProductModel? productSelected;
  int idProduct = 0;

  late int estado;

  int minMax = 30;
  int hourMax = 0;

  bool enable = false;
  String latitud = "";
  String longitud = "";

  List<Map<String, dynamic>> medios = [
    {"nombre": "Visita", "id": 1},
    {"nombre": "Llamada", "id": 2},
    {"nombre": "Videoconferencia", "id": 3},
  ];
  Map<String, dynamic>? medioSelected;
  int idMedio = 0;
  List<Map<String, dynamic>> gestiones = [
    {"nombre": "Venta", "id": 1},
    {"nombre": "Cobranza", "id": 2},
    {"nombre": "Recolectar documentación", "id": 3},
  ];
  Map<String, dynamic>? gestionSelected;
  int idGestion = 0;

  Future<void> getCategory() async {
    final db = Operations();

    final res = await db.obtenerCategorias();
    final res2 = await db.obtenerProductos();
    setState(() => categorias = res);
    setState(() => productos = res2);
  }

  Future<void> validateProspecto() async {
    final db = Operations();

    final res = await db.obtenerProspectos();

    if (res.isNotEmpty) {
      setState(() => enable = true);
    } else {
      setState(() => enable = false);
    }
  }

  void requestPermissionContacts() async {
    final allContacts = await op.obtenerProspectos();

    setState(() => contactos = allContacts);
    setState(() => _searchList = allContacts);
  }

  Future<void> getDataAgenda() async {
    setState(() => loading = true);
    final list = await op.obtenerDatosAgenda();
    final res = await op.obtenerAgenda(widget.idAgenda);
    final mails = await op.obtenerCorreosPorAgenda(widget.idAgenda);

    //await Future.delayed(const Duration(seconds: 1));
    setState(() => calendario = res!);

    setState(() {
      estado = calendario.estado;
      if (calendario.asistio != "") {
        horaLlegada = DateTime.parse(calendario.asistio!);
      }
      txtPersonController.text = calendario.nombreProspecto;
      txtEmpresaController.text = calendario.empresa;
      categorySelected = calendario.categoriaProducto == ""
          ? null
          : categorias
              .where(
                  (val) => val.nombreCategoria == calendario.categoriaProducto)
              .toList()[0];
      productSelected = calendario.producto == ""
          ? null
          : productos
              .where((val) => val.nombreProducto == calendario.producto)
              .toList()[0];
      medioSelected = calendario.medioContacto == ""
          ? null
          : medios
              .where((val) => val["nombre"] == calendario.medioContacto)
              .toList()[0];
      gestionSelected = calendario.gestion == ""
          ? null
          : gestiones
              .where((val) => val["nombre"] == calendario.gestion)
              .toList()[0];
      if (calendario.allDay == "T") {
        allDay = true;
        fromDate = null;
        toDate = null;
      } else {
        final dateEvent = DateTime.parse(calendario.fechaReunion);
        final fromTime = calendario.horaInicio.split(":");
        final toTime = calendario.horaFin.split(":");

        fromDate = DateTime(dateEvent.year, dateEvent.month, dateEvent.day,
            int.parse(fromTime[0]), int.parse(fromTime[1]));

        toDate = DateTime(dateEvent.year, dateEvent.month, dateEvent.day,
            int.parse(toTime[0]), int.parse(toTime[1]));
      }
      txtUbicacion.text = calendario.lugarReunion;
      if (calendario.latitud != "" && calendario.longitud != "") {
        latitud = calendario.latitud;
        longitud = calendario.longitud;
      }
      txtMail.text = calendario.correo;
      txtObservacion.text = calendario.observacion;

      if (mails.isNotEmpty) {
        for (var mail in mails) {
          listMails.add(mail.correo);
        }
      }
    });

    setState(() => eventList = list);
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    requestPermissionContacts();
    getCategory();
    validateProspecto();
    getDataAgenda();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [form(), if (loading) loadingWidget(text: "Cargando...")],
    );
  }

  Widget form() => Form(
        key: formKey,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  if (horaLlegada != null)
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      width: double.infinity,
                      child: Text(
                          "Llegada confirmada: ${DateFormat("dd/MM").format(horaLlegada!)} a las ${DateFormat("HH:mm").format(horaLlegada!)}"),
                    ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      if (!enable) {
                        flushBarGlobal(
                            context,
                            "No ha registrado prospectos, por favor diríjase a la sección de prospectos y registre uno",
                            const Icon(Icons.warning, color: Colors.yellow),
                            seconds: 4,
                            trailing: IconButton(
                                onPressed: () async => await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) =>
                                                AgregarEditarProspecto(
                                                    edit: false)))
                                    .then((_) => validateProspecto()),
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Colors.white,
                                )));
                      }
                    },
                    child: Container(
                      height: 60,
                      key: personKey,
                      child: InputTextFormFields(
                        validacion: (value) =>
                            value!.isEmpty ? "Campo Obligatorio*" : null,
                        habilitado: enable ? edit : edit,
                        controlador: txtPersonController,
                        capitalization: TextCapitalization.words,
                        accionCampo: TextInputAction.next,
                        onChanged: (value) {
                          if (value!.isNotEmpty) {
                            setState(() => showContacts = true);
                            buildSearchList(value);
                          } else {
                            setState(() => _searchList = contactos);
                            setState(() => showContacts = false);
                          }
                        },
                        nombreCampo: "Persona",
                        placeHolder: "Nombre del contacto",
                        prefixIcon:
                            const Icon(KmelloIcons.persona_empresa, size: 20),
                        icon: txtPersonController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () => setState(() {
                                      showContacts = false;
                                      txtPersonController.clear();
                                      FocusScope.of(context).unfocus();
                                    }),
                                icon: const Icon(Icons.clear))
                            : null,
                      ),
                    ),
                  ),
                  InputTextFormFields(
                    habilitado: edit,
                    controlador: txtEmpresaController,
                    capitalization: TextCapitalization.sentences,
                    accionCampo: TextInputAction.next,
                    nombreCampo: "Empresa",
                    prefixIcon:
                        const Icon(KmelloIcons.persona_empresa, size: 20),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: DropdownButtonFormField<AgendaCatModel>(
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText: "Seleccione una categoría",
                            prefixIcon: Icon(KmelloIcons.prodcuto_categoria),
                            label: Text("Categoría del Producto")),
                        isExpanded: true,
                        value: categorySelected,
                        items: categorias
                            .map((e) => DropdownMenuItem(
                                  child: Text(e.nombreCategoria),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: edit
                            ? (value) {
                                setState(() {
                                  productSelected = null;
                                  categorySelected = value;
                                  idCategory = value!.idCategoria!;
                                });
                              }
                            : null),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: DropdownButtonFormField<AgendaProductModel>(
                        iconDisabledColor: Colors.grey,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText: "Seleccione un producto",
                            prefixIcon: Icon(KmelloIcons.prodcuto_categoria),
                            label: Text("Producto")),
                        isExpanded: true,
                        value: productSelected,
                        items: categorySelected != null
                            ? productos
                                .where((element) =>
                                    element.idCategoria ==
                                    categorySelected!.idCategoria)
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.nombreProducto),
                                    ))
                                .toList()
                            : [],
                        onChanged: edit
                            ? (value) {
                                setState(() {
                                  productSelected = value;
                                  idProduct = value!.idProducto!;
                                });
                              }
                            : null),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: DropdownButtonFormField<Map<String, dynamic>>(
                        iconDisabledColor: Colors.grey,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText: "Seleccione un medio",
                            prefixIcon: Icon(KmelloIcons.medio_contacto),
                            label: Text("Medio de contacto")),
                        isExpanded: true,
                        value: medioSelected,
                        items: medios
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e["nombre"]),
                                ))
                            .toList(),
                        onChanged: edit
                            ? (value) {
                                setState(() {
                                  medioSelected = value;
                                  idMedio = value!["id"];
                                });
                              }
                            : null),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: DropdownButtonFormField<Map<String, dynamic>>(
                        iconDisabledColor: Colors.grey,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText: "Seleccione la gestion",
                            prefixIcon: Icon(KmelloIcons.gestion),
                            label: Text("Gestión")),
                        isExpanded: true,
                        value: gestionSelected,
                        items: gestiones
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e["nombre"]),
                                ))
                            .toList(),
                        onChanged: edit
                            ? (value) {
                                setState(() {
                                  gestionSelected = value;
                                  idGestion = value!["id"];
                                });
                              }
                            : null),
                  ),
                  const SizedBox(height: 15),
                  AbsorbPointer(
                      absorbing: edit ? false : true, child: showDate()),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: InputTextFormFields(
                            habilitado: edit,
                            controlador: txtUbicacion,
                            prefixIcon: const Icon(Icons.place),
                            accionCampo: TextInputAction.next,
                            nombreCampo: "Ubicación",
                            placeHolder: "Ingrese la ubicación de la reunión"),
                      ),
                      if (latitud != "")
                        Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: latitud != "" && longitud != ""
                                ? edit
                                    ? PopupMenuButton(
                                        icon: Icon(Icons.location_on_rounded,
                                            color: edit
                                                ? Colors.green
                                                : Colors.grey),
                                        onSelected: (index) async {
                                          debugPrint(index);
                                          switch (index) {
                                            case "1":
                                              setState(() => loading = true);

                                              var res = await GeolocatorConfig()
                                                  .requestPermission(context);

                                              if (res != null) {
                                                var loc = await Geolocator
                                                    .getCurrentPosition();

                                                setState(() {
                                                  latitud =
                                                      loc.latitude.toString();
                                                  longitud =
                                                      loc.longitude.toString();
                                                });

                                                debugPrint(
                                                    "$latitud, $longitud");

                                                flushBarGlobal(
                                                    context,
                                                    "Se han guardado las coordenadas de tu ubicación actual.",
                                                    const Icon(Icons.check,
                                                        color: Colors.green));
                                              } else {
                                                flushBarGlobal(
                                                    context,
                                                    "Ocurrió un error, no hemos podido guardar tu ubicación actual",
                                                    const Icon(Icons.error,
                                                        color: Colors.red));
                                              }

                                              setState(() => loading = false);
                                              break;
                                            case "2":
                                              var url =
                                                  "https://maps.google.com/maps?q=loc:$latitud,$longitud";
                                              /*var url =
                                            "https://www.google.com/maps/@$latitud,$longitud,6z";*/
                                              if (await canLaunchUrl(
                                                  Uri.parse(url))) {
                                                await launchUrl(Uri.parse(url));
                                              } else {
                                                flushBarGlobal(
                                                    context,
                                                    "No se pudo ejecutar la acción",
                                                    const Icon(Icons.error,
                                                        color: Colors.red));
                                              }
                                              break;
                                            default:
                                          }
                                        },
                                        itemBuilder: (itemBuilder) {
                                          List<PopupMenuEntry> listMenut = [];

                                          listMenut.add(const PopupMenuItem(
                                              child: Text(
                                                  "Actualizar coordenadas"),
                                              value: "1"));
                                          listMenut.add(const PopupMenuItem(
                                              child: Text("Ir a mapas"),
                                              value: "2"));
                                          return listMenut;
                                        })
                                    : IconButton(
                                        onPressed: () async {
                                          var url =
                                              "https://maps.google.com/maps?q=loc:$latitud,$longitud";
                                          /*var url =
                                            "https://www.google.com/maps/@$latitud,$longitud,6z";*/
                                          if (await canLaunchUrl(
                                              Uri.parse(url))) {
                                            await launchUrl(Uri.parse(url));
                                          } else {
                                            flushBarGlobal(
                                                context,
                                                "No se pudo ejecutar la acción",
                                                const Icon(Icons.error,
                                                    color: Colors.red));
                                          }
                                        },
                                        icon: const Icon(Icons.map,
                                            color: Colors.green))
                                : IconButton(
                                    onPressed: () async {
                                      setState(() => loading = true);

                                      var res = await GeolocatorConfig()
                                          .requestPermission(context);

                                      if (res != null) {
                                        var loc = await Geolocator
                                            .getCurrentPosition();

                                        setState(() {
                                          latitud = loc.latitude.toString();
                                          longitud = loc.longitude.toString();
                                        });

                                        debugPrint("$latitud, $longitud");

                                        flushBarGlobal(
                                            context,
                                            "Se han guardado las coordenadas de tu ubicación actual.",
                                            const Icon(Icons.check,
                                                color: Colors.green));
                                      } else {
                                        flushBarGlobal(
                                            context,
                                            "Ocurrió un error, no hemos podido guardar tu ubicación actual",
                                            const Icon(Icons.error,
                                                color: Colors.red));
                                      }

                                      setState(() => loading = false);
                                    },
                                    icon: const Icon(
                                        Icons.add_location_alt_rounded)))
                    ],
                  ),
                  const SizedBox(height: 15),
                  InputTextFormFields(
                      habilitado: edit,
                      controlador: txtMail,
                      prefixIcon: const Icon(Icons.mail),
                      accionCampo: TextInputAction.next,
                      nombreCampo: "Correo prospecto para notificar",
                      placeHolder: "Ingrese el correo del prospecto"),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: edit ? () => showModalMails() : null,
                    child: Container(
                      decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey))),
                      width: double.infinity,
                      height: 50,
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: [
                          Container(
                              margin: const EdgeInsets.only(left: 13),
                              child: Icon(
                                Icons.mail,
                                color: Colors.grey.shade800,
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Text(
                            "Correos adicionales para notificar (${listMails.length})",
                            style: TextStyle(
                                fontSize: 15,
                                color: edit ? Colors.black : Colors.grey),
                          ))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  InputTextFormFields(
                      habilitado: edit,
                      prefixIcon: const Icon(
                        KmelloIcons.observaciones,
                        size: 20,
                      ),
                      maxLines: 3,
                      controlador: txtObservacion,
                      accionCampo: TextInputAction.next,
                      nombreCampo: "Observaciones",
                      placeHolder:
                          "Ingrese las observaciones correspondientes"),
                  /*const SizedBox(height: 15),
                          Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: DropdownButtonFormField<Map<String, dynamic>>(
                                iconDisabledColor: Colors.grey,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    hintText: "Seleccione el resultado",
                                    prefixIcon: Icon(KmelloIcons.resultado_reunion),
                                    label: Text("Resultado de la reunión")),
                                isExpanded: true,
                                value: resultadoSelected,
                                items: resultado
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e["nombre"]),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    resultadoSelected = value;
                                    idMedio = value!["id"];
                                  });
                                }),
                          ),*/
                  const SizedBox(height: 25),
                  if (estado == 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        nextButton(
                            width: 100,
                            onPressed: () => Platform.isAndroid
                                ? cancelarReunionAnd()
                                : cancelarReunionIos(),
                            text: "Cancelar",
                            background: Colors.red),
                        if (edit) const SizedBox(width: 10),
                        if (edit)
                          nextButton(
                              onPressed: () => validateButton(),
                              text: "Actualizar",
                              width: 100),
                      ],
                    ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: AnimatedOpacity(
                opacity: showContacts ? 1 : 0,
                duration: const Duration(milliseconds: 500),
                child: Visibility(
                  visible: showContacts,
                  child: GestureDetector(
                    onTap: () {
                      debugPrint("hola");
                    },
                    child: Container(
                      margin:
                          const EdgeInsets.only(top: 62, left: 10, right: 10),
                      width: double.infinity, //250,
                      height: 225,
                      child: Material(
                        borderRadius: BorderRadius.circular(15),
                        elevation: 4,
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          child: ListView.builder(
                              itemCount: _searchList.length,
                              itemBuilder: (itemBuilder, i) {
                                return InkWell(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      idUser = _searchList[i].idProspecto;
                                      txtPersonController.text =
                                          _searchList[i].nombres;
                                      showContacts = false;

                                      if (_searchList[i].direccion.isNotEmpty) {
                                        txtUbicacion.text =
                                            _searchList[i].direccion;
                                        if (_searchList[i].latitud != "") {
                                          latitud = _searchList[i].latitud;
                                          longitud = _searchList[i].longitud;
                                        }

                                        txtMail.text = _searchList[i].mail;
                                      }
                                    });
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    color: Colors.white,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                      ),
                                      height: 45,
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Row(
                                        children: [
                                          Text(
                                            _searchList[i].nombres,
                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(
                                              child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(_searchList[i].celular),
                                          ))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (estado == 0)
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: const EdgeInsets.only(right: 15, bottom: 25),
                  child: FloatingActionButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      backgroundColor: edit ? Colors.red : Colors.black,
                      child: Icon(edit ? Icons.clear : Icons.edit,
                          color: Colors.white),
                      onPressed: () => setState(() {
                            edit = !edit;
                          })),
                ),
              )
          ],
        ),
      );

  void validateButton() async {
    if (!formKey.currentState!.validate()) {
      flushBarGlobal(context, "Complete los campos para continuar",
          const Icon(Icons.error, color: Colors.red));
      return;
    } else {
      final agenda = CalendarModel(
        estado: 0,
        fotoReferencia: calendario.fotoReferencia,
        categoriaProducto:
            categorySelected != null ? categorySelected!.nombreCategoria : "",
        empresa: txtEmpresaController.text,
        gestion: gestionSelected != null ? gestionSelected!["nombre"] : "",
        idProspecto: calendario.idProspecto,
        lugarReunion: txtUbicacion.text,
        medioContacto: medioSelected != null ? medioSelected!["nombre"] : "",
        nombreProspecto: txtPersonController.text,
        producto:
            productSelected != null ? productSelected!.nombreProducto : "",
        resultadoReunion: "",
        allDay: allDay ? "T" : "N",
        fechaReunion: fromDate.toString(),
        horaFin: toDate != null ? DateFormat("HH:mm").format(toDate!) : "",
        horaInicio:
            fromDate != null ? DateFormat("HH:mm").format(fromDate!) : "",
        observacion: txtObservacion.text,
        latitud: latitud,
        longitud: longitud,
        correo: txtMail.text,
      );

      final res = await op.actualizarAgenda(widget.idAgenda, agenda);

      setState(() => loading = true);
      await Future.delayed(const Duration(seconds: 1));

      if (res != 0) {
        Navigator.pop(context);
        flushBarGlobal(context, "Agenda actualizada correctamente",
            const Icon(Icons.check, color: Colors.green));
      } else {
        flushBarGlobal(context, "No se pudo actualizar la agenda",
            const Icon(Icons.error, color: Colors.red));
      }

      setState(() => loading = false);
    }
  }

  Widget showDate() {
    return Container(
      padding: const EdgeInsets.only(left: 23, right: 10),
      child: Column(
        children: [
          Row(
            children: [
              Row(
                children: [
                  const Icon(
                    KmelloIcons.fecha,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "Fecha",
                    style: TextStyle(
                        fontSize: 18, color: edit ? Colors.black : Colors.grey),
                  )
                ],
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Todo el día",
                    style: TextStyle(
                        fontSize: 18, color: edit ? Colors.black : Colors.grey),
                  ),
                  const SizedBox(width: 5),
                  Switch(
                      value: allDay,
                      onChanged: (value) {
                        setState(() => allDay = value);
                        fromDate = null;
                        toDate = null;
                      })
                ],
              )),
              AbsorbPointer(
                absorbing: allDay,
                child: CustomPopupMenu(
                  child: Icon(
                    Icons.timelapse,
                    color: edit
                        ? allDay
                            ? Colors.grey
                            : Colors.black
                        : Colors.grey,
                  ),
                  menuBuilder: () {
                    return Card(
                      child: Container(
                        width: 100,
                        color: Colors.white,
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () => setState(() {
                                minMax = 15;
                                _controller.hideMenu();
                                configurationTime(
                                    range: true, isFromDate: true);
                              }),
                              child: Container(
                                height: 45,
                                alignment: Alignment.center,
                                child: const Text(
                                  "15 min",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            divider(false, color: Colors.grey),
                            InkWell(
                              onTap: () => setState(() {
                                minMax = 30;
                                _controller.hideMenu();
                                configurationTime(
                                    range: true, isFromDate: true);
                              }),
                              child: Container(
                                height: 45,
                                alignment: Alignment.center,
                                child: const Text(
                                  "30 min",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            divider(false, color: Colors.grey),
                            InkWell(
                              onTap: () => setState(() {
                                minMax = 0;
                                hourMax = 1;
                                _controller.hideMenu();
                                configurationTime(
                                    range: true, isFromDate: true);
                              }),
                              child: Container(
                                height: 45,
                                alignment: Alignment.center,
                                child: const Text(
                                  "1h",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  pressType: PressType.singleClick,
                  verticalMargin: -10,
                  controller: _controller,
                ),
              ),
            ],
          ),
          allDay
              ? Container()
              : Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                          width: double.infinity,
                          height: 120,
                          child: CupertinoTheme(
                            data: CupertinoThemeData(
                                textTheme: CupertinoTextThemeData(
                                    dateTimePickerTextStyle: TextStyle(
                                        fontSize: 14,
                                        color: edit
                                            ? Colors.black
                                            : Colors.grey))),
                            child: CupertinoDatePicker(
                              initialDateTime:
                                  DateTime.parse(calendario.fechaReunion),
                              mode: CupertinoDatePickerMode.dateAndTime,
                              use24hFormat: true,
                              showDayOfWeek: false,
                              onDateTimeChanged: (DateTime? newDate) {
                                final newList = eventList;
                                if (newDate != null) {
                                  setState(() => fromDate = newDate);
                                  configurationTime(
                                      range: true, isFromDate: true);
                                  final timeDay = newList
                                      .where((element) =>
                                          DateTime.parse(element.fechaReunion)
                                                  .hour ==
                                              newDate.hour &&
                                          DateTime.parse(element.fechaReunion)
                                                  .minute ==
                                              newDate.minute &&
                                          DateTime.parse(element.fechaReunion)
                                                  .day ==
                                              newDate.day)
                                      .toList();

                                  if (timeDay.isNotEmpty) {
                                    flushBarGlobal(
                                        context,
                                        "Esta hora ya ha sido registrada en otra reunión",
                                        const Icon(Icons.error,
                                            color: Colors.red));
                                  }
                                } else {}
                              },
                            ),
                          )),
                    ),
                    Container(
                      height: 120,
                      child: const VerticalDivider(
                        width: 1,
                        color: Colors.black,
                        thickness: 0.5,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        height: 120,
                        child: CupertinoTheme(
                          data: CupertinoThemeData(
                              textTheme: CupertinoTextThemeData(
                                  dateTimePickerTextStyle: TextStyle(
                                      fontSize: 14,
                                      color:
                                          edit ? Colors.black : Colors.grey))),
                          child: CupertinoDatePicker(
                              key: UniqueKey(),
                              use24hFormat: true,
                              showDayOfWeek: false,
                              initialDateTime: toDate ??
                                  DateTime.parse(calendario.fechaReunion),
                              mode: CupertinoDatePickerMode.time,
                              onDateTimeChanged: (DateTime? date) {
                                if (date != null) {
                                  setState(() => toDate = date);
                                  configurationTime(
                                      range: false, isFromDate: false);
                                }
                              }),
                        ),
                      ),
                    )
                  ],
                ),
        ],
      ),
    );
  }

  void showModalMails() async {
    final rsp = Responsive.of(context);
    showModalBottomSheet(
        enableDrag: true,
        isDismissible: true,
        isScrollControlled: true,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        context: context,
        builder: (builder) {
          return Stack(
            children: [
              SizedBox(
                height: rsp.hp(60),
                width: double.infinity,
                child: Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Correos Adicionales",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      divider(true, color: Colors.grey),
                      Expanded(
                        child: ListView.builder(
                            itemCount: listMails.length,
                            itemBuilder: (context, i) {
                              return Slidable(
                                  key: UniqueKey(),
                                  direction: Axis.horizontal,
                                  startActionPane: ActionPane(
                                      extentRatio: 0.35,
                                      motion: const DrawerMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (_) {
                                            Navigator.pop(context);
                                            setState(() => loading = true);
                                            setState(() =>
                                                listMails.remove(listMails[i]));

                                            flushBarGlobal(
                                                context,
                                                "Correo eliminado de la lista",
                                                const Icon(Icons.check,
                                                    color: Colors.green));
                                            setState(() => loading = false);
                                          },
                                          flex: 1,
                                          autoClose: true,
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.red,
                                          icon: Icons.delete,
                                        ),
                                      ]),
                                  child: Container(
                                      height: 60,
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Card(
                                        child: Row(
                                          children: [
                                            Container(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                alignment: Alignment.centerLeft,
                                                child: Text(listMails[i])),
                                          ],
                                        ),
                                      )));
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 25,
                right: 15,
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  backgroundColor: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                    ingresarCorreo();
                  },
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              )
            ],
          );
        });
  }

  void ingresarCorreo() {
    showDialog(
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (context, state) {
            return AlertDialog(
              title: const Text("Agregar correo"),
              content: InputTextFormFields(
                controlador: txtAditionalMail,
                nombreCampo: "Correo adicional",
                placeHolder: "Ingrese un correo electrónico",
                tipoTeclado: TextInputType.emailAddress,
              ),
              actions: [
                loading
                    ? const Center(child: Text("Agregando..."))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25))),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black)),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Cancelar",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          TextButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25))),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black)),
                              onPressed: () async {
                                Navigator.pop(context);
                                state(() => loading = true);
                                state(() {
                                  listMails.add(txtAditionalMail.text);
                                });

                                flushBarGlobal(
                                    context,
                                    "Correo agregado correctamente",
                                    const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ));
                                state(() => loading = false);
                              },
                              child: const Text("Agregar",
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.white))),
                        ],
                      )
              ],
            );
          });
        }).then((value) {
      setState(() => txtAditionalMail.clear());
    });
  }

  void configurationTime({required bool range, required bool isFromDate}) {
    if (isFromDate) {
      if (fromDate != null) {
        if (range) {
          DateTime newDate = fromDate!
              .add(Duration(minutes: minMax, hours: minMax == 0 ? hourMax : 0));

          debugPrint("NEW TIME: ${newDate.hour}:${newDate.minute}");

          setState(() => toDate = newDate);
        } else {
          setState(() => toDate = toDate);
        }

        setState(() {});
      }
    } else {
      if (toDate != null) {
        //setState(() => toDate = newToDate);
        setState(() {});
      }

      /*DateTime newDate = fromDate!
          .add(Duration(minutes: newToDate!.minute, hours: newToDate.hour));*/
      /*setState(() => fromDate!.add(Duration(
          minutes: newToDate!.minute, hours: newToDate.hour - fromDate!.hour)));
      setState(() => toDate = newToDate);*/
    }
  }

  void cancelarReunionIos() async {
    showDialog(
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: const Text("Cancelar evento"),
            content: const Text("¿Está seguro que desea cancelar el evento?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No")),
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    Navigator.pop(context);

                    setState(() => loading = true);
                    final res =
                        await op.actualizarEstadoReunion(1, widget.idAgenda);

                    if (res == 1) {
                      flushBarGlobal(
                          context,
                          "Reunión cancelada",
                          const Icon(
                            Icons.check,
                            color: Colors.green,
                          ));
                    } else {
                      flushBarGlobal(
                          context,
                          "No se pudo cancelar la reunión",
                          const Icon(
                            Icons.error,
                            color: Colors.red,
                          ));
                    }
                    setState(() => loading = false);
                  },
                  child: const Text("Si")),
            ],
          );
        });
  }

  void cancelarReunionAnd() async {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            title: const Text("Cancelar evento"),
            content: const Text("¿Está seguro que desea cancelar el evento?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No")),
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    setState(() => loading = true);
                    final res =
                        await op.actualizarEstadoReunion(1, widget.idAgenda);

                    if (res == 1) {
                      flushBarGlobal(
                          context,
                          "Reunión cancelada",
                          const Icon(
                            Icons.check,
                            color: Colors.green,
                          ));
                    } else {
                      flushBarGlobal(
                          context,
                          "No se pudo cancelar la reunión",
                          const Icon(
                            Icons.error,
                            color: Colors.red,
                          ));
                    }
                    setState(() => loading = false);
                  },
                  child: const Text("Si")),
            ],
          );
        });
  }

  void buildSearchList(text) {
    if (text != "") {
      final list = contactos
          .where((element) => element.nombres
              .toLowerCase()
              .contains(text.toString().toLowerCase()))
          .toList();
      if (list.isNotEmpty) {
        setState(() => _searchList = list);
      } else {
        setState(() => showContacts = false);
      }
    } else {
      setState(() => _searchList = contactos);
    }
  }
}
