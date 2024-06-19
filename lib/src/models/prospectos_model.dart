class ProspectosModel {
  int? idProspecto;
  String nombres;
  String direccion;
  String celular;
  String celular2;
  String empresa;
  String mail;
  String latitud;
  String longitud;
  String referencia;

  ProspectosModel({
    required this.celular,
    required this.direccion,
    required this.nombres,
    required this.empresa,
    required this.mail,
    required this.latitud,
    required this.longitud,
    required this.referencia,
    required this.celular2,
    this.idProspecto,
  });

  Map<String, dynamic> toJson() => {
        "celular_prospecto": celular,
        "direccion_prospecto": direccion,
        "nombres_prospecto": nombres,
        "empresa_prospecto": empresa,
        "mail_prospecto": mail,
        "latitud_prospecto": latitud,
        "longitud_prospecto": longitud,
        "referencia_prospecto": referencia,
        "celular2_prospecto": celular2,
      };

  factory ProspectosModel.fromJson(Map<String, dynamic> json) =>
      ProspectosModel(
        idProspecto: json["id_prospecto"],
        celular: json["celular_prospecto"],
        direccion: json["direccion_prospecto"] ?? "",
        nombres: json["nombres_prospecto"],
        empresa: json["empresa_prospecto"] ?? "",
        mail: json["mail_prospecto"] ?? "",
        latitud: json["latitud_prospecto"] ?? "",
        longitud: json["longitud_prospecto"] ?? "",
        referencia: json["referencia_prospecto"] ?? "",
        celular2: json["celular2_prospecto"] ?? "",
      );
}
