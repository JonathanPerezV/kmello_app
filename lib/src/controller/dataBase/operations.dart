import 'package:flutter/material.dart';
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
}
