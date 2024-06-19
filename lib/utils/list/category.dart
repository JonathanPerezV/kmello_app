import 'package:flutter/material.dart';
import 'package:kmello_app/utils/icons/kmello_icons_icons.dart';

List<Map<String, dynamic>> get categoryList => _categoryList;
List<Map<String, dynamic>> get sponsorsList => _sponsorsList;
List<Map<String, dynamic>> get subcategorylist => _subcategorylist;

List<Map<String, dynamic>> _categoryList = [
  /*{
    "name": "Seguros",
    "icon": const Icon(KmelloIcons.seguros),
    "id": 1,
  },*/
  {
    "name": "Servicios financieros",
    "icon": const Icon(KmelloIcons.creditos),
    "id": 2,
  },
  {
    "name": "Seguros",
    "icon": const Icon(KmelloIcons.credito_corporativo),
    "id": 3
  },
  {
    "name": "Asistencia",
    "icon": const Icon(KmelloIcons.planes_exequiales),
    "id": 4
  },
  /*{
    "name": "Suscripciones",
    "icon": const Icon(KmelloIcons.suscripciones),
    "id": 5
  },*/
];

List<Map<String, dynamic>> _subcategorylist = [
  /*{
    "id_category": 1,
    "id_sub_category": 1,
    "name": "Seguros de Vehículo",
    "icon": const Icon(KmelloIcons.seguro_vehiculo),
  },
  {
    "id_category": 1,
    "id_sub_category": 2,
    "name": "Medicina Prepagada",
    "icon": const Icon(KmelloIcons.medicina_prepagada),
  },*/
  /*{
    "id_category": 2,
    "id_sub_category": 3,
    "name": "Microcrédito",
    "icon": const Icon(KmelloIcons.creditos)
  },*/
  {
    "id_category": 2,
    "id_sub_category": 4,
    "name": "Microcrédito",
    "icon": const Icon(KmelloIcons.creditos)
  },
  {
    "id_category": 2,
    "id_sub_category": 5,
    "name": "Tarjeta de débito",
    "icon": const Icon(KmelloIcons.creditos)
  },
  {
    "id_category": 2,
    "id_sub_category": 6,
    "name": "Tarjeta de crédito",
    "icon": const Icon(KmelloIcons.creditos)
  },
  {
    "id_category": 2,
    "id_sub_category": 7,
    "name": "Cuenta corriente",
    "icon": const Icon(KmelloIcons.creditos)
  },
  {
    "id_category": 3,
    "id_sub_category": 8,
    "name": "Desgravamen",
    "icon": const Icon(KmelloIcons.seguros)
  },
  {
    "id_category": 4,
    "id_sub_category": 9,
    "name": "Microempresario",
    "icon": const Icon(KmelloIcons.planes_exequiales)
  }
];

List<Map<String, dynamic>> _sponsorsList = [
  {
    "id_sub_category": 4,
    "name": "Consumo",
    "asset": "assets/courses/creditos.png",
    "id_sponsor": 1,
    "color": Colors.orange,
    "complete": true,
    "progress": 100,
  },
  {
    "id_sub_category": 4,
    "name": "Productivo",
    "asset": "assets/courses/creditos.png",
    "id_sponsor": 2,
    "color": Colors.pink,
    "complete": true,
    "progress": 100,
  },
  {
    "id_sub_category": 5,
    "name": "PDF Débito",
    "asset": "assets/courses/creditos.png",
    "id_sponsor": 3,
    "color": Colors.yellow,
    "complete": false,
    "progress": 0,
  },
  {
    "id_sub_category": 6,
    "name": "PDF Crédito",
    "asset": "assets/courses/creditos.png",
    "id_sponsor": 4,
    "color": Colors.brown,
    "complete": true,
    "progress": 100,
  },
  {
    "id_sub_category": 7,
    "name": "PDF Cuenta corriente",
    "asset": "assets/courses/creditos.png",
    "id_sponsor": 5,
    "color": Colors.purple,
    "complete": false,
    "progress": 0,
  },
  {
    "id_sub_category": 8,
    "name": "PDF Desgravamen",
    "asset": "assets/courses/creditos.png",
    "id_sponsor": 6,
    "color": Colors.red,
    "complete": false,
    "progress": 0,
  },
  {
    "id_sub_category": 9,
    "name": "PDF Microempresario",
    "asset": "assets/courses/creditos.png",
    "id_sponsor": 6,
    "color": Colors.red,
    "complete": false,
    "progress": 0,
  }
];
