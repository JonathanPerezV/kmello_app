///Lista de solicitudes ingresadas por parte del usuario(versión prueba)
///
///estado:
///```dart
///estado: 0 //Rechazado
///estado: 1 //Aprobado
///estado: 2 //En revisión
///estado: 3 //Con novedad
///```
// ignore_for_file: non_constant_identifier_names

List<Map<String, dynamic>> solicitudes_ingresadas = [
  {
    "id": 1,
    "fecha_solicitud": "2023-12-01",
    "establecimiento": "Red consulta med",
    "informacion": "Créditos médico corporativo",
    "estado": 2,
    "valor": 120,
    "usuario_solicitud": "Jose Martinez Delgado",
    "numero_transaccion": "00000000001",
    "detalles":
        "asduahsduaskhdjsdbgasjkdgasdjasbdhajksdasvdjgsdvkdjahsdknasdkjs",
    "comision": 30
  },
  {
    "id": 2,
    "fecha_solicitud": "2023-11-28",
    "establecimiento": "App Seguros",
    "informacion": "Seguro de Vehículo",
    "estado": 3,
    "valor": 600,
    "usuario_solicitud": "Jose Urrutia Campoverde",
    "numero_transaccion": "00000000002",
    "detalles":
        "asduahsduaskhdjsdbgasjkdgasdjasbdhajksdasvdjgsdvkdjahsdknasdkjs",
    "comision": 120
  },
  {
    "id": 3,
    "fecha_solicitud": "2023-11-20",
    "establecimiento": "Sponsor",
    "informacion": "Plan Exequial",
    "estado": 2,
    "valor": 370,
    "usuario_solicitud": "Jaime Ayoví",
    "numero_transaccion": "00000000003",
    "detalles":
        "asduahsduaskhdjsdbgasjkdgasdjasbdhajksdasvdjgsdvkdjahsdknasdkjs",
    "comision": 45
  },
  {
    "id": 4,
    "fecha_solicitud": "2023-11-14",
    "establecimiento": "Sponsor",
    "informacion": "Suscripción BSC",
    "estado": 1,
    "valor": 80,
    "usuario_solicitud": "Emiliano Martinez",
    "numero_transaccion": "00000000004",
    "detalles":
        "asduahsduaskhdjsdbgasjkdgasdjasbdhajksdasvdjgsdvkdjahsdknasdkjs",
    "comision": 20
  },
];

List<Map<String, dynamic>> options_solicitud = [
  {"name": "Todas", "value": 4},
  {"name": "Aprobado", "value": 1},
  {"name": "En revision", "value": 2},
  {"name": "Con novedad", "value": 3},
  {"name": "Rechazado", "value": 0}
];
