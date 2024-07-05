class CoordenadasModel {
  int idUser;
  String latitud;
  String longitud;

  CoordenadasModel(
      {required this.idUser, required this.latitud, required this.longitud});

  Map<String, dynamic> toJson() => {
        "id_user": idUser,
        "latitud": latitud,
        "longitud": longitud,
      };
}
