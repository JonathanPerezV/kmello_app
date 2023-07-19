List<String> get categoryList => _categoryList;
List<Map<String, dynamic>> get coursesList => _coursesList;

List<String> _categoryList = [
  "Seguros",
  "Medicina Prepagada",
  "Créditos",
  "Internet",
  "Planes Exequiales",
  "Rastreo Satelital",
  "Material Extra",
];

List<Map<String, dynamic>> _coursesList = [
  {
    "title": "Créditos",
    "asset": "assets/courses/creditos.png",
    "id": 1,
  },
  {
    "title": "Internet",
    "asset": "assets/courses/internet.png",
    "id": 2,
  },
  {
    "title": "Planes Exequiales",
    "asset": "assets/courses/servicios_exequiales.png",
    "id": 3
  },
  {
    "title": "Rastreo Satelital",
    "asset": "assets/courses/rastreo_satelital.png",
    "id": 4
  },
];
