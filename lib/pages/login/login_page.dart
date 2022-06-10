// ignore_for_file: prefer_const_constructors

import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:appdalada/pages/login/reset_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final nome = TextEditingController();
  final senha = TextEditingController();

  bool isLogin = true;
  late String titulo;
  late String actionButton;
  late String toggleButton;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool acao) {
    setState(() {
      isLogin = acao;
      if (isLogin) {
        titulo = 'Realizar Login';

        actionButton = 'Acessar conta';
        toggleButton = 'Cadastrar';
      } else {
        titulo = 'Crie sua conta';
        actionButton = 'Cadastrar';
        toggleButton = 'Voltar ao login';
      }
    });
  }

  login() async {
    try {
      await context.read<AuthFirebaseService>().login(email.text, senha.text);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
        backgroundColor: Colors.red[400],
      ));
    }
  }

  registrar() async {
    try {
      await context
          .read<AuthFirebaseService>()
          .registrar(email.text, senha.text, nome.text);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
        backgroundColor: Colors.red[400],
      ));
    }
  }

  googleSignIn() async {
    print('');
    try {
      await context.read<AuthFirebaseService>().signInWithGoogle();
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
        backgroundColor: Colors.red[400],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 30),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 42,
              ),
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                ),
              ),
              SizedBox(
                height: 22,
              ),
              Center(
                child: Text(
                  titulo,
                  style: GoogleFonts.quicksand(
                    fontSize: 42,
                    color: AppColors.principal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (!isLogin)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                        child: Material(
                          borderRadius: BorderRadius.circular(10),
                          //color: Colors.blueGrey[50],
                          elevation: 5,
                          //shadowColor: Colors.black,
                          child: TextFormField(
                            controller: nome,
                            style: TextStyle(
                              fontSize: 22,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'nome',
                              hintStyle: TextStyle(
                                color: AppColors.principal,
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  Icons.person,
                                  color: AppColors.principal,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.name,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        //color: Colors.blueGrey[50],
                        elevation: 5,
                        //shadowColor: Colors.black,
                        child: TextFormField(
                          controller: email,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'e-mail',
                            hintStyle: TextStyle(
                              color: AppColors.principal,
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                Icons.person,
                                color: AppColors.principal,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        //color: Colors.blueGrey[50],
                        elevation: 5,
                        //shadowColor: Colors.black,
                        child: TextFormField(
                          controller: senha,
                          obscureText: true,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'senha',
                            hintStyle: TextStyle(
                              color: AppColors.principal,
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: AppColors.principal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResetPasswordPage()));
                  },
                  child: Text(
                    'Esqueceu a senha?',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(24),
                child: GestureDetector(
                  onTap: () {
                    if (isLogin) {
                      login();
                    } else {
                      registrar();
                    }
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
                            actionButton,
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
              Center(
                child: TextButton(
                  onPressed: () => setFormAction(!isLogin),
                  child: Text(
                    toggleButton,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Center(child: Text('Acessar com Google')),
              SizedBox(
                height: 24,
              ),
              GestureDetector(
                onTap: googleSignIn,
                child: Center(
                  child: Image.asset(
                    'assets/images/Google.png',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
