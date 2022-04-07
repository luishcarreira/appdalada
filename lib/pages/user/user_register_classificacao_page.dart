// ignore_for_file: prefer_const_constructors

import 'package:appdalada/components/card_classificacao_widget.dart';
import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:appdalada/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserRegisterClassificacaoPage extends StatefulWidget {
  const UserRegisterClassificacaoPage({Key? key}) : super(key: key);

  @override
  _UserRegisterClassificacaoPageState createState() =>
      _UserRegisterClassificacaoPageState();
}

class _UserRegisterClassificacaoPageState
    extends State<UserRegisterClassificacaoPage> {
  void _onSubmit(String classificacao) {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);

    firebase.firestore
        .collection('usuarios')
        .doc(firebase.usuario!.uid)
        .update({
      'classificacao': classificacao,
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 40),
          Column(
            children: [
              Text(
                'Em qual nivel',
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  color: AppColors.principal,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              Text(
                'voce se encaixa?',
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  color: AppColors.principal,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Column(
            children: [
              Text(
                'Escreva uma breve biografia sobre você! Os',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color(0xFFA1C69C),
                ),
              ),
              Text(
                'outros usuários poderão visualizar sua',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color(0xFFA1C69C),
                ),
              ),
              Text(
                'biografia visitando seu perfil.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color(0xFFA1C69C),
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          GestureDetector(
            onTap: () => {_onSubmit('Iniciante')},
            child: CardClassificacaoWidget(
              classificacao: 'Iniciante',
              descricao:
                  'Você está começando no esporte, faz pequenos percursos de trilha.',
              nomeImagem: 'ciclista_iniciante.png',
              cor: 0xFF39E11E,
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () => {_onSubmit('Intermediário')},
            child: CardClassificacaoWidget(
              classificacao: 'Intermediário',
              descricao:
                  'Você está começando no esporte, faz pequenos percursos de trilha.',
              nomeImagem: 'ciclista_medio.png',
              cor: 0xFFFFD500,
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () => {_onSubmit('Avançado')},
            child: CardClassificacaoWidget(
              classificacao: 'Avançado',
              descricao:
                  'Você está começando no esporte, faz pequenos percursos de trilha.',
              nomeImagem: 'ciclista_dificil.png',
              cor: 0xFFFF0000,
            ),
          ),
        ],
      ),
    );
  }
}
