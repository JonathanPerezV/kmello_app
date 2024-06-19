class AgendaCatModel {
  int? idCategoria;
  String nombreCategoria;

  AgendaCatModel({required this.nombreCategoria, this.idCategoria});

  factory AgendaCatModel.fromJson(Map<String, dynamic> json) => AgendaCatModel(
        idCategoria: json["id_categoria"],
        nombreCategoria: json["nombre_categoria"],
      );
}

class AgendaProductModel {
  int? idProducto;
  int idCategoria;
  String nombreProducto;

  AgendaProductModel(
      {required this.idCategoria,
      required this.nombreProducto,
      this.idProducto});

  factory AgendaProductModel.fromJson(Map<String, dynamic> json) =>
      AgendaProductModel(
        idProducto: json["id_producto"],
        idCategoria: json["id_categoria"],
        nombreProducto: json["nombre_producto"],
      );
}
