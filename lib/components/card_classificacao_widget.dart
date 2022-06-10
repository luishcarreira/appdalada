import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardClassificacaoWidget extends StatelessWidget {
  final String classificacao;
  final String descricao;
  final String nomeImagem;
  final int cor;
  const CardClassificacaoWidget({
    Key? key,
    required this.classificacao,
    required this.descricao,
    required this.nomeImagem,
    required this.cor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(left: 40, right: 40),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Center(
          child: ListTile(
            leading: Container(
              child: Image.asset('assets/images/$nomeImagem'),
            ),
            title: Text(
              '# $classificacao',
              style: GoogleFonts.quicksand(
                color: Color(cor),
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            subtitle: Text(
              descricao,
              style: GoogleFonts.quicksand(
                color: Color(0xFF676767),
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
