class CorreoModel {
  int? idCorreo;
  String correo;
  int idAgenda;

  CorreoModel({
    required this.correo,
    required this.idAgenda,
    this.idCorreo,
  });

  Map<String, dynamic> toJson() => {"id_agenda": idAgenda, "correo": correo};

  factory CorreoModel.fromJson(Map<String, dynamic> json) => CorreoModel(
      correo: json["correo"],
      idAgenda: json["id_agenda"],
      idCorreo: json["id_correo"]);
}
