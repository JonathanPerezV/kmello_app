class BankModel {
  BankModel({
    required this.idBanco,
    required this.descripcion,
    required this.estado,
  });

  final int? idBanco;
  final String? descripcion;
  final String? estado;

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      idBanco: json["id_banco"],
      descripcion: json["descripcion"],
      estado: json["estado"],
    );
  }
}
