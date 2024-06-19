import 'dart:typed_data';

class DocsModel {
  int? idDoc;
  int idAgenda;
  String nombreDoc;
  Uint8List pathDoc;

  DocsModel(
      {this.idDoc,
      required this.nombreDoc,
      required this.pathDoc,
      required this.idAgenda});

  Map<String, dynamic> toJson() =>
      {"nombre_doc": nombreDoc, "path_doc": pathDoc, "id_agenda": idAgenda};

  factory DocsModel.fromJson(Map<String, dynamic> json) => DocsModel(
      idDoc: json["id_doc"],
      idAgenda: json["id_agenda"],
      nombreDoc: json["nombre_doc"],
      pathDoc: json["path_doc"]);
}
