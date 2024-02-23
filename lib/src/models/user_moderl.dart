class UserModel {
  int? idUsuario;
  String? nombres;
  String? apellidos;
  String? cedula;
  String? fechaNacimiento;
  String? pais;
  String? provincia;
  String? ciudad;
  String? foto;
  String? celular;
  String? correo;
  String? contrasena;

  UserModel({
    this.apellidos,
    this.cedula,
    this.celular,
    this.ciudad,
    this.contrasena,
    this.correo,
    this.fechaNacimiento,
    this.nombres,
    this.foto,
    this.pais,
    this.provincia,
    this.idUsuario,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      idUsuario: json["id_usuario"],
      apellidos: json["apellidos"],
      cedula: json["cedula"],
      celular: json["celular"],
      ciudad: json["ciudad"],
      contrasena: json["contrasena"],
      correo: json["correo"],
      foto: json["foto"],
      fechaNacimiento: json["fecha_nacimiento"],
      nombres: json["nombres"],
      pais: json["pais"],
      provincia: json["provincia"]);

  Map<String, dynamic> toJson() => {
        "nombres": nombres,
        "apellidos": apellidos,
        "cedula": cedula,
        "ciudad": ciudad,
        "celular": celular,
        "contrasena": contrasena,
        "correo": correo,
        "fecha_nacimiento": fechaNacimiento,
        "pais": pais,
        "provincia": provincia,
      };
}
