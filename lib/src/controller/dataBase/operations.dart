import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kmello_app/src/controller/dataBase/db.dart';
import 'package:kmello_app/src/models/calendarEvento/calendar_model.dart';
import 'package:kmello_app/src/models/calendarEvento/categorias_agenda_model.dart';
import 'package:kmello_app/src/models/calendarEvento/documentos_model.dart';
import 'package:kmello_app/src/models/categorias_model.dart';
import 'package:kmello_app/src/models/correo_model.dart';
import 'package:kmello_app/src/models/prospectos_model.dart';
import 'package:kmello_app/src/views/inside/home/consultar/opciones/prospectos/mis_prospectos.dart';
import 'package:sqflite/sqflite.dart';

class Operations {
  final String _tblProspectos = "prospectos";
  final String _tblAgenda = "agenda";
  final String _tblCats = "categorias_agenda";
  final String _tblProds = "productos_agenda";
  final String _tblCorreo = "correos_agenda";
  final String _tblDocs = "documentos_agenda";

  final List<String> _listCats = ["Créditos", "Seguros", "Asitencias"];
  final List<String> _catsCred = [
    "Microcrédito de consumo",
    "Microcrédito productivo"
  ];

  final List<String> _catsSeg = ["Seguro Desgravamen"];
  final List<String> _catsAsis = ["Asistencia Microempresario"];

  //todo INICIALIZAR DB
  Future<Database> _initDatabase() async {
    final db = DBProvider();
    return await db.database;
  }

  //todo OPERACIONES PROSPECTOS
  Future<List<ProspectosModel>> obtenerProspectos() async {
    final Database db = await _initDatabase();

    final list =
        await db.rawQuery("SELECT * FROM $_tblProspectos WHERE cliente = 0")
            as List<Map<String, dynamic>>;

    if (list.isNotEmpty) {
      List<ProspectosModel> listProspects = [];

      for (var prospec in list) {
        listProspects.add(ProspectosModel.fromJson(prospec));
      }

      return listProspects;
    } else {
      return [];
    }
  }

  Future<List<ProspectosModel>> obtenerAllProspectos() async {
    final Database db = await _initDatabase();

    final list = await db.rawQuery("SELECT * FROM $_tblProspectos")
        as List<Map<String, dynamic>>;

    if (list.isNotEmpty) {
      List<ProspectosModel> listProspects = [];

      for (var prospec in list) {
        listProspects.add(ProspectosModel.fromJson(prospec));
      }

      return listProspects;
    } else {
      return [];
    }
  }

  Future<int> insertarProspecto(ProspectosModel prospecto) async {
    //todo 0: no insert
    //todo 1: insert
    //todo 00: exist

    final Database db = await _initDatabase();

    var validate = await obtenerProspecto(phone: prospecto.celular);

    if (validate != null) {
      return 100;
    } else {
      var res = await db.insert(_tblProspectos, prospecto.toJson());

      return res;
    }
  }

  Future<int> actualizarProspecto(
      int idProspecto, ProspectosModel prospecto) async {
    final Database db = await _initDatabase();

    var res = await db.update(_tblProspectos, prospecto.toJson(),
        where: "id_prospecto = ?", whereArgs: [idProspecto]);

    return res;
  }

  Future<ProspectosModel?> obtenerProspecto({String? phone, int? id}) async {
    final Database db = await _initDatabase();

    if (phone != null && id == null) {
      var res = await db.rawQuery(
              "SELECT * FROM $_tblProspectos WHERE celular_prospecto = '$phone'")
          as List<Map<String, dynamic>>;

      if (res.isNotEmpty) {
        return ProspectosModel.fromJson(res[0]);
      }
    } else if (id != null && phone == null) {
      var res = await db.rawQuery(
              "SELECT * FROM $_tblProspectos WHERE id_prospecto = $id")
          as List<Map<String, dynamic>>;

      if (res.isNotEmpty) {
        return ProspectosModel.fromJson(res[0]);
      }
    }

    return null;
  }

  Future<int> eliminarProspecto(int id) async {
    final Database db = await _initDatabase();

    var res = await db
        .delete(_tblProspectos, where: "id_prospecto = ?", whereArgs: [id]);

    return res;
  }

  //todo OPERACIONES AGENDA
  Future<void> insertarCategoriasYproductos() async {
    final db = await _initDatabase();

    final cats = await db.rawQuery("SELECT * FROM $_tblCats")
        as List<Map<String, dynamic>>;

    if (cats.isEmpty) {
      for (var i = 0; i < _listCats.length; i++) {
        debugPrint("nombre cat: ${_listCats[i]}");
        await db.insert(_tblCats, {"nombre_categoria": _listCats[i]});
      }

      for (var i = 0; i < _catsCred.length; i++) {
        debugPrint("nombre product; ${_catsCred[i]}");
        await db.insert(
            _tblProds, {"nombre_producto": _catsCred[i], "id_categoria": 1});
      }

      for (var i = 0; i < _catsSeg.length; i++) {
        debugPrint("nombre product; ${_catsSeg[i]}");
        await db.insert(
            _tblProds, {"nombre_producto": _catsSeg[i], "id_categoria": 2});
      }

      for (var i = 0; i < _catsSeg.length; i++) {
        debugPrint("nombre product; ${_catsAsis[i]}");
        await db.insert(
            _tblProds, {"nombre_producto": _catsAsis[i], "id_categoria": 3});
      }
    } else {
      debugPrint("YA EXISTEN CATEGORÍAS Y PRODUCTOS");
    }
  }

  Future<List<AgendaCatModel>> obtenerCategorias() async {
    final db = await _initDatabase();

    List<AgendaCatModel> categorias = [];
    final cats = await db.rawQuery("SELECT * FROM $_tblCats")
        as List<Map<String, dynamic>>;

    for (var cat in cats) {
      categorias.add(AgendaCatModel.fromJson(cat));
    }

    return categorias;
  }

  Future<List<AgendaProductModel>> obtenerProductos() async {
    final db = await _initDatabase();

    List<AgendaProductModel> productos = [];

    final prods = await db.rawQuery("SELECT * FROM $_tblProds")
        as List<Map<String, dynamic>>;

    for (var prod in prods) {
      productos.add(AgendaProductModel.fromJson(prod));
    }

    return productos;
  }

  Future<int> insertarAgenda(CalendarModel calendar) async {
    final db = await _initDatabase();

    final res = await db.insert(_tblAgenda, calendar.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return res;
  }

  Future<int> actualizarAgenda(int idAgenda, CalendarModel agenda) async {
    final db = await _initDatabase();

    var res = await db.update(_tblAgenda, agenda.toJson(),
        where: "id_agenda = ?", whereArgs: [idAgenda]);

    return res;
  }

  Future<int> actualizarResultado(int idAgenda, String resultado) async {
    final db = await _initDatabase();

    final res = await db.rawUpdate(
        'UPDATE $_tblAgenda SET resultado_reunion = ? WHERE id_agenda = ?',
        [resultado, idAgenda]);

    return res;
  }

  Future<List<CalendarModel>> obtenerDatosAgenda() async {
    final db = await _initDatabase();

    List<CalendarModel> eventos = [];

    final res = await db.rawQuery("SELECT * FROM $_tblAgenda")
        as List<Map<String, dynamic>>;

    for (var evento in res) {
      eventos.add(CalendarModel.fromJson(evento));
    }

    return eventos;
  }

  Future<CalendarModel?> obtenerAgenda(int id) async {
    final db = await _initDatabase();

    CalendarModel? calendar;

    final res =
        await db.rawQuery("SELECT * FROM $_tblAgenda WHERE id_agenda = $id")
            as List<Map<String, dynamic>>;

    calendar = CalendarModel.fromJson(res[0]);

    return calendar;
  }

  Future<int> insertarDocumentoAgenda(DocsModel doc) async {
    final db = await _initDatabase();

    final res = await db.insert(_tblDocs, doc.toJson());

    return res;
  }

  Future<int> eliminarDocumentoAgenda(int idDoc) async {
    final db = await _initDatabase();

    final res =
        await db.delete(_tblDocs, where: 'id_doc = ?', whereArgs: [idDoc]);

    return res;
  }

  Future<List<DocsModel>> obtenerDocumentosAgenda(int idAgenda) async {
    final db = await _initDatabase();

    List<DocsModel> docs = [];

    final res =
        await db.rawQuery("SELECT * FROM $_tblDocs WHERE id_agenda = $idAgenda")
            as List<Map<String, dynamic>>;

    for (var doc in res) {
      docs.add(DocsModel.fromJson(doc));
    }

    return docs;
  }

  Future<int> actualizarLlegadaAgenda(int idAgenda) async {
    final db = await _initDatabase();
    final position = await Geolocator.getCurrentPosition();
    final date = DateTime.now();

    final res = await db.rawUpdate("""UPDATE $_tblAgenda 
          SET asistio = ?, 
          latitud_llegada = ?, 
          longitud_llegada = ? 
            WHERE id_agenda = ?""",
        ["$date", position.latitude, position.longitude, idAgenda]);

    return res;
  }

  Future<int> actualizarEstadoReunion(int estado, int idAgenda) async {
    final db = await _initDatabase();
    final res = await db.rawUpdate("""UPDATE $_tblAgenda
          SET estado = ?
            WHERE id_agenda = ?""", [estado, idAgenda]);

    return res;
  }

  Future<int> actualizarFotoReunion(String foto, int idAgenda) async {
    final db = await _initDatabase();
    final res = await db.rawUpdate("""UPDATE $_tblAgenda
          SET foto_referencia = ?
            WHERE id_agenda = ?""", [foto, idAgenda]);

    return res;
  }

  //todo OPERACIONES CORREO
  Future<int> insertCorreos(List<CorreoModel> correos) async {
    final db = await _initDatabase();

    var res = 0;

    for (var i = 0; i < correos.length; i++) {
      res = await db.insert(_tblCorreo, correos[i].toJson());
    }

    return res;
  }

  Future<List<CorreoModel>> obtenerCorreosPorAgenda(int id) async {
    final db = await _initDatabase();

    List<CorreoModel> correos = [];

    final res =
        await db.rawQuery("SELECT * FROM $_tblCorreo WHERE id_agenda = $id");

    for (var correo in res) {
      correos.add(CorreoModel.fromJson(correo));
    }

    return correos;
  }

  //todo INGRESAR CLIENTES Y PROSPECTOS
  Future<void> insertClientesProspectos() async {
    final db = await _initDatabase();

    for (var i = 0; i < _listaClientes.length; i++) {
      var res = await db.insert(_tblProspectos, _listaClientes[i].toJson());
      debugPrint(
          "CLIENTE ${_listaClientes[i].nombres}: ${res != 0 ? "INSERTADO" : "NO INSERTADO"}");
    }

    for (var i = 0; i < _listaProspectos.length; i++) {
      var res = await db.insert(_tblProspectos, _listaProspectos[i].toJson());
      debugPrint(
          "CLIENTE ${_listaProspectos[i].nombres}: ${res != 0 ? "INSERTADO" : "NO INSERTADO"}");
    }
  }

  Future<List<ProspectosModel>> obtenerClientes() async {
    final Database db = await _initDatabase();

    final list =
        await db.rawQuery("SELECT * FROM $_tblProspectos WHERE cliente = 1")
            as List<Map<String, dynamic>>;

    if (list.isNotEmpty) {
      List<ProspectosModel> listProspects = [];

      for (var prospec in list) {
        listProspects.add(ProspectosModel.fromJson(prospec));
      }

      return listProspects;
    } else {
      return [];
    }
  }

  Future<void> deleteProspectos() async {
    final db = await _initDatabase();

    await db.delete(_tblProspectos);
  }

  final List<ProspectosModel> _listaClientes = [
    ProspectosModel(
        celular: "0987475632",
        direccion: "5 Herradura 2 Albotennis",
        nombres: "DANNA RAYSA BANCHON MERO",
        empresa: "NESTLÉ",
        mail: "danna.banchon@gmail.com",
        latitud: "-2.143804888",
        longitud: "-79.8906993",
        referencia: "",
        celular2: "",
        direccionTrabajo: "Vía a la Costa Km. 6.5, Av. del Bombero, Guayaquil",
        latitudTrabajo: "-2.1723154",
        longitudTrabajo: "-80.0021312",
        sector: "Alborada",
        cliente: 1),
    ProspectosModel(
        celular: "0962587458",
        direccion: "Segundo Callejon ceibos Guayaquil",
        nombres: "SERGIO JAVIER ORDOÑES ROJAS",
        empresa: "Pluproxsa S.A.",
        mail: "sergio.ordonesn@gmail.com",
        latitud: "-2.168076785",
        longitud: "-79.93858799",
        referencia: "",
        celular2: "",
        direccionTrabajo: "R3W8+RG6, Guayaquil 090610",
        latitudTrabajo: "-2.1565893",
        longitudTrabajo: "-79.9565473",
        sector: "Ceibos",
        cliente: 1),
    ProspectosModel(
        celular: "0985236547",
        direccion: "Avenida Presidente Carlos Julio Arosemena",
        nombres: "VICENTE RODRIGUEZ ZAMBRANO",
        empresa: "Repraser S.A.",
        mail: "vicente.rodriguez@gmail.com",
        latitud: "-2.168973631",
        longitud: "-79.9197834",
        referencia: "",
        celular2: "",
        direccionTrabajo: "Av. Juan Tanca Marengo, Guayaquil 090513",
        latitudTrabajo: "-2.1623343",
        longitudTrabajo: "-79.9244571",
        sector: "Mapasingue",
        cliente: 1),
    ProspectosModel(
        celular: "0963214578",
        direccion: "Carlos Cueva Tamariz, 090909, Guayaquil,",
        nombres: "MARIA FERNANDA CONFORME CONFORME",
        empresa:
            "Servicios Empresariales VEEP S.A | Empresa de Limpieza | GUAYAQUIL",
        mail: "maria.conforme@gmail.com",
        latitud: "-2.168153366",
        longitud: "-79.90643326",
        referencia: "",
        celular2: "",
        direccionTrabajo: "V439+Q6C, bahia norte, Guayaquil 090513",
        latitudTrabajo: "-2.1765824",
        longitudTrabajo: "-79.956071",
        sector: "Urdesa Central",
        cliente: 1),
    ProspectosModel(
        celular: "0942157863",
        direccion: "FRANCISCO CUEVA DIAGONAL A LA PISTA",
        nombres: "IDULFO NEPTALI CONFORME MACIAS",
        empresa: "Alsodi S.A",
        mail: "idulfo.neptali@gmail.com",
        latitud: "-2.15947145",
        longitud: "-79.8908749",
        referencia: "",
        celular2: "",
        direccionTrabajo: "Q3QR+Q87, Nicolás A. Segovia, Guayaquil 090304",
        latitudTrabajo: "-2.1786281",
        longitudTrabajo: "-79.9702143",
        sector: "Urdesa Norte",
        cliente: 1),
  ];

  final List<ProspectosModel> _listaProspectos = [
    ProspectosModel(
        celular: "09874521457",
        direccion: "Crnl Antonio de Alcedo, 090303, Guayaquil, Ecuador",
        nombres: "GEMA JAZMIN LOPEZ ARTEAGA",
        empresa: "Industrial Molinera C.A.",
        mail: "gema.lopez@gmail.com",
        latitud: "-2.195446253",
        longitud: "-79.89331985",
        referencia: "",
        celular2: "",
        direccionTrabajo: "El Oro 109, Guayaquil 090101",
        latitudTrabajo: "-2.2130598",
        longitudTrabajo: "-79.9285444",
        sector: "CENTRO URDANETA",
        cliente: 0),
    ProspectosModel(
        celular: "095247412",
        direccion:
            "Universidad de las Artes, Ciclovía Ruta 1, 090312, Guayaquil, Ecuador",
        nombres: "NATALIA DANIELA SALAZAR CAIZA",
        empresa: "TEINSERSA - Servicios Tecnicos Industriales",
        mail: "natalia.salazar@gmail.com",
        latitud: "-2.194226877",
        longitud: "-79.880617",
        referencia: "",
        celular2: "",
        direccionTrabajo: "Crnel Andrés Marín García, Guayaquil 090310",
        latitudTrabajo: "-2.172755",
        longitudTrabajo: "-79.9652625",
        sector: "MALECON",
        cliente: 0),
    ProspectosModel(
        celular: "09471254798",
        direccion: "Tercera, 090108, Guayaquil, Ecuador",
        nombres: "CLEMENCIA ALEXANDRA NUÑEZ MERA",
        empresa: "ATAGESA",
        mail: "clemencia.nunez@gmail.com",
        latitud: "-2.22674008",
        longitud: "-79.89362019",
        referencia: "",
        celular2: "",
        direccionTrabajo:
            "Mapasingue este, Calle 5ta y vía a Daule, Guayaquil 090601",
        latitudTrabajo: "-2.1557726",
        longitudTrabajo: "-80.0614182",
        sector: "SAIBA",
        cliente: 0),
    ProspectosModel(
        celular: "0952143658",
        direccion: "1 Pasaje 2 SO, 090202, Guayaquil, Ecuador",
        nombres: "IVAN ANDRES AGUILAR QUINGALAHUA",
        empresa: "Repraser S.A.",
        mail: "ivan.aguilar@gmail.com",
        latitud: "-2.231460907",
        longitud: "-79.90142992",
        referencia: "",
        celular2: "",
        direccionTrabajo: "Av. Juan Tanca Marengo, Guayaquil 090513",
        latitudTrabajo: "-2.1634693",
        longitudTrabajo: "-79.9054886",
        sector: "BARRIO DEL MAESTRO",
        cliente: 0),
    ProspectosModel(
        celular: "0902487450",
        direccion:
            "Patty Salcedo, Presidente Carlos Arroyo Del Rio, 090902, Guayaquil, Ecuador",
        nombres: "CARMEN CECILIA LANCHIMBA CHANATAXI",
        empresa: "Spartan del Ecuador Matriz",
        mail: "carmen.lanchimba@gmail.com",
        latitud: "-2.166724924",
        longitud: "-79.93929897",
        referencia: "",
        celular2: "",
        direccionTrabajo: "Guayaquil 090505",
        latitudTrabajo: "-2.1633299",
        longitudTrabajo: "-79.9066381",
        sector: "LOS CEIBOS",
        cliente: 0),
    ProspectosModel(
        celular: "0987450214",
        direccion: "Manuel E. Castillo, 090506, Guayaquil, Ecuador",
        nombres: "JHONY GONZALO JUNCAL ZUÑIGA",
        empresa: "Cámara de Industrias de Guayaquil",
        mail: "jhony.juncal@gmail.com",
        latitud: "-2.162386627",
        longitud: "-79.90003401",
        referencia: "",
        celular2: "",
        direccionTrabajo: "Av. Francisco de Orellana, Guayaquil 090512",
        latitudTrabajo: "-2.1580456",
        longitudTrabajo: "-79.9140395",
        sector: "KENNEDY NORTE",
        cliente: 0),
    ProspectosModel(
        celular: "0982365980",
        direccion: "FRANCISCO DE ORELLLANA 2515",
        nombres: "FLORISELBA DEL ROSARIO LOOR",
        empresa: "ATAGESA",
        mail: "floriselba.loor@gmail.com",
        latitud: "-2.15252533",
        longitud: "-79.89173383",
        referencia: "",
        celular2: "",
        direccionTrabajo:
            "Mapasingue este, Calle 5ta y vía a Daule, Guayaquil 090601",
        latitudTrabajo: "-2.1557726",
        longitudTrabajo: "-79.9651723",
        sector: "VERNAZA NORTE",
        cliente: 0),
    ProspectosModel(
        celular: "0952140360",
        direccion: "5to Callejón 18 NE, 090502, Guayaquil, Ecuador5",
        nombres: "MARCELO SALVADOR GARZON ALMACHI",
        empresa: "Negocios y Servicios del Ecuador S.A",
        mail: "marcelo.garzon@gmail.com",
        latitud: "-2.132335392",
        longitud: "-79.90101229",
        referencia: "",
        celular2: "",
        direccionTrabajo: "Circunvalación norte 202 y Victor Emilio Estrada",
        latitudTrabajo: "-2.1759737",
        longitudTrabajo: "-79.905091",
        sector: "ALBORADA SEXTA ETAPA",
        cliente: 0),
    ProspectosModel(
        celular: "09847541025",
        direccion: "Río Mayaicu, 090502, Guayaquil, Ecuador",
        nombres: "CELESTE TATIANA RAMOS PORTOCARRERA",
        empresa: "Celoplast S.A.",
        mail: "celeste.ramos@gmail.com",
        latitud: "-2.13482079",
        longitud: "-79.8988357",
        referencia: "",
        celular2: "",
        direccionTrabajo:
            "Av. Pdte. Carlos Julio Arosemena Tola Km. 2, Guayaquil 090615",
        latitudTrabajo: "-2.1768208",
        longitudTrabajo: "-79.9255541",
        sector: "ALBORADA CUARTA ETAPA",
        cliente: 0)
  ];
}
