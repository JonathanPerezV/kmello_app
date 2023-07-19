import 'package:flutter/material.dart';
import 'package:kmello_app/src/views/register/forgot_password.dart';
import 'package:kmello_app/src/views/register/initial_pages/permissions_page.dart';
import 'package:kmello_app/src/views/register/initial_pages/preview_permissions.dart';
import 'package:kmello_app/src/views/register/initial_pages/welcome_page.dart';
import 'package:kmello_app/src/views/register/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      routes: {
        "permissions": (_) => const PermissionsPage(),
        "welcome": (_) => WelcomePage(),
        "registro": (_) => RegisterPage(),
        "forgot_password": (_) => ForgotPassword(),
        "preview": (_) => InformativePage(),
      },
      initialRoute: "preview",
    );
  }
}
