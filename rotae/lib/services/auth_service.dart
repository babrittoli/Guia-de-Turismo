import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final String url = 'https://guia.liliaborges.com.br/login';

  Future<Map> autenticar(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "senha": senha}),
      );
      final dados = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return dados['data'];
      } else {
        debugPrint(dados.toString());
        return {};
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> entrarComGoogle() async {
    if (kIsWeb) {
      final resultado = await FirebaseAuth.instance.signInWithPopup(
        GoogleAuthProvider(),
      );
      return resultado.user;
    }
    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize();

    final conta = await googleSignIn.authenticate();
    final credencial = GoogleAuthProvider.credential(
      idToken: conta.authentication.idToken,
    );

    final resultado = await FirebaseAuth.instance.signInWithCredential(
      credencial,
    );
    return resultado.user;
  }
}
