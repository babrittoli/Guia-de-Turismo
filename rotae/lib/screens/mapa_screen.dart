import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:rotae/controller/mapa_controller.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:rotae/controller/lugares_controller.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MapaController>(
      builder: (context, mapaController, child) => Scaffold(
        body: SafeArea(
          top: true,
          bottom: true,
          child: Column(
            //Centralização
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Se está carregando, mostra o circulo de loading
              mapaController.carregando
                  ? Center(child: CircularProgressIndicator())
                  //Se não achar/carregar, fala que n foi encontrado
                  : mapaController.atual == null
                  ? Center(child: Text("Não encontrado"))
                  //Se achar/carregar o mapa
                  : Expanded(
                      child: FlutterMap(
                        options: MapOptions(
                          initialZoom: 15,
                          //! significa que não vai estar nulo
                          initialCenter: mapaController.atual!,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                            //Informa quem está pedindo para usar o mapa
                            userAgentPackageName: "br.com.guiaturismo.maps",
                          ),
                          MarkerLayer(
                            markers: mapaController.pontosNoMapa
                                .map(
                                  (pontoReferencia) => Marker(
                                    alignment: Alignment.center,
                                    width: 40,
                                    height: 40,
                                    rotate: true,
                                    point: pontoReferencia,
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),

                          //pins dos lugares cadastrados na API
                          MarkerLayer(
                            markers: context
                                .watch<
                                  LugaresController
                                >() // pega a lista de lugares
                                .lugares
                                // where = filtro: só deixa passar lugares com
                                // coordenadas válidas (ignora vazio/zero e valores absurdos)
                                .where(
                                  (lugar) =>
                                      lugar.latitude >= -90 &&
                                      lugar.latitude <= 90 &&
                                      lugar.longitude >= -180 &&
                                      lugar.longitude <= 180 &&
                                      (lugar.latitude != 0 ||
                                          lugar.longitude != 0),
                                )
                                // map = transforma cada lugar em um pin
                                .map(
                                  (lugar) => Marker(
                                    alignment: Alignment.center,
                                    width: 40,
                                    height: 40,
                                    rotate: true,
                                    point: LatLng(
                                      lugar.latitude.toDouble(),
                                      lugar.longitude.toDouble(),
                                    ),
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors
                                          .blue, // vermelho para diferenciar do seu
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          //Centraliza a posição do usuário no mapa
          onPressed: () => mapaController.buscarLocal(),
          child: Icon(Icons.person_pin_circle_rounded),
        ),
      ),
    );
  }
}
