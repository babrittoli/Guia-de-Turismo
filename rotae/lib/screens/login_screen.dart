import 'package:flutter/material.dart';
import 'package:rotae/controller/auth_controller.dart'; // Chamando o controller que faz o Login
import 'package:provider/provider.dart'; // Chamando o provider que escuta o controller

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /*
    Dados para entrar no sistema
    email: lilia@teste.com  | Senha: senha123
  */
  final _email =
      TextEditingController(); // Variável que guarda o que a pessoa digita no campo de e-mail
  final _senha =
      TextEditingController(); // Variável que guarda o que a pessoa digita no campo de senha

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Estrutura da página
      backgroundColor: Theme.of(context)
          .colorScheme
          .primary, // cor de fundo chamando a cor configurada no Theme Controller
      body: Consumer<AuthController>(
        //Consumer vai ler/ouvir o controller de Autenticação - // Redesenha a tela quando o AuthController avisar que mudou
        builder: (context, controleAuth, _) => Padding(
          // margem geral da página
          padding: EdgeInsets.all(16),
          child: Column(
            // Centralizando tudo na vertical em coluna
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 120,
              ), // Logo do Rotaê, com 120 de altura
              SizedBox(height: 32), // Criando margem abaixo do logo
              TextField(
                // Criando campo de digitar o e-mail
                controller: _email,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "E-mail",
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                // Criando campo de digitar senha
                controller: _senha,
                obscureText: true, //Esconde a senha
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Senha",
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 16),

              Text(
                controleAuth
                    .erro, // espaço para aparecer mensagens de erro, ficará vazio se não tiver erro
              ),
              SizedBox(height: 20),
              //botão que faz o processo de autenticação das informações dde login
              ElevatedButton(
                onPressed: () async {
                  //Tentar logar
                  final logou = await controleAuth.autenticarUsuario(
                    _email.text,
                    _senha.text,
                  );
                  if (logou && context.mounted) {
                    //pushNamed -> cria uma "setinha" que te permite voltar a tela anterior
                    Navigator.pushNamed(context, 'home');
                  }
                },
                child: Text("Entrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
