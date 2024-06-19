class CalendarModel {
  int? idAgenda;
  int idProspecto;
  String nombreProspecto;
  String fechaReunion;
  String horaInicio;
  String horaFin;
  String empresa;
  String categoriaProducto;
  String producto;
  String medioContacto;
  String gestion;
  String lugarReunion;
  String resultadoReunion;
  String allDay;
  String observacion;
  String latitud;
  String longitud;
  String correo;

  CalendarModel(
      {this.idAgenda,
      required this.categoriaProducto,
      required this.empresa,
      required this.gestion,
      required this.idProspecto,
      required this.lugarReunion,
      required this.medioContacto,
      required this.nombreProspecto,
      required this.producto,
      required this.resultadoReunion,
      required this.allDay,
      required this.fechaReunion,
      required this.horaFin,
      required this.horaInicio,
      required this.observacion,
      required this.latitud,
      required this.longitud,
      required this.correo});

  Map<String, dynamic> toJson() => {
        "id_prospecto": idProspecto,
        "nombres_prospecto": nombreProspecto,
        "empresa_agenda": empresa,
        "categoria_producto": categoriaProducto,
        "producto": producto,
        "medio_contacto": medioContacto,
        "gestion": gestion,
        "lugar_reunion": lugarReunion,
        "resultado_reunion": resultadoReunion,
        "all_day": allDay,
        "fecha_reunion": fechaReunion,
        "hora_inicio": horaInicio,
        "hora_fin": horaFin,
        "observacion": observacion,
        "latitud": latitud,
        "longitud": longitud,
        "correo": correo,
      };

  factory CalendarModel.fromJson(Map<String, dynamic> json) => CalendarModel(
      idAgenda: json["id_agenda"],
      categoriaProducto: json["categoria_producto"],
      empresa: json["empresa_agenda"],
      gestion: json["gestion"],
      idProspecto: json["id_prospecto"],
      lugarReunion: json["lugar_reunion"],
      medioContacto: json["medio_contacto"],
      nombreProspecto: json["nombres_prospecto"],
      producto: json["producto"],
      resultadoReunion: json["resultado_reunion"],
      allDay: json["all_day"],
      fechaReunion: json["fecha_reunion"],
      horaFin: json["hora_fin"],
      horaInicio: json["hora_inicio"],
      observacion: json["observacion"],
      latitud: json["latitud"],
      longitud: json["longitud"],
      correo: json["correo"]);
}
