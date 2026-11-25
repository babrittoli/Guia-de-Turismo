import 'dart:io'; // puxa as ferramentas pra mexer com arquivos

import 'package:flutter/material.dart'; // puxa as ferramentas prontas do flutter
import 'package:rotae/services/camera_service.dart'; // puxa o arquivo que abre a camera e a galeria

class CameraController extends ChangeNotifier {
  // aqui eh quem controla as fotos e avisa a tela quando muda algo
  final CameraService _service =
      CameraService(); // cria o ajudante que sabe abrir a camera e a galeria
  bool carregando = false; // pra saber se ta carregando ou nao, comeca como nao
  File?
  _imagemSelecionada; // onde fica guardada a foto escolhida, no comeco nao tem nenhuma
  File? get imagemSelecionada =>
      _imagemSelecionada; // deixa a tela ver a foto, mas sem poder trocar direto

  Future<void> abrirGaleria() async {
    // pra pegar uma foto da galeria
    carregando = true; // opa, comecou a carregar
    notifyListeners(); // avisa a tela pra se atualizar
    _imagemSelecionada = await _service
        .chamarGaleria(); // abre a galeria, espera a pessoa escolher e guarda a foto
    carregando = false; // pronto, parou de carregar
    notifyListeners(); // avisa a tela de novo
  } // fim da galeria

  Future<void> abrirCamera() async {
    // agora pra tirar uma foto na hora
    carregando = true; // comecou a carregar
    notifyListeners(); // avisa a tela
    _imagemSelecionada = await _service
        .chamarCamera(); // abre a camera, espera tirar a foto e guarda ela
    carregando = false; // parou de carregar
    notifyListeners(); // avisa a tela pra mostrar o resultado
  } // fim da camera
} // fim de tudo
