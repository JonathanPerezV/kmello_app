import 'package:flutter/material.dart';
import 'package:kmello_app/utils/icons/kmello_icons_icons.dart';

List<Map<String, dynamic>> get categoryList => _categoryList;
List<Map<String, dynamic>> get sponsorsList => _sponsorsList;
List<Map<String, dynamic>> get subcategorylist => _subcategorylist;

List<Map<String, dynamic>> _categoryList = [
  {
    "name": "Seguros",
    "icon": const Icon(KmelloIcons.seguros),
    "id": 1,
  },
  {
    "name": "Créditos",
    "icon": const Icon(KmelloIcons.creditos),
    "id": 2,
  },
  {
    "name": "Créditos Médico Corporativo",
    "icon": const Icon(KmelloIcons.credito_corporativo),
    "id": 3
  },
  {
    "name": "Planes Exequiales",
    "icon": const Icon(KmelloIcons.planes_exequiales),
    "id": 4
  },
  {
    "name": "Suscripciones",
    "icon": const Icon(KmelloIcons.suscripciones),
    "id": 5
  },
];

List<Map<String, dynamic>> _subcategorylist = [
  {
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
  },
  {
    "id_category": 2,
    "id_sub_category": 3,
    "name": "Microcrédito",
    "icon": const Icon(KmelloIcons.creditos)
  },
  {
    "id_category": 2,
    "id_sub_category": 4,
    "name": "Crédito Hipotecario",
    "icon": const Icon(KmelloIcons.credito_hipotecario)
  },
  {
    "id_category": 2,
    "id_sub_category": 5,
    "name": "Crédito de Vehículo",
    "icon": const Icon(KmelloIcons.credito_vehiculo)
  }
];

List<Map<String, dynamic>> _sponsorsList = [
  {
    "id_sub_category": 1,
    "name": "Sponsor seguros 1",
    "asset": "assets/courses/creditos.png",
    "id_sponsor": 1,
    "color": Colors.orange
  },
  {
    "id_sub_category": 1,
    "name": "Sponsor seguros 2",
    "asset": "assets/courses/creditos.png",
    "id_sponsor": 2,
    "color": Colors.pink
  },
  {
    "id_sub_category": 1,
    "name": "Sponsor seguros 3",
    "asset": "assets/courses/creditos.png",
    "id_sponsor": 3,
    "color": Colors.yellow
  },
  {
    "id_sub_category": 1,
    "name": "Sponsor seguros 4",
    "asset": "assets/courses/creditos.png",
    "id_sponsor": 4,
    "color": Colors.brown
  },
  {
    "id_sub_category": 3,
    "name": "Sponsor microcrédito 1",
    "asset": "assets/courses/creditos.png",
    "id_sponsor": 5,
    "color": Colors.purple
  },
  {
    "id_sub_category": 3,
    "name": "Sponsor microcrédito 2",
    "asset": "assets/courses/creditos.png",
    "id_sponsor": 6,
    "color": Colors.red
  }
];
