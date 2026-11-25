import 'package:flutter/material.dart';
import 'package:rotae/controller/camera_controller.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Consumer vai escutar/ler o controller da camera
      //DEIXANDO CLARO QUE A CAMERA AINDA NÃO SALVA AS FOTOS TIRADAS
      body: Consumer<CameraController>(
        builder: (context, controleCamera, _) => SingleChildScrollView(
          //Tudo bagulho de design e layout
          child: Column(
            children: [
              Container(
                width: double.infinity, // largura da tela toda
                height: 500, // altura da caixa
                margin: EdgeInsets.all(20), // espaço nas bordas da tela
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(24),
                  //chama o metodo exibirImagem que está logo a baixo
                  image: exibirImagem(controleCamera),
                ),
                child: controleCamera.imagemSelecionada == null
                    ? Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // centraliza na vertical
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 80, // tamanho do ícone
                            color: Colors.white,
                          ),
                          SizedBox(height: 12), // espaço entre ícone e texto
                          Text(
                            "Nenhuma foto ainda",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Tire uma foto ou escolha da galeria",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )
                    : null,
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ), // espaço dos lados
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity, // botão ocupa a largura toda
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            controleCamera.abrirCamera(), // abre a câmera
                        icon: Icon(Icons.camera_alt),
                        label: Text("Tirar foto"),
                      ),
                    ),
                    SizedBox(height: 12), // espaço entre os botões
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            controleCamera.abrirGaleria(), // abre a galeria
                        icon: Icon(Icons.photo_album),
                        label: Text("Escolher da galeria"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

DecorationImage? exibirImagem(CameraController controleCamera) {
  //Se não houver nenhuma imagem selecionada, não mostra imagem nenhuma
  if (controleCamera.imagemSelecionada == null) {
    return null; // antes carregava o placeholder 150x150 da internet
  } else {
    //Se houver, ele carrega a imagem e faz ela caber no box
    return DecorationImage(
      image: FileImage(controleCamera.imagemSelecionada!),
      fit: BoxFit.cover,
    );
  }
}
