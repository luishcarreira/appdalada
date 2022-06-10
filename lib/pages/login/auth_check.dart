// ignore_for_file: prefer_const_constructors

import 'package:appdalada/pages/chat/chat_message.dart';
import 'package:appdalada/pages/home/home_page.dart';
import 'package:appdalada/pages/user/user_register_adicionar_foto.dart';
import 'package:appdalada/pages/user/user_register_apelido_page.dart';
import 'package:appdalada/pages/user/user_update_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      return Loading();
    } else if (auth.usuario == null) {
      return LoginPage();
    } else {
      return verificaRegistro(auth);
    }
  }
}

Loading() {
  return Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
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
        return userRegisterAdicionarFoto();
      } else {
        return HomePage();
      }
    },
  );
}
