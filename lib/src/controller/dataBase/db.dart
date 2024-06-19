import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider.internal();

  static final DBProvider instance = DBProvider.internal();
  factory DBProvider() => instance;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  //todo VARIABLES PROSPECTOS
  static const String idProspecto = "id_prospecto";
  static const String nombres = "nombres_prospecto";
  static const String celular = "celular_prospecto";
  static const String celular2 = "celular2_prospecto";
  static const String direccion = "direccion_prospecto";
  static const String empresa = "empresa_prospecto";
  static const String mail = "mail_prospecto";
  static const String latitud = "latitud_prospecto";
  static const String longitud = "longitud_prospecto";
  static const String referencia = "referencia_prospecto";
  //todo VARIABLES AGENDA
  static const String idAgenda = "id_agenda";
  static const String categoriaProducto = "categoria_producto";
  static const String producto = "producto";
  static const String empresaAgenda = "empresa_agenda";
  static const String gestion = "gestion";
  static const String lugarReunion = "lugar_reunion";
  static const String resultadoReunion = "resultado_reunion";
  static const String allDay = "all_day";
  static const String fechaReunion = "fecha_reunion";
  static const String horaInicio = "hora_inicio";
  static const String horaFin = "hora_fin";
  static const String medioContacto = "medio_contacto";
  static const String observacion = "observacion";
  static const String latitudA = "latitud";
  static const String longitudA = "longitud";
  //todo VARIABLES CATEGORIAS - AGENDA
  static const String idCategoria = "id_categoria";
  static const String nombreCategoria = "nombre_categoria";
  //todo VARIABLES PRODUCTOS - AGENDA
  static const String idProducto = "id_producto";
  static const String nombreProducto = "nombre_producto";
  //todo VARIABLES CORREOS - AGENDA
  static const String idCorreo = "id_correo";
  static const String correo = "correo";
  //todo VARIABLES DOCUMENTOS - AGENDA
  static const String idDocumento = "id_doc";
  static const String nombreDoc = "nombre_doc";
  static const String pathDoc = "path_doc";

  static initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "abi_praxis.db");
    return await databaseConfig(path);
  }

  static Future<Database> databaseConfig(String path) async {
    return await openDatabase(path, version: 2, onOpen: (db) {},
        onCreate: (db, version) async {
      await db.execute("""
      CREATE TABLE IF NOT EXISTS prospectos(
        $idProspecto INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $nombres TEXT,
        $celular TEXT,
        $celular2 TEXT,
        $direccion TEXT,
        $empresa TEXT,
        $mail TEXT,
        $latitud TEXT,
        $longitud TEXT,
        $referencia TEXT
      )""");
      await db.execute("""
      CREATE TABLE IF NOT EXISTS agenda(
        $idAgenda INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $idProspecto INTEGER,
        $nombres TEXT,
        $categoriaProducto TEXT,
        $empresaAgenda TEXT,
        $gestion TEXT,
        $lugarReunion TEXT,
        $resultadoReunion TEXT,
        $correo TEXT,
        $allDay TEXT,
        $fechaReunion TEXT,
        $horaFin TEXT,
        $horaInicio TEXT,
        $producto TEXT,
        $observacion TEXT,
        $medioContacto TEXT,
        $latitudA TEXT,
        $longitudA TEXT
      )""");
      await db.execute("""
      CREATE TABLE IF NOT EXISTS categorias_agenda(
        $idCategoria INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $nombreCategoria TEXT
      )""");
      await db.execute("""
      CREATE TABLE IF NOT EXISTS productos_agenda(
        $idProducto INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $idCategoria INTEGER,
        $nombreProducto TEXT
      )""");
      await db.execute("""
      CREATE TABLE IF NOT EXISTS correos_agenda(
        $idCorreo INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $idAgenda INTEGER,
        $correo TEXT
      )""");
      await db.execute("""
      CREATE TABLE IF NOT EXISTS documentos_agenda(
        $idDocumento INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        $nombreDoc TEXT,
        $pathDoc BLOB,
        $idAgenda INTEGER
      )""");
    });
  }
}
