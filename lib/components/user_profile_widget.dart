import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:appdalada/pages/user/user_update_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserProfileWidget extends StatefulWidget {
  final String foto;
  final String? nome;
  final String? apelido;
  final String? classificacao;
  final String? sobre;

  const UserProfileWidget({
    Key? key,
    this.nome,
    this.apelido,
    this.classificacao,
    this.sobre,
    required this.foto,
  }) : super(key: key);

  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase = Provider.of<AuthFirebaseService>(
      context,
      listen: false,
    );
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Column(
          children: [
            //CARD TOP
            Container(
              height: 200,
              decoration: BoxDecoration(
                  color: AppColors.principal,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
            ),
          ],
        ),
        //#BOTAO DE LOGOUT
        Positioned(
          top: 20,
          left: 30,
          child: IconButton(
            onPressed: () {
              firebase.logout();
            },
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ),
        //#BOTAO DE UPDATE
        Positioned(
          top: 20,
          right: 30,
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserUpdatePage(),
                ),
              );
            },
            icon: Icon(Icons.edit, color: Colors.white),
          ),
        ),
        //#CARD NOME, APELIDO, DATA NASCIMENTO, CLASSIFICACAO
        Positioned(
          top: 150,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 4,
            child: Container(
              margin: EdgeInsets.only(left: 180, right: 180, top: 200),
            ),
          ),
        ),
        // #TEXT NOME
        Positioned(
          top: 220,
          child: Column(
            children: <Widget>[
              Text(
                'Olá, ${widget.nome}',
                style: GoogleFonts.quicksand(
                  color: AppColors.principal,
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                ),
              ),
              Text(
                '@${widget.apelido}',
                style: GoogleFonts.quicksand(
                  color: Color(0xFF9CA59B),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              (widget.classificacao == 'Iniciante')
                  ? CardClassificacao(
                      classificacao: '# ${widget.classificacao!}',
                      cor: 0xFF39E11E,
                    )
                  : (widget.classificacao == 'Intermediário')
                      ? CardClassificacao(
                          classificacao: '# ${widget.classificacao!}',
                          cor: 0xFFFFD500,
                        )
                      : CardClassificacao(
                          classificacao: '# ${widget.classificacao!}',
                          cor: 0xFFFF0000,
                        )
            ],
          ),
        ),
        // #IMAGEM PERFIL
        Positioned(
          top: 80, // (background container size) - (circle height / 2)
          child: CircleAvatar(
            backgroundImage: NetworkImage(widget.foto),
            radius: 60,
          ),
        ),
        // #CARD SOBRE
        Positioned(
          top: 450,
          child: Card(
            elevation: 4,
            child: Container(
              margin: EdgeInsets.all(100),
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Text(widget.sobre!),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CardClassificacao extends StatelessWidget {
  final String classificacao;
  final int cor;
  const CardClassificacao({
    Key? key,
    required this.classificacao,
    required this.cor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          classificacao,
          style: GoogleFonts.quicksand(
            color: Color(cor),
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
