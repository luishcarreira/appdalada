// ignore_for_file: prefer_const_constructors

import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/pages/home/home_page.dart';
import 'package:appdalada/pages/user/user_register_adicionar_foto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:appdalada/pages/login/login_page.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthFirebaseService auth = Provider.of<AuthFirebaseService>(context);

    if (auth.isLoading) {
      return loading();
    } else if (auth.usuario == null) {
      return LoginPage();
    } else {
      return verificaRegistro(auth);
    }
  }
}

loading() {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            backgroundColor: Colors.grey,
            color: AppColors.principal,
            strokeWidth: 10,
          ),
          SizedBox(height: 20),
          Text('Aguarde um momento...')
        ],
      ),
    ),
  );
}

verificaRegistro(AuthFirebaseService auth) {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('usuarios')
      .where('uid', isEqualTo: auth.usuario!.uid.toString())
      .snapshots();
  return StreamBuilder<QuerySnapshot>(
    stream: _usersStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text('Something went wrong');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
        return UserRegisterAdicionarFoto();
      } else {
        return HomePage();
      }
    },
  );
}
