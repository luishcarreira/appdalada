// ignore_for_file: prefer_const_constructors

import 'package:appdalada/components/card_classificacao_widget.dart';
import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:appdalada/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserAlterarClassificacaoPage extends StatefulWidget {
  const UserAlterarClassificacaoPage({Key? key}) : super(key: key);

  @override
  _UserAlterarClassificacaoPageState createState() =>
      _UserAlterarClassificacaoPageState();
}

class _UserAlterarClassificacaoPageState
    extends State<UserAlterarClassificacaoPage> {
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
                'Em qual nível',
                style: GoogleFonts.quicksand(
                  fontSize: 36,
                  color: AppColors.principal,
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
              Text(
                'de prática',
                style: GoogleFonts.quicksand(
                  fontSize: 36,
                  color: AppColors.principal,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              Text(
                'você se encaixa?',
                style: GoogleFonts.quicksand(
                  fontSize: 36,
                  color: AppColors.principal,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Column(
            children: [],
          ),
          SizedBox(height: 25),
          GestureDetector(
            onTap: () => {_onSubmit('Iniciante')},
            child: CardClassificacaoWidget(
              classificacao: 'Iniciante',
              descricao:
                  'Geralmente são usuários que não estão habituados à pratica de esportes no geral.',
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
                  'Este perfil já não encontra dificuldades em pequenas pedaladas. .',
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
                  'Este praticante já reconhece sua capacidade no pedal, capaz de fazer longas trilhas.',
              nomeImagem: 'ciclista_dificil.png',
              cor: 0xFFFF0000,
            ),
          ),
        ],
      ),
    );
  }
}
