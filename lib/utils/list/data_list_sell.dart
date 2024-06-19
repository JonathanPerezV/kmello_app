import '../../src/models/categorias_model.dart';

List<CategoriasModelo> listaCategorias = [
  //todo CRÉDITOS
  CategoriasModelo(
    fotoCategoria: "assets/sell/creditos/credito.png",
    idCompraCategoria: 1,
    nombreCompraCategoria: "Créditos",
    subcategorias: [
      SubCategoriaModelo(
        fotoCompraSubCategoria: "assets/sell/creditos/microcredito_consumo.jpg",
        idCategoria: 1,
        idCompraSubCategoria: 1,
        nombreCompraSubCategoria: "Microcredito consumo",
      ),
      SubCategoriaModelo(
        fotoCompraSubCategoria:
            "assets/sell/creditos/microcredito_productivo.jpg",
        idCategoria: 1,
        idCompraSubCategoria: 2,
        nombreCompraSubCategoria: "Microcredito productivo",
      ),
    ],
  ),
  //todo SEEGUROS
  CategoriasModelo(
    fotoCategoria: "assets/sell/seguros/seguros.png",
    idCompraCategoria: 2,
    nombreCompraCategoria: "Seguros",
    subcategorias: [
      SubCategoriaModelo(
        fotoCompraSubCategoria: "assets/sell/seguros/seguro_desgravamen.png",
        idCategoria: 2,
        idCompraSubCategoria: 3,
        nombreCompraSubCategoria: "Seguro desgravamen",
      ),
    ],
  ),
  //todo ASISTENCIAS
  CategoriasModelo(
      fotoCategoria: "assets/sell/asistencia/asistencias.jpg",
      idCompraCategoria: 3,
      nombreCompraCategoria: "Asistencias",
      subcategorias: [
        SubCategoriaModelo(
          fotoCompraSubCategoria:
              "assets/sell/asistencia/asistencia_microempresario.png",
          idCategoria: 3,
          idCompraSubCategoria: 4,
          nombreCompraSubCategoria: "Asistencia microempresario",
        ),
      ])
];
