import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  //todo GUARDAR REGISTRO QUE YA PASAMOS LA PÁGINA DE LOS PERMISOS
  Future<void> savePermissionsPage(bool access) async {
    final pfrc = await SharedPreferences.getInstance();
    await pfrc.setBool("permissions", access);
  }

  Future<bool> getPermissionPage() async {
    final pfrc = await SharedPreferences.getInstance();
    return pfrc.getBool("permissions") ?? false;
  }

  //todo GUARDAR REGISTRO QUE YA PASAMOS LA PÁGINA DE BIENVENIDA
  Future<void> saveWelcomePage(bool access) async {
    final pfrc = await SharedPreferences.getInstance();
    await pfrc.setBool("welcome", access);
  }

  Future<bool> getWelcomePage() async {
    final pfrc = await SharedPreferences.getInstance();
    return pfrc.getBool("welcome") ?? false;
  }

  //todo GUARDAR REGISTRO QUE YA PASAMOS LA PÁGINA DE LOGIN
  Future<void> saveLoginPage(bool access) async {
    final pfrc = await SharedPreferences.getInstance();
    await pfrc.setBool("login", access);
  }

  Future<bool> getLoginPage() async {
    final pfrc = await SharedPreferences.getInstance();
    return pfrc.getBool("login") ?? false;
  }

  //todo GUARDAR REGISTRO QUE YA SELECCIONO EL TIPO DE VENDEDOR EL USUARIO
  Future<void> saveProfile(bool access) async {
    final pfrc = await SharedPreferences.getInstance();
    await pfrc.setBool("profile", access);
  }

  Future<bool> getProfile() async {
    final pfrc = await SharedPreferences.getInstance();
    return pfrc.getBool("profile") ?? false;
  }

  //todo GUARDAR REGISTRO QUE YA PASAMOS LA PÁGINA DE LA ACADEMIA
  Future<void> saveAcademyPage(bool access) async {
    final pfrc = await SharedPreferences.getInstance();
    await pfrc.setBool("academy", access);
  }

  Future<bool> getAcademyPage() async {
    final pfrc = await SharedPreferences.getInstance();
    return pfrc.getBool("academy") ?? false;
  }
}
