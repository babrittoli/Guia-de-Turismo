import 'package:flutter/material.dart';
import 'package:rotae/controller/auth_controller.dart';
import 'package:rotae/controller/camera_controller.dart';
import 'package:rotae/controller/lugares_controller.dart';
import 'package:rotae/controller/theme_controller.dart';
import 'package:rotae/screens/camera_screen.dart';
import 'package:rotae/screens/home_screen.dart';
import 'package:rotae/screens/login_screen.dart';
import 'package:rotae/screens/cadastro_lugar.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(Inicializar());
}

class Inicializar extends StatefulWidget {
  const Inicializar({super.key});

  @override
  State<Inicializar> createState() => _InicializarState();
}

class _InicializarState extends State<Inicializar> {
  @override
  Widget build(BuildContext context) {
    /* 
    (_) -> BuildContext
      Escuta as mudanças e "compartilha" o controller com o resto do código
    */
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LugaresController()),
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => CameraController()),
      ],
      child: Consumer<ThemeController>(
        builder: (context, controllerThema, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: controllerThema.temaClaro(),
          darkTheme: controllerThema.temaEscuro(),
          themeMode: controllerThema.temaAtual,
          initialRoute: 'login',

          //Define as rotas e em quais classes devem ser chamadas
          routes: {
            'login': (context) => LoginScreen(),
            'home': (context) => HomeScreen(),
            'lugares': (context) => LugaresScreen(),
            'camera': (context) => CameraScreen(),
          },
        ),
      ),
    );
  }
}
