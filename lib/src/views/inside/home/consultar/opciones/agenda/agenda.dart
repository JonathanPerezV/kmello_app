import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kmello_app/main.dart';
import 'package:kmello_app/src/controller/dataBase/operations.dart';
import 'package:kmello_app/src/views/inside/home/consultar/opciones/agenda/agregar_calendario.dart';
import 'package:kmello_app/src/views/inside/home/consultar/opciones/agenda/tabs/info_evento.dart';
import 'package:kmello_app/src/views/inside/lateralMenu/drawer_menu.dart';
import 'package:kmello_app/utils/alerts/and_alert.dart';
import 'package:kmello_app/utils/alerts/ios_alert.dart';
import 'package:kmello_app/utils/app_bar.dart';
import 'package:kmello_app/utils/deviders/divider.dart';
import 'package:kmello_app/utils/flushbar.dart';
import 'package:kmello_app/utils/header.dart';
import 'package:kmello_app/utils/icons/kmello_icons_icons.dart';
import 'package:kmello_app/utils/loading.dart';
import 'package:kmello_app/utils/selectFile/select_file.dart';
import 'package:mobkit_calendar/mobkit_calendar.dart';
import 'package:simple_tooltip/simple_tooltip.dart';

class Agenda extends StatefulWidget {
  const Agenda({super.key});

  @override
  State<Agenda> createState() => _MyAppState();
}

class _MyAppState extends State<Agenda> {
  final sckey = GlobalKey<ScaffoldState>();

  bool dayCalendar = false;
  bool weekCalendar = true;
  bool monthCalendar = false;

  bool loading = false;
  final ScrollController _scrollController = ScrollController();
  DateTime tiempoActualCalendario = DateTime.now();

  final file = SeleccionArchivos();

  MobkitCalendarConfigModel getConfig(
      MobkitCalendarViewType mobkitCalendarViewType) {
    return MobkitCalendarConfigModel(
      weeklyTopWidgetSize:
          mobkitCalendarViewType == MobkitCalendarViewType.weekly ? 55 : null,
      borderRadius: mobkitCalendarViewType == MobkitCalendarViewType.weekly
          ? BorderRadius.circular(100)
          : const BorderRadius.all(Radius.circular(10)),
      cellConfig: CalendarCellConfigModel(
        eventLineHeight: 500,
        disabledStyle: CalendarCellStyle(
          textStyle:
              TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.5)),
          color: Colors.transparent,
        ),
        enabledStyle: CalendarCellStyle(
          textStyle: const TextStyle(fontSize: 16, color: Colors.black),
          border: Border.all(color: Colors.black.withOpacity(0.2), width: 0),
        ),
        selectedStyle: CalendarCellStyle(
          color: const Color.fromRGBO(82, 123, 189, 1),
          textStyle: const TextStyle(fontSize: 17, color: Colors.white),
          border: Border.all(color: Colors.black, width: 0),
        ),
        currentStyle: CalendarCellStyle(
          border: const Border(
              bottom: BorderSide(color: Colors.blue),
              left: BorderSide(color: Colors.blue),
              right: BorderSide(color: Colors.blue),
              top: BorderSide(color: Colors.blue)),
          textStyle: const TextStyle(color: Colors.lightBlue),
        ),
      ),
      calendarPopupConfigModel: CalendarPopupConfigModel(
        popUpBoxDecoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(25))),
        popUpOpacity: true,
        animateDuration: 200,
        verticalPadding: 30,
        popupSpace: 20,
        popupHeight: MediaQuery.of(context).size.height * 0.6,
        popupWidth: MediaQuery.of(context).size.width,
        viewportFraction: 0.9,
      ),
      topBarConfig: CalendarTopBarConfigModel(
        isVisibleHeaderWidget:
            mobkitCalendarViewType == MobkitCalendarViewType.monthly ||
                mobkitCalendarViewType == MobkitCalendarViewType.agenda,
        isVisibleTitleWidget: true,
        isVisibleMonthBar: false,
        isVisibleYearBar: false,
        isVisibleWeekDaysBar: true,
        weekDaysStyle: const TextStyle(fontSize: 17, color: Colors.black),
      ),
      weekDaysBarBorderColor: Colors.transparent,
      locale: "es",
      disableOffDays: true,
      disableWeekendsDays: false,
      monthBetweenPadding: 20,
      primaryColor: Colors.lightBlue,
      showEventLineMaxCountText: false,
      showEventPointMaxCountText: false,
      popupEnable: mobkitCalendarViewType == MobkitCalendarViewType.monthly
          ? true
          : false,
    );
  }

  @override
  void initState() {
    getEvents();
    super.initState();
  }

  List<MobkitCalendarAppointmentModel> eventList = [];

  void getEvents() async {
    setState(() {
      eventList.clear();
    });
    final db = Operations();

    final res = await db.obtenerDatosAgenda();

    if (res.isNotEmpty) {
      for (var evento in res) {
        var date = DateTime.parse(evento.fechaReunion);
        var firstTime = evento.horaInicio.split(":");
        var lastTime = evento.horaFin.split(":");

        setState(() {
          eventList.add(MobkitCalendarAppointmentModel(
              nativeEventId: evento.idAgenda.toString(),
              title: evento.nombreProspecto,
              color: /*evento.estado != 0
                  ? Colors.red
                  :*/
                  const Color.fromRGBO(82, 123, 189, 1),
              appointmentStartDate: DateTime(date.year, date.month, date.day,
                  int.parse(firstTime[0]), int.parse(firstTime[1])),
              appointmentEndDate: DateTime(date.year, date.month, date.day,
                  int.parse(lastTime[0]), int.parse(lastTime[1])),
              isAllDay: evento.allDay == "T" ? true : false,
              detail: "${evento.categoriaProducto} | ${evento.producto}",
              recurrenceModel: null));

          eventList.sort(
              (a, b) => a.appointmentStartDate.compareTo(b.appointmentEndDate));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        key: sckey,
        appBar: MyAppBar(key: sckey).myAppBar(),
        drawer: drawerMenu(context, inicio: false),
        floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          backgroundColor: Colors.black,
          onPressed: () async => await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => EventEditingPage(
                        eventList: eventList,
                      ))).then((_) => getEvents()),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: options());
  }

  Widget options() => Column(
        children: [
          header("Agenda", KmelloIcons.agenda, context: context),
          Expanded(
            child: loading
                ? loadingWidget(text: "Consultando...")
                : weekCalendar
                    ? weekCalendarWidget()
                    : monthCalendarWidget(),
          )
        ],
      );

  Widget weekCalendarWidget() => MobkitCalendarWidget(
        minDate: DateTime(2020),
        key: UniqueKey(),
        config: getConfig(MobkitCalendarViewType.weekly),
        dateRangeChanged: (datetime) => null,
        weeklyViewWidget:
            (Map<DateTime, List<MobkitCalendarAppointmentModel>> val) =>
                Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: val.length,
            itemBuilder: (BuildContext context, int index) {
              DateTime dateTime = val.keys.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(100)),
                            child: Center(
                              child: Text(
                                dateTime.day.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Text(
                            " de ${DateFormat("MMMM", "es").format(dateTime)}",
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "${DateFormat("EEEE", "es").format(dateTime)} ",
                            style: const TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      val[dateTime]!.isNotEmpty
                          ? SizedBox(
                              height: val[dateTime]!.length * 80,
                              child: ListView.builder(
                                itemCount: val[dateTime]!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return FutureBuilder(
                                      future: validarLlegada(int.parse(
                                          val[dateTime]![index]
                                              .nativeEventId!)),
                                      builder: (context, snapshot) {
                                        bool foto = false;
                                        bool cancelado = false;
                                        Color color = Colors.grey;
                                        Color colorBorder =
                                            Colors.grey.shade200;
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          color = Colors.grey;
                                          colorBorder = Colors.grey.shade200;
                                        } else if (snapshot.hasError) {
                                          color = Colors.grey;
                                          colorBorder = Colors.grey.shade200;
                                        } else if (!snapshot.hasData) {
                                          color = Colors.grey;
                                          colorBorder = Colors.grey.shade200;
                                        } else if (snapshot.hasData &&
                                            snapshot.data!["llegada"] == 1) {
                                          color = Colors.green;
                                          colorBorder = Colors.green.shade200;
                                        }
                                        if (snapshot.data!["estado"] == 0) {
                                          cancelado = false;
                                        } else {
                                          cancelado = true;
                                        }

                                        if (snapshot.data!["foto"] == "") {
                                          foto = false;
                                        } else {
                                          foto = true;
                                        }

                                        return Slidable(
                                          //direction: Axis.horizontal,
                                          enabled: snapshot.data!["estado"] == 0
                                              ? true
                                              : false,
                                          key: UniqueKey(),
                                          endActionPane: ActionPane(
                                            motion: const BehindMotion(),
                                            children: [
                                              //const SizedBox(width: 3),
                                              /*Container(
                                                width: 80,
                                                height: 80,
                                                child: 
                                                    Tooltip(
                                                      message: "Tomar foto",
                                                      child:*/

                                              SlidableAction(
                                                //flex: 2,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                backgroundColor: Colors.blue,
                                                onPressed: foto
                                                    ? null
                                                    : (_) => takePhoto(int
                                                        .parse(val[dateTime]![
                                                                index]
                                                            .nativeEventId!)),
                                                icon: foto
                                                    ? Icons.check_circle_rounded
                                                    : Icons.camera_alt,

                                                padding: EdgeInsets.zero,
                                                label: foto
                                                    ? "Foto Cargada"
                                                    : "Subir Foto",
                                                foregroundColor: Colors.white,
                                              ),

                                              /*),
                                                    
                                                      )
                                                  ],
                                                ),*/
                                              /*),
                                              const SizedBox(width: 3),
                                              Container(
                                                width: 80,
                                                height: 80,
                                                child: Tooltip(
                                                  message: "Cancelar evento",
                                                  child:*/
                                              SlidableAction(
                                                //flex: 2,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                backgroundColor: Colors.red,
                                                onPressed: (_) => Platform
                                                        .isAndroid
                                                    ? cancelarReunionAnd(int
                                                        .parse(val[dateTime]![
                                                                index]
                                                            .nativeEventId!))
                                                    : cancelarReunionIos(int
                                                        .parse(val[dateTime]![
                                                                index]
                                                            .nativeEventId!)),

                                                icon: Icons.delete,
                                                padding: EdgeInsets.zero,
                                                label: "Cancelar",
                                                foregroundColor: Colors.white,
                                              ),
                                              /*),
                                              ),
                                              const SizedBox(width: 3),*/
                                            ],
                                          ),
                                          child: GestureDetector(
                                            onTap: () => onTapEvent(
                                                val[dateTime]![index]),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  width: double.infinity,
                                                  height: 75,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: getColor(
                                                        val[dateTime]![index]),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              child: Text(
                                                                "${val[dateTime]![index].title!}\n${DateFormat("HH:mm").format(val[dateTime]![index].appointmentStartDate)} - ${DateFormat("HH:mm").format(val[dateTime]![index].appointmentEndDate)}",
                                                                style: TextStyle(
                                                                    decoration: cancelado
                                                                        ? TextDecoration
                                                                            .lineThrough
                                                                        : null,
                                                                    decorationColor: cancelado
                                                                        ? Colors
                                                                            .black
                                                                        : null,
                                                                    decorationStyle: cancelado
                                                                        ? TextDecorationStyle
                                                                            .solid
                                                                        : null,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              child: Text(
                                                                val[dateTime]![
                                                                        index]
                                                                    .detail,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    decoration: cancelado
                                                                        ? TextDecoration
                                                                            .lineThrough
                                                                        : null,
                                                                    decorationColor: cancelado
                                                                        ? Colors
                                                                            .black
                                                                        : null,
                                                                    decorationStyle: cancelado
                                                                        ? TextDecorationStyle
                                                                            .solid
                                                                        : null,
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        17),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      if (snapshot.data![
                                                              "estado"] ==
                                                          0)
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 10),
                                                          decoration: BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    blurRadius:
                                                                        4,
                                                                    spreadRadius:
                                                                        2,
                                                                    color:
                                                                        colorBorder)
                                                              ],
                                                              color: color,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100)),
                                                          child: IconButton(
                                                              onPressed:
                                                                  () async {
                                                                Platform.isAndroid
                                                                    ? agendaLlegadaAnd(int.parse(
                                                                        val[dateTime]![index]
                                                                            .nativeEventId!))
                                                                    : agendaLlegadaIos(
                                                                        int.parse(
                                                                            val[dateTime]![index].nativeEventId!));
                                                              },
                                                              icon: const Icon(
                                                                Icons.flag,
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                              ),
                            )
                          : Container(
                              child: const Text("Sin eventos"),
                            ),
                    ]),
              );

              // : Container();
            },
          ),
        ),
        titleWidget:
            (List<MobkitCalendarAppointmentModel> models, DateTime datetime) =>
                Column(
          children: [
            titleWidget(
              datetime: datetime,
            ),
            //selectMonth(dateTime: datetime),
            const SizedBox(height: 10)
          ],
        ),
        onSelectionChange:
            (List<MobkitCalendarAppointmentModel> models, DateTime date) {
          if (date.isBefore(DateTime.now()) &&
              !date.isSameDay(DateTime.now())) {
            flushBarGlobal(
                context,
                "No puede agendar reuniones en fechas anteriores.",
                const Icon(Icons.error, color: Colors.red));
          } else {
            /*Platform.isAndroid
                ? andAlert.alertaAgregarEvento(context, date, () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => EventEditingPage(
                                  startDate: date,
                                  eventList: eventList,
                                )));
                  })
                : iosAlert.alertaAgregarEvento(context, date, () {
                    Navigator.pop(context);*/
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => EventEditingPage(
                          startDate: date,
                          eventList: eventList,
                        )));
            //});
          }
        },
        eventTap: (event) => onTapEvent(event),
        onDateChanged: (DateTime datetime) {
          setState(() => tiempoActualCalendario = datetime);
        },
        mobkitCalendarController: MobkitCalendarController(
            viewType: MobkitCalendarViewType.weekly,
            appointmentList: eventList,
            calendarDateTime: tiempoActualCalendario,
            selectedDateTime: tiempoActualCalendario),
      );

  Color getColor(MobkitCalendarAppointmentModel val) {
    //todo SI EL DÍA ES DIFERENTE AL ACTUAL Y ES MENOR QUE SE PONGA GRIS CASO CONTRARIO MANTENER AZUL
    //todo SI LA HORA ES MENOR A LA HORA ACTUAL Y ESTAMOS EN EL MISMO DÍA O DÍAS ANTERIORES ENTONCES QUE SEA GRIS

    if (DateTime.now().day == val.appointmentStartDate.day) {
      if (DateTime.now().isAfter(val.appointmentEndDate) ||
          (DateTime.now().hour > val.appointmentEndDate.hour)) {
        return Colors.grey;
      } else if (DateTime.now().isBefore(val.appointmentEndDate) &&
          DateTime.now().isAfter(val.appointmentStartDate)) {
        return val.color!;
      } else {
        return val.color!;
      }
    } else {
      return val.color!;
    }

    // if ((val.appointmentStartDate.hour < DateTime.now().hour &&
    //         (val.appointmentStartDate.day != DateTime.now().day &&
    //             val.appointmentStartDate.isBefore(DateTime.now()))) &&
    //     (val.appointmentEndDate.hour < DateTime.now().hour ||
    //         (val.appointmentStartDate.day != DateTime.now().day &&
    //             val.appointmentStartDate.isBefore(DateTime.now())))) {
    //   return Colors.grey;
    // } else {
    //   return val.color!;
    // }
  }

  Widget monthCalendarWidget() => MobkitCalendarWidget(
        minDate: DateTime(2020),
        key: UniqueKey(),
        config: getConfig(MobkitCalendarViewType.monthly),
        dateRangeChanged: (datetime) => null,
        onSelectionChange:
            (List<MobkitCalendarAppointmentModel> models, DateTime date) =>
                null,
        eventTap: (event) => onTapEvent(event),
        titleWidget: (models, datetime) => Column(
          children: [
            titleWidget(
              datetime: datetime,
            ),
            //selectMonth(dateTime: datetime),
            const SizedBox(height: 10)
          ],
        ),
        onPopupWidget:
            (List<MobkitCalendarAppointmentModel> models, DateTime datetime) =>
                onPopupWidget(
          datetime: datetime,
          models: models,
        ),
        onDateChanged: (DateTime datetime) {
          setState(() => tiempoActualCalendario = datetime);
        },
        mobkitCalendarController: MobkitCalendarController(
          calendarDateTime: tiempoActualCalendario,
          selectedDateTime: tiempoActualCalendario,
          viewType: MobkitCalendarViewType.monthly,
          appointmentList: eventList,
        ),
      );

  Widget titleWidget({
    required DateTime datetime,
  }) =>
      Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Row(
          children: [
            Text(
              DateFormat("MMMM yyyy", "es").format(datetime),
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: divider(false)),
            PopupMenuButton(
                icon: const Icon(Icons.more_vert_rounded),
                itemBuilder: (itemBuilder) {
                  List<PopupMenuEntry> list = [];
                  /*list.add(PopupMenuItem(
                    child: Text("Día"),
                    onTap: () {
                      setState(() {
                        dayCalendar = true;
                        weekCalendar = false;
                        monthCalendar = false;
                      });
                    },
                  ));*/
                  list.add(PopupMenuItem(
                    child: const Text("Semana"),
                    onTap: () {
                      setState(() {
                        dayCalendar = false;
                        weekCalendar = true;
                        monthCalendar = false;
                      });
                    },
                  ));
                  list.add(PopupMenuItem(
                    child: const Text("Mes"),
                    onTap: () {
                      setState(() {
                        dayCalendar = false;
                        weekCalendar = false;
                        monthCalendar = true;
                      });
                    },
                  ));
                  return list;
                })
          ],
        ),
      );

  Widget onPopupWidget(
      {required List<MobkitCalendarAppointmentModel> models,
      required DateTime datetime}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 18),
      child: models.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    DateFormat("EEE, MMMM d", "es").format(datetime),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: models.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          onTapEvent(models[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 1, vertical: 5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 50,
                                  color: models[index].color,
                                  width: 2,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Text(
                                        "${models[index].title!} (${DateFormat("HH:mm").format(models[index].appointmentStartDate)} - ${DateFormat("HH:mm").format(models[index].appointmentEndDate)})",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Text(
                                        models[index].detail,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    DateFormat("EEE, MMMM d").format(datetime),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
              ],
            ),
    );
  }

  ///
  ///0: NO HA LLEGADO
  ///1: LLEGÓ
  ///
  Future<Map<String, dynamic>> validarLlegada(int idAgenda) async {
    final data = (await op.obtenerAgenda(idAgenda));

    if (data != null) {
      if (data.asistio != "") {
        return {
          "llegada": 1,
          "estado": data.estado,
          "foto": data.fotoReferencia
        };
      } else {
        return {
          "llegada": 0,
          "estado": data.estado,
          "foto": data.fotoReferencia
        };
      }
    } else {
      return {};
    }
  }

  void onTapEvent(MobkitCalendarAppointmentModel event) async {
    await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) =>
                    InfoEvento(idEvento: int.parse(event.nativeEventId!))))
        .then((_) => getEvents());
  }

  Future<void> takePhoto(int idAgenda) async {
    final currentPosition = _scrollController.position.pixels;
    setState(() => loading = true);
    final res = await file.selectOrCaptureImage(ImageSource.camera, context);

    if (res != null) {
      debugPrint("resultado: $res");

      final bytes = await File(res).readAsBytes();

      final up = await op.actualizarFotoReunion(bytes.toString(), idAgenda);

      if (up == 1) {
        getEvents();
        setState(() {
          _scrollController.animateTo(currentPosition,
              duration: const Duration(milliseconds: 500),
              curve: Curves.linear);
        });
        flushBarGlobal(context, "Foto cargada",
            const Icon(Icons.check, color: Colors.green));
      } else {
        flushBarGlobal(context, "No se pudo cargar la foto",
            const Icon(Icons.check, color: Colors.red));
      }
    }
    setState(() => loading = false);
  }

  void agendaLlegadaAnd(int idAgenda) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: const Text("Reunión"),
            content: const Text(
                "Al pulsar en 'Llegué' usted confirmará que acabó de llegar al lugar de reunión."),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar")),
              TextButton(
                  onPressed: () => actualizarLLegada(idAgenda),
                  child: const Text("Llegué")),
            ],
          );
        });
  }

  void agendaLlegadaIos(int idAgenda) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: const Text("Reunión"),
            content: const Text(
                "Al pulsar en 'Llegué' usted confirmará que acabó de llegar al lugar de reunión."),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar")),
              TextButton(
                  onPressed: () => actualizarLLegada(idAgenda),
                  child: const Text("Llegué")),
            ],
          );
        });
  }

  void cancelarReunionIos(int idAgenda) async {
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
                    final cscroll = _scrollController.position;
                    setState(() => loading = true);
                    final res = await op.actualizarEstadoReunion(1, idAgenda);

                    if (res == 1) {
                      getEvents();
                      _scrollController.animateTo(cscroll.pixels,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.linear);
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

  void cancelarReunionAnd(int idAgenda) async {
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
                    final cscroll = _scrollController.position;
                    setState(() => loading = true);
                    final res = await op.actualizarEstadoReunion(1, idAgenda);

                    if (res == 1) {
                      getEvents();
                      _scrollController.animateTo(cscroll.pixels,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.linear);
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

  Future<void> actualizarLLegada(int idAgenda) async {
    Navigator.pop(context);

    double currentScrollPosition = _scrollController.position.pixels;

    setState(() => loading = true);
    final res = await op.actualizarLlegadaAgenda(idAgenda);

    if (res == 1) {
      flushBarGlobal(context, "Hora y lugar guardados correctamente",
          const Icon(Icons.check, color: Colors.green));
    } else {
      flushBarGlobal(context, "Ocurrió un error",
          const Icon(Icons.error, color: Colors.red));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(currentScrollPosition,
          duration: const Duration(milliseconds: 500),
          curve: Curves.decelerate);
    });
    setState(() => loading = false);
  }
}
