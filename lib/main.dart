import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:appdalada/pages/rotas/create_rota_final_page%20.dart';
import 'package:appdalada/pages/rotas/create_rota_inicial_page.dart';
import 'package:appdalada/pages/rotas/percurso_rota_page.dart';
import 'package:appdalada/pages/splash/splash_page.dart';
import 'package:appdalada/pages/teste/teste_position.dart';
import 'package:appdalada/pages/user/user_register_telefone.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthFirebaseService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.principal,
      ),
      home: SplashPage(),
    );
  }
}
