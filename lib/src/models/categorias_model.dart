class CategoriasModelo {
  int? idCompraCategoria;
  String? nombreCompraCategoria;
  String? fotoCategoria;
  List<SubCategoriaModelo>? subcategorias = [];

  CategoriasModelo({
    this.fotoCategoria,
    this.idCompraCategoria,
    this.nombreCompraCategoria,
    this.subcategorias,
  });

  factory CategoriasModelo.fromJson(Map<String, dynamic> json) {
    return CategoriasModelo(
        fotoCategoria: json["fotoCategoria"],
        idCompraCategoria: json["idCompraCategoria"],
        nombreCompraCategoria: json["nombreCompraCategoria"]);
  }
}

class SubCategoriaModelo {
  int? idCompraSubCategoria;
  String? nombreCompraSubCategoria;
  String? fotoCompraSubCategoria;
  int? idCategoria;

  SubCategoriaModelo({
    this.fotoCompraSubCategoria,
    this.idCategoria,
    this.idCompraSubCategoria,
    this.nombreCompraSubCategoria,
  });

  factory SubCategoriaModelo.fromJson(Map<String, dynamic> json) {
    return SubCategoriaModelo(
        fotoCompraSubCategoria: json["fotoCompraSubCategoria"],
        idCategoria: json["idCategoria"],
        idCompraSubCategoria: json["idCompraSubCategoria"],
        nombreCompraSubCategoria: json["nombreCompraSubCategoria"]);
  }
}
