import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:appdalada/pages/user/user_register_classificacao_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserRegisterSobrePage extends StatefulWidget {
  @override
  _UserRegisterSobrePageState createState() => _UserRegisterSobrePageState();
}

class _UserRegisterSobrePageState extends State<UserRegisterSobrePage> {
  final TextEditingController _sobre = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _onSubmit() {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);

    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      firebase.firestore
          .collection('usuarios')
          .doc(firebase.usuario!.uid)
          .update({
        'sobre': _sobre.text,
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UserRegisterClassificacaoPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 25),
          Column(
            children: [
              Text(
                'Nos fale um pouco',
                style: GoogleFonts.quicksand(
                  fontSize: 36,
                  color: AppColors.principal,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              Text(
                'mais sobre',
                style: GoogleFonts.quicksand(
                  fontSize: 36,
                  color: AppColors.principal,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              Text(
                'você!',
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
            children: [
              Text(
                'Escreva uma breve biografia sobre você! Os',
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  color: Color(0xFFA1C69C),
                ),
              ),
              Text(
                'outros usuários poderão visualizar sua',
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  color: Color(0xFFA1C69C),
                ),
              ),
              Text(
                'biografia visitando seu perfil.',
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  color: Color(0xFFA1C69C),
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Material(
                borderRadius: BorderRadius.circular(8),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextFormField(
                    textAlign: TextAlign.left,
                    controller: _sobre,
                    maxLines: 6,
                    maxLength: 200,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.name,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Preencha o campo corretamente!';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          Padding(
            padding: EdgeInsets.all(24),
            child: GestureDetector(
              onTap: () {
                _onSubmit();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.principal,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Continuar',
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
