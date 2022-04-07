import 'package:appdalada/pages/login/auth_check.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 2),
    ).then((value) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AuthCheck()),
        ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}
