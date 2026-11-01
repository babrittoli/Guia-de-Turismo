import 'package:flutter/material.dart';
import 'package:rotae/controller/theme_controller.dart';
import 'package:rotae/screens/camera_screen.dart';
import 'package:rotae/screens/cadastro_lugar.dart';
import 'package:rotae/screens/mapa_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _paginaAtual = 0;
  //Geram links e titulo para os botões do bottomNavigationBar
  final List<Widget> _paginas = [
    Center(),
    CameraScreen(),
    LugaresScreen(),
    MapaScreen(),
  ];

  final List<String> _cabecalho = [
    'Guia Turismo',
    'Tirar foto',
    'Lugares Para visitar',
    'GPS',
  ];
  //Do ultimo comentário até aqui é para o bottomNavigationBar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Pega o titulo pelo indice
        title: Text(_cabecalho[_paginaAtual]),
        actions: [
          /*
            Consumer vai ouvir o ThemeController e quando o botão é pressionado ele vai
            trocar de tema 
          */
          Consumer<ThemeController>(
            builder: (context, controllerThema, child) => IconButton(
              onPressed: () => controllerThema.alternarTema(),
              icon: Icon(controllerThema.iconeAtual),
            ),
          ),
        ],
      ),
      //Pega o conteudo da pagina pelo indice
      body: _paginas[_paginaAtual],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaAtual,
        //Só para garantir que os icones do BottomNavigationBar apareçam
        showSelectedLabels: true,
        showUnselectedLabels: true,

        //Muda o index da pagina, e por consequencia a página
        onTap: (index) => setState(() => _paginaAtual = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'Camera'),
          BottomNavigationBarItem(icon: Icon(Icons.place), label: 'Locais'),
          BottomNavigationBarItem(icon: Icon(Icons.gps_fixed), label: 'GPS'),
        ],
      ),
    );
  }
}
