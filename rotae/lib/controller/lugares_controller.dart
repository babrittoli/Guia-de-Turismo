import 'package:flutter/material.dart';
import 'package:rotae/models/lugares_model.dart';
import 'package:rotae/services/lugares_service.dart';
import 'package:rotae/services/session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LugaresController extends ChangeNotifier {
  bool carregando = false;
  String erro = "";
  List<LugaresModel> _lugares = [];
  List<LugaresModel> get lugares => _lugares;
  List<String> favoritos = [];

  LugaresController() {
    listaLugares();
    carregarFavoritos();
  }

  //funcao de ler os favoritos no app
  Future<void> carregarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    favoritos = prefs.getStringList('favoritos') ?? [];
    notifyListeners();
  }

  //marcar e descarmar favorito
  Future<void> alternarFavorito(int id) async {
    final texto = id.toString();
    if (favoritos.contains(texto)) {
      favoritos.remove(texto);
    } else {
      favoritos.add(texto);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoritos', favoritos);
  }

  Future<void> listaLugares() async {
    carregando = true;
    notifyListeners();
    try {
      final lugaresService = LugaresServices();
      final listaLugares = await lugaresService.buscarLugares();
      _lugares = listaLugares;
    } catch (error) {
      erro = "Erro ao listar: ${error.toString()}";
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<String> cadastrarLugar(LugaresModel dados) async {
    final token = await SessionService().pegarToken() ?? '';
    carregando = true;
    erro = "";
    notifyListeners();

    try {
      final lugaresService = LugaresServices();
      //Gera uma autenticação permitindo registro de dados na api
      final resposta = await lugaresService.cadastrarLugar(dados, token);
      await listaLugares();
      return resposta;
    } catch (e) {
      erro = "Erro ao cadastrar: $e";
      return erro;
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
