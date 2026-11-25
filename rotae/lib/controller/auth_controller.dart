import 'package:rotae/services/auth_service.dart'; // puxa o arquivo que cuida do login
import 'package:rotae/services/session_service.dart'; // puxa o arquivo que lembra quem ta logado
import 'package:flutter/foundation.dart'; // puxa umas ferramentas prontas do flutter

class AuthController extends ChangeNotifier {
  // aqui eh quem controla o login e avisa a tela quando muda algo
  int idLogado =
      0; // numero de quem logou, comeca no zero (aqui nem ta sendo usado)
  bool carregando = false; // pra saber se ta carregando ou nao, comeca como nao
  String erro = ''; // onde vai a mensagem de erro, comeca vazio

  Future<bool> autenticarUsuario(String email, String senha) async {
    // faz o login com email e senha e fala se deu certo
    carregando = true; // opa, comecou a carregar
    erro = ''; // limpa o erro antigo se tiver
    notifyListeners(); // avisa a tela pra se atualizar
    try {
      // tenta fazer isso aqui, se der ruim o app nao quebra
      final Map dados = await AuthService().autenticar(
        email,
        senha,
      ); // manda email e senha e espera a resposta
      final String? token =
          dados['token']; // pega o token, que eh tipo um cracha de entrada (as vezes nao vem)
      if (token == null) {
        // se nao veio o cracha...
        erro =
            'Login ou senha inválidos!'; // ...mostra que o login ou a senha ta errado
        return false; // e para aqui, nao deu certo
      } // fecha o se
      await SessionService().salvarToken(token); // salva o cracha no celular
      await SessionService().salvarUsuario(
        dados['usuario'],
      ); // salva os dados da pessoa tambem
      return true; // deu certo, pode entrar
    } catch (e) {
      // se deu algum problema cai aqui
      erro = 'Erro: ${e.toString()}'; // guarda a mensagem falando o que rolou
      return false; // nao deu certo
    } finally {
      // isso aqui roda sempre, dando certo ou nao
      carregando = false; // pronto, parou de carregar
      notifyListeners(); // avisa a tela de novo
    } // fecha o try
  } // fim do login normal

  Future<void> deslogarUsuario() async {
    // pra sair da conta
    await SessionService().logout(); // apaga o login e espera terminar
  } // fim do sair

  Future<bool> autenticarComGoogle() async {
    // agora o login pelo google
    try {
      // tenta ai
      final user = await AuthService()
          .entrarComGoogle(); // abre o google e espera a pessoa escolher a conta
      if (user == null) {
        return false;
      }
      // se nao veio conta (tipo se desistiu), nao deu
      await SessionService().salvarUsuario({
        // salva os dados que vieram do google
        'email': user.email ?? '', // o email, se nao tiver fica vazio
        'nome': user.displayName ?? '', // o nome, mesma coisa
      }); // fecha os dados
      return true; // deu certo
    } catch (e) {
      // se der problema cai aqui
      debugPrint(
        'Erro ao autenticar: $e',
      ); // mostra o erro so pra quem ta programando
      return false; // nao deu certo
    } // fecha o try
  } // fim do login com google
} // fim de tudo
