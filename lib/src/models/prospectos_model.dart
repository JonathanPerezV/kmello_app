class ProspectosModel {
  int? idProspecto;
  String nombres;
  String direccion;
  String direccionTrabajo;
  String? referenciaTrabajo;
  String celular;
  String celular2;
  String empresa;
  String mail;
  String latitud;
  String latitudTrabajo;
  String longitud;
  String longitudTrabajo;
  String? pais;
  String? provincia;
  String? ciudad;
  String? sector;
  String referencia;
  String? fotoRefCasa;
  String? fotoRefTrabajo;
  int cliente;

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
    required this.direccionTrabajo,
    required this.latitudTrabajo,
    required this.longitudTrabajo,
    required this.cliente,
    this.fotoRefCasa,
    this.fotoRefTrabajo,
    this.referenciaTrabajo,
    this.sector,
    this.ciudad,
    this.pais,
    this.provincia,
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
        "direccion_prospecto_trabajo": direccionTrabajo,
        "latitud_prospecto_trabajo": latitudTrabajo,
        "longitud_prospecto_trabajo": longitudTrabajo,
        "cliente": cliente,
        "ciudad": ciudad ?? "Guayaquil",
        "provincia": provincia ?? "Guayas",
        "pais": pais ?? "Ecuador",
        "sector": sector ?? "",
        "foto_ref_casa": fotoRefCasa,
        "foto_ref_trabajo": fotoRefTrabajo,
        "referencia_trabajo": referenciaTrabajo ?? ""
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
          direccionTrabajo: json["direccion_prospecto_trabajo"] ?? "",
          latitudTrabajo: json["latitud_prospecto_trabajo"] ?? "",
          longitudTrabajo: json["longitud_prospecto_trabajo"] ?? "",
          ciudad: json["ciudad"] ?? "Guayaquil",
          pais: json["pais"] ?? "Ecuador",
          provincia: json["provincia"] ?? "Guayas",
          cliente: json["cliente"] ?? 1,
          referenciaTrabajo: json["referencia_trabajo"],
          fotoRefCasa: json["foto_ref_casa"],
          fotoRefTrabajo: json["foto_ref_trabajo"],
          sector: json["sector"]);
}
