import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kmello_app/src/controller/preferences/app_preferences.dart';
import 'package:kmello_app/src/controller/dataBase/operations.dart';
import 'package:kmello_app/src/views/inside/home/home_page.dart';
import 'package:kmello_app/src/views/register/forgot_password.dart';
import 'package:kmello_app/src/views/register/initial_pages/permissions_page.dart';
import 'package:kmello_app/src/views/register/initial_pages/preview_permissions.dart';
import 'package:kmello_app/src/views/register/initial_pages/welcome_page.dart';
import 'package:kmello_app/src/views/register/login.dart';
import 'package:kmello_app/src/views/register/register.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:workmanager/workmanager.dart';

import 'src/controller/background_fetch.dart';

String routePage = "preview";
final appPreferences = AppPreferences();
final op = Operations();

void getCurrentPage() async {
  final permissions = await appPreferences.getPermissionPage();
  final welcome = await appPreferences.getWelcomePage();
  final login = await appPreferences.getLoginPage();
  final academy = await appPreferences.getAcademyPage();
  final profile = await appPreferences.getProfile();

  if (permissions) {
    routePage = "welcome";
    if (welcome) {
      routePage = "login";
      if (login) {
        routePage = "home";
      }
    } else {
      routePage = "login";
    }
  }

  return runApp(MyApp(
    route: routePage,
  ));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeWorkManager();
  await dotenv.load(fileName: '.env');
  getCurrentPage();
  await op.insertarCategoriasYproductos();
}

Future<void> initializeWorkManager() async {
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerPeriodicTask(
    "2",
    fetchBackground,
    frequency: const Duration(minutes: 15),
    /*constraints: Constraints(
      // connected or metered mark the task as requiring internet
      networkType: NetworkType.connected,
      // require external power
      requiresCharging: false,
    ),*/
  );
}

class MyApp extends StatelessWidget {
  String route;
  MyApp({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'),
        Locale('en'),
      ],
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      routes: {
        "permissions": (_) => const PermissionsPage(),
        "welcome": (_) => const WelcomePage(),
        "registro": (_) => const RegisterPage(),
        "forgot_password": (_) => const ForgotPassword(),
        "preview": (_) => const InformativePage(),
        "home": (_) => const HomePage(),
        "login": (_) => const LoginPage(),
      },
      initialRoute: route,
    );
  }
}
