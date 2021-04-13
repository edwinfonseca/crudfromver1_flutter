import 'package:flutter/material.dart';
import 'package:fromcrud2/src/bloc/provider.dart';
import 'package:fromcrud2/src/pages/home_page.dart';
import 'package:fromcrud2/src/pages/login_page.dart';
import 'package:fromcrud2/src/pages/producto_page.dart';
import 'package:fromcrud2/src/pages/registro_page.dart';
import 'package:fromcrud2/src/preferencias_usuario/preferencias_usuario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = new PreferenciasUsuario();
  await pref.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pref = new PreferenciasUsuario();
    print(pref.token);
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'home': (BuildContext context) => HomePage(),
          'producto': (BuildContext context) => ProductoPage(),
          'registro': (BuildContext context) => RegistroPage(),
        },
        theme: ThemeData(primaryColor: Colors.deepPurple),
      ),
    );
  }
}
