import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:appdalada/pages/user/user_register_sobre_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class UserRegisterTelefone extends StatefulWidget {
  const UserRegisterTelefone({Key? key}) : super(key: key);

  @override
  State<UserRegisterTelefone> createState() => _UserRegisterTelefoneState();
}

class _UserRegisterTelefoneState extends State<UserRegisterTelefone> {
  @override
  final _formKey = GlobalKey<FormState>();

  var maskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  _onSubmit() {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);

    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      firebase.firestore
          .collection('usuarios')
          .doc(firebase.usuario!.uid)
          .update({
        'numero_telefone': maskFormatter.getUnmaskedText(),
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UserRegisterSobrePage(),
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 40),
          Column(
            children: [
              Text(
                'Nos informe seu',
                style: GoogleFonts.quicksand(
                  fontSize: 36,
                  color: AppColors.principal,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              Text(
                'número de telefone',
                style: GoogleFonts.quicksand(
                  fontSize: 36,
                  color: AppColors.principal,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 75),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: TextFormField(
                    inputFormatters: [
                      maskFormatter,
                    ],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'telefone',
                      hintStyle: GoogleFonts.quicksand(
                        fontSize: 18,
                        color: Color(0xFFA1C69C),
                      ),
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
          SizedBox(height: 40),
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
