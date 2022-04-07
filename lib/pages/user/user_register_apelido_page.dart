// ignore_for_file: prefer_const_constructors

import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/pages/user/user_profile_page.dart';
import 'package:appdalada/pages/user/user_register_nascimento_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';

class UserRegisterApelidoPage extends StatefulWidget {
  const UserRegisterApelidoPage({
    Key? key,
  }) : super(key: key);

  @override
  _UserRegisterApelidoPageState createState() =>
      _UserRegisterApelidoPageState();
}

class _UserRegisterApelidoPageState extends State<UserRegisterApelidoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _apelido = TextEditingController();

  _onSubmit() async {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      firebase.firestore.collection('usuarios').doc(firebase.usuario!.uid).set({
        'uid': firebase.usuario!.uid,
        'apelido': _apelido.text,
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UserRegisterNascimentoPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase = Provider.of<AuthFirebaseService>(context);
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 40),
          Center(
            child: Text(
              'Olá ${firebase.usuario!.displayName} =)',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Color(0xFFA1C69C),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            children: [
              Text(
                'Como você',
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  color: AppColors.principal,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              Text(
                'gostaria de',
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  color: AppColors.principal,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              Text(
                'ser chamado?',
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
                'Nome ou apelido que será exibido para os outros',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color(0xFFA1C69C),
                ),
              ),
              Text(
                'usuários do aplicativo.',
                style: GoogleFonts.poppins(
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
                borderRadius: BorderRadius.circular(10),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _apelido,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
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
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Continuar',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
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
