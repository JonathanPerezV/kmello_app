import '../../src/models/categorias_model.dart';

List<CategoriasModelo> listaCategorias = [
  //todo CRÉDITOS
  CategoriasModelo(
    fotoCategoria: "assets/sell/creditos/credito.jpg",
    idCompraCategoria: 1,
    nombreCompraCategoria: "Créditos",
    subcategorias: [
      SubCategoriaModelo(
        fotoCompraSubCategoria: "assets/sell/creditos/credito_hipotecario.jpg",
        idCategoria: 1,
        idCompraSubCategoria: 1,
        nombreCompraSubCategoria: "Crédito Hipotecario",
      ),
      SubCategoriaModelo(
        fotoCompraSubCategoria: "assets/sell/creditos/credito_vehiculo.jpg",
        idCategoria: 1,
        idCompraSubCategoria: 2,
        nombreCompraSubCategoria: "Crédito Vehículo",
      ),
      SubCategoriaModelo(
        fotoCompraSubCategoria: "assets/sell/creditos/microcredito.jpg",
        idCategoria: 1,
        idCompraSubCategoria: 3,
        nombreCompraSubCategoria: "Microcrédito",
      ),
    ],
  ),
  //todo HOGAR
  CategoriasModelo(
    fotoCategoria: "assets/sell/seguros/seguros.png",
    idCompraCategoria: 2,
    nombreCompraCategoria: "Seguros",
    subcategorias: [
      SubCategoriaModelo(
        fotoCompraSubCategoria:
            "assets/sell/seguros/seguro_medicina_prepagada.jpg",
        idCategoria: 2,
        idCompraSubCategoria: 8,
        nombreCompraSubCategoria: "Seguro de medicina prepagada",
      ),
      SubCategoriaModelo(
        fotoCompraSubCategoria: "assets/sell/seguros/seguro_social.jpg",
        idCategoria: 2,
        idCompraSubCategoria: 9,
        nombreCompraSubCategoria: "Seguro social",
      ),
      SubCategoriaModelo(
        fotoCompraSubCategoria: "assets/sell/seguros/seguro_vehiculos.jpg",
        idCategoria: 2,
        idCompraSubCategoria: 10,
        nombreCompraSubCategoria: "Seguro de vehículos",
      ),
    ],
  ),
];
