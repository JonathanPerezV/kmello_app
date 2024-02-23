class AccountModel {
  AccountModel({
    this.nombres,
    this.apellidos,
    this.descripcion,
    this.tipoCuenta,
    this.numeroCuenta,
    this.cedula,
    this.correo,
    this.idBanco,
    this.idTipoCuenta,
    this.idUsuario,
    this.idCuenta,
  });

  final int? idCuenta;
  final String? nombres;
  final String? apellidos;
  final String? descripcion;
  final String? tipoCuenta;
  final String? numeroCuenta;
  final String? cedula;
  final String? correo;
  final int? idBanco;
  final int? idTipoCuenta;
  final int? idUsuario;

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      idCuenta: json["id_cuenta"],
      nombres: json["nombres"],
      apellidos: json["apellidos"],
      descripcion: json["descripcion"],
      tipoCuenta: json["tipo_cuenta"],
      idBanco: json["id_banco"],
      idTipoCuenta: json["id_tipo_cuenta"],
      numeroCuenta: json["numero_cuenta"],
      cedula: json["cedula"],
      correo: json["correo"],
    );
  }

  Map<String, dynamic> toJson() => {
        "numero_cuenta": numeroCuenta,
        "id_banco": idBanco,
        "id_tipo_cuenta": idTipoCuenta,
        "id_usuario": idUsuario
      };
}
