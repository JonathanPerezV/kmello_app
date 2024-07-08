// ignore_for_file: must_be_immutable, missing_required_param, use_build_context_synchronously
import 'dart:async';
import 'dart:io';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:kmello_app/main.dart';
import 'package:kmello_app/src/controller/dataBase/operations.dart';
import 'package:kmello_app/src/models/calendarEvento/calendar_model.dart';
import 'package:kmello_app/src/models/calendarEvento/categorias_agenda_model.dart';
import 'package:kmello_app/src/models/correo_model.dart';
import 'package:kmello_app/src/models/prospectos_model.dart';
import 'package:kmello_app/src/views/inside/home/consultar/opciones/agenda/agenda.dart';
import 'package:kmello_app/src/views/inside/home/consultar/opciones/agenda/tabs/info_evento.dart';
import 'package:kmello_app/src/views/inside/home/consultar/opciones/prospectos/agregar_prospecto.dart';
import 'package:kmello_app/utils/alerts/and_alert.dart';
import 'package:kmello_app/utils/alerts/ios_alert.dart';
import 'package:kmello_app/utils/buttons.dart';
import 'package:kmello_app/utils/deviders/divider.dart';
import 'package:kmello_app/utils/flushbar.dart';
import 'package:kmello_app/utils/loading.dart';
import 'package:mobkit_calendar/mobkit_calendar.dart';
import '../../../../../../../utils/geolocator/geolocator.dart';
import '../../../../../../../utils/responsive.dart';
import '../../../../../../models/calendarEvento/event.dart' as evn;
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:kmello_app/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:kmello_app/utils/app_bar.dart';
import 'package:kmello_app/utils/header.dart';
import 'package:kmello_app/utils/icons/kmello_icons_icons.dart';
import 'package:kmello_app/utils/textFields/input_text_form_fields.dart';
import 'package:kmello_app/utils/util_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textfield_search/textfield_search.dart';

class EventEditingPage extends StatefulWidget {
  evn.Event? event;
  List<MobkitCalendarAppointmentModel>? eventList;
  DateTime? startDate;
  EventEditingPage({Key? key, this.event, this.startDate, this.eventList})
      : super(key: key);

  @override
  State<EventEditingPage> createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  final key = GlobalKey<ScaffoldState>();
  GlobalKey personKey = GlobalKey();
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  late Timer _timer;

  //final webServiceEventos = WebServiceEventos();

  DateTime? fromDate;
  late ValueNotifier<DateTime?> toDate;

  final iosAlert = IosAlert();
  final andAlert = AndroidAlert();

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

  /*List<Map<String, dynamic>> resultado = [
    {"nombre": "Llenó solicitud", "id": 1},
    {"nombre": "Analizará la decisión", "id": 2},
    {"nombre": "No desea", "id": 3},
    {"nombre": "Coordinar otra visita", "id": 4}
  ];
  Map<String, dynamic>? resultadoSelected;
  int idResultado = 0;*/

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

    final res = await db.obtenerAllProspectos();

    if (res.isNotEmpty) {
      setState(() => enable = true);
    } else {
      setState(() => enable = false);
    }
  }

  void requestPermissionContacts() async {
    final allContacts = await op.obtenerAllProspectos();

    setState(() => contactos = allContacts);
    setState(() => _searchList = allContacts);
  }

  @override
  void initState() {
    super.initState();
    setState(() => loading = true);
    obtenerIdUser();
    requestPermissionContacts();
    getCategory();
    validateProspecto();
    if (widget.startDate != null) {
      final startDate = widget.startDate;
      setState(() {
        fromDate = DateTime.now().minute <= 30
            ? DateTime(startDate!.year, startDate.month, startDate.day,
                DateTime.now().hour, 30)
            : DateTime(startDate!.year, startDate.month, startDate.day,
                DateTime.now().add(const Duration(hours: 1)).hour, 00);

        toDate = ValueNotifier(fromDate!.add(Duration(minutes: minMax)));
      });
    } else {
      var date = DateTime.now();
      if (date.minute <= 30) {
        setState(() => fromDate =
            DateTime(date.year, date.month, date.day, date.hour, 30));
      } else {
        setState(() => fromDate = DateTime(date.year, date.month, date.day,
            date.add(const Duration(hours: 1)).hour, 00));
      }

      toDate = ValueNotifier(fromDate!.add(Duration(minutes: minMax)));
    }
    setState(() => loading = false);
  }

  Future<void> obtenerIdUser() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      idUser = preferences.getInt('idUsuario');
    });
  }

  @override
  void dispose() {
    controllerTitulo.dispose();
    toDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => showContacts = false);
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        // backgroundColor: showContacts ? Colors.grey.shade400 : Colors.white,
        key: key,
        appBar: MyAppBar(key: key).myAppBar(),
        drawer: drawerMenu(context),
        body: listaOpciones(),
      ),
    );
  }

  Widget listaOpciones() {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      header("Agregar Evento", KmelloIcons.evento, context: context),
      Expanded(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [form()],
              ),
            ),
            if (loading) loadingWidget(),
          ],
        ),
      ),
    ]);
  }

  Widget form() => Container(
        width: double.infinity,
        // margin: EdgeInsets.only(left: 10, right: 10),
        child: Form(
            key: formKey,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
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
                            habilitado: enable,
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
                            prefixIcon: const Icon(KmelloIcons.persona_empresa,
                                size: 20),
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
                                prefixIcon:
                                    Icon(KmelloIcons.prodcuto_categoria),
                                label: Text("Categoría del Producto")),
                            isExpanded: true,
                            value: categorySelected,
                            items: categorias
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.nombreCategoria),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                productSelected = null;
                                categorySelected = value;
                                idCategory = value!.idCategoria!;
                              });
                            }),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: DropdownButtonFormField<AgendaProductModel>(
                            iconDisabledColor: Colors.grey,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: "Seleccione un producto",
                                prefixIcon:
                                    Icon(KmelloIcons.prodcuto_categoria),
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
                            onChanged: (value) {
                              setState(() {
                                productSelected = value;
                                idProduct = value!.idProducto!;
                              });
                            }),
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
                            onChanged: (value) {
                              setState(() {
                                medioSelected = value;
                                idMedio = value!["id"];
                              });
                            }),
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
                            onChanged: (value) {
                              setState(() {
                                gestionSelected = value;
                                idGestion = value!["id"];
                              });
                            }),
                      ),
                      const SizedBox(height: 15),
                      showDate(),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: InputTextFormFields(
                                controlador: txtUbicacion,
                                prefixIcon: const Icon(Icons.place),
                                accionCampo: TextInputAction.next,
                                nombreCampo: "Ubicación",
                                placeHolder:
                                    "Ingrese la ubicación de la reunión"),
                          ),
                          if (latitud != "")
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: latitud != "" && longitud != ""
                                  ? GestureDetector(
                                      onTap: () async {
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
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Colors.green,
                                      ),
                                    )
                                  : const Icon(Icons.add_location_alt),
                            ),
                        ],
                      ),
                      /* const SizedBox(height: 35),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          width: double.infinity,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: const Text(
                            "+ Subir documento",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ),*/
                      const SizedBox(height: 35),
                      InputTextFormFields(
                          controlador: txtMail,
                          prefixIcon: const Icon(Icons.mail),
                          accionCampo: TextInputAction.next,
                          nombreCampo: "Correo prospecto para notificar",
                          placeHolder: "Ingrese el correo del prospecto"),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () => showModalMails(),
                        child: Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
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
                                style: const TextStyle(fontSize: 15),
                              ))
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      InputTextFormFields(
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
                      nextButton(
                          onPressed: () => validateButton(),
                          text: "Guardar evento",
                          width: 150),
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
                          margin: const EdgeInsets.only(
                              top: 62, left: 10, right: 10),
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
                                          txtEmpresaController.text =
                                              _searchList[i].empresa;
                                          showContacts = false;

                                          if (_searchList[i]
                                              .direccion
                                              .isNotEmpty) {
                                            txtUbicacion.text =
                                                _searchList[i].direccion;
                                            if (_searchList[i].latitud != "") {
                                              latitud = _searchList[i].latitud;
                                              longitud =
                                                  _searchList[i].longitud;
                                            }

                                            txtMail.text = _searchList[i].mail;
                                          }
                                        });
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        color: Colors.white,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: /*_searchList[i].cliente == 1
                                                ? Colors.green.shade100
                                                : */
                                                Colors.white,
                                          ),
                                          height: 45,
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: Row(
                                            children: [
                                              Text(
                                                "${_searchList[i].nombres.split(" ")[0]} ${_searchList[i].nombres.split(" ")[2]}",
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Expanded(
                                                  child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                    _searchList[i].celular),
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
              ],
            )),
      );

  Widget showDate() {
    return Container(
      margin: const EdgeInsets.only(left: 23, right: 10),
      child: Column(
        children: [
          Row(
            children: [
              const Row(
                children: [
                  Icon(
                    KmelloIcons.fecha,
                  ),
                  SizedBox(width: 15),
                  Text(
                    "Fecha",
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
              Expanded(
                  child: !allDay
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Todo el día",
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 5),
                            SizedBox(
                              height: 30,
                              child: FittedBox(
                                child: Switch(
                                    value: allDay,
                                    onChanged: (value) {
                                      setState(() => allDay = value);
                                      fromDate = null;
                                      toDate.value = null;
                                    }),
                              ),
                            )
                          ],
                        )),
              allDay
                  ? InkWell(
                      onTap: () => setState(() => allDay = !allDay),
                      child: const Icon(Icons.arrow_drop_down))
                  : AbsorbPointer(
                      absorbing: allDay,
                      child: CustomPopupMenu(
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
                                      hourMax = 0;
                                      _controller.hideMenu();
                                      //configurationTime();
                                      _updateEndTime(Duration(minutes: minMax));
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
                                      hourMax = 0;
                                      _controller.hideMenu();
                                      //configurationTime();\
                                      _updateEndTime(Duration(minutes: minMax));
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
                                      //configurationTime();
                                      _updateEndTime(
                                          const Duration(minutes: 60));
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
                        child: Icon(
                          Icons.timelapse,
                          color: allDay ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 10),
          allDay
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 2,
                        child: Row(children: [
                          Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Todo el día",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  const SizedBox(width: 3),
                                  SizedBox(
                                    height: 25,
                                    child: FittedBox(
                                      child: Switch(
                                          value: allDay,
                                          onChanged: (value) {
                                            setState(() => allDay = value);
                                            fromDate = null;
                                            toDate.value = null;
                                          }),
                                    ),
                                  )
                                ],
                              )),
                          const Expanded(
                              flex: 1,
                              child: Center(
                                  child: Text(
                                "Hora inicio",
                                style: TextStyle(fontSize: 17),
                              )))
                        ])),
                    Container(
                      width: 1,
                      height: 10,
                      color: Colors.black,
                    ),
                    const Expanded(
                        child: Center(
                            child: Text(
                      "Hora fin",
                      style: TextStyle(fontSize: 17),
                    )))
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
                            data: const CupertinoThemeData(
                                textTheme: CupertinoTextThemeData(
                                    dateTimePickerTextStyle: TextStyle(
                                        fontSize: 14, color: Colors.black))),
                            child: CupertinoDatePicker(
                              initialDateTime: fromDate,
                              mode: CupertinoDatePickerMode.dateAndTime,
                              use24hFormat: true,
                              showDayOfWeek: false,
                              onDateTimeChanged: (DateTime? newDate) {
                                //final newList = widget.eventList;
                                if (newDate != null) {
                                  //configurationTime();
                                  setState(() => fromDate = newDate);
                                  setState(() => _updateEndTime(Duration(
                                      minutes: minMax,
                                      hours: hourMax != 0 ? hourMax : 0)));
                                  // final timeDay = newList!
                                  //     .where((element) =>
                                  //         element.appointmentStartDate.hour ==
                                  //             newDate.hour &&
                                  //         element.appointmentStartDate.minute ==
                                  //             newDate.minute &&
                                  //         element.appointmentStartDate.day ==
                                  //             newDate.day)
                                  //     .toList();

                                  // if (timeDay.isNotEmpty) {
                                  //   flushBarGlobal(
                                  //       context,
                                  //       "Esta hora ya ha sido registrada en otra reunión",
                                  //       const Icon(Icons.error,
                                  //           color: Colors.red));
                                  // }
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
                          data: const CupertinoThemeData(
                              textTheme: CupertinoTextThemeData(
                                  dateTimePickerTextStyle: TextStyle(
                                      fontSize: 14, color: Colors.black))),
                          child: ValueListenableBuilder(
                            valueListenable: toDate,
                            builder: (context, endTime, child) {
                              return CupertinoDatePicker(
                                  key: UniqueKey(),
                                  use24hFormat: true,
                                  showDayOfWeek: false,
                                  initialDateTime: endTime,
                                  mode: CupertinoDatePickerMode.time,
                                  onDateTimeChanged: (date) {
                                    print("fecha: ${date.minute}");
                                    setState(() {
                                      toDate.value = DateTime(
                                        fromDate!.year,
                                        fromDate!.month,
                                        fromDate!.day,
                                        date.hour,
                                        date.minute,
                                      );
                                    });
                                  });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  void _updateEndTime(Duration duration) {
    setState(() {
      toDate!.value = fromDate!.add(duration);
    });
  }

  void validateButton() async {
    if (!formKey.currentState!.validate()) {
      flushBarGlobal(context, "Complete los campos para continuar",
          const Icon(Icons.error, color: Colors.red));
      return;
    } else {
      final agenda = CalendarModel(
          fotoReferencia: "",
          estado: 0,
          categoriaProducto:
              categorySelected != null ? categorySelected!.nombreCategoria : "",
          empresa: txtEmpresaController.text,
          gestion: gestionSelected != null ? gestionSelected!["nombre"] : "",
          idProspecto: idUser!,
          lugarReunion: txtUbicacion.text,
          medioContacto: medioSelected != null ? medioSelected!["nombre"] : "",
          nombreProspecto: txtPersonController.text,
          producto:
              productSelected != null ? productSelected!.nombreProducto : "",
          resultadoReunion: "",
          allDay: allDay ? "T" : "N",
          fechaReunion: fromDate.toString(),
          horaFin:
              toDate != null ? DateFormat("HH:mm").format(toDate.value!) : "",
          horaInicio:
              fromDate != null ? DateFormat("HH:mm").format(fromDate!) : "",
          observacion: txtObservacion.text,
          correo: txtMail.text,
          latitud: latitud,
          longitud: longitud);

      final listaMails = <CorreoModel>[];

      final res = await op.insertarAgenda(agenda);

      for (var mail in listMails) {
        listaMails.add(CorreoModel(correo: mail, idAgenda: res));
      }

      final correos = await op.insertCorreos(listaMails);

      debugPrint("correo #: $correos");

      setState(() => loading = true);
      await Future.delayed(const Duration(seconds: 1));

      if (res != 0) {
        /*flushBarGlobal(context, "Evento creado correctamente",
            const Icon(Icons.check, color: Colors.green));*/
        Platform.isAndroid
            ? andAlert.agendaAgregada(context, () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) =>
                            InfoEvento(idEvento: res, index: 2)));
              })
            : iosAlert.agendaAgregada(context, () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) =>
                            InfoEvento(idEvento: res, index: 2)));
              });
      } else {
        flushBarGlobal(context, "No se pudo crear el evento",
            const Icon(Icons.error, color: Colors.red));
      }
      setState(() => loading = false);
    }
  }

  void configurationTime() {
    if (fromDate != null) {
      DateTime newDate = fromDate!
          .add(Duration(minutes: minMax, hours: minMax == 0 ? hourMax : 0));

      debugPrint("NEW TIME: ${newDate.hour}:${newDate.minute}");

      setState(() => toDate.value = newDate);
      setState(() {});
    }
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
