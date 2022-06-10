import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/pages/chat/chat_page.dart';
import 'package:appdalada/pages/explorar/explorar_page.dart';
import 'package:appdalada/pages/rotas/explorar_route.dart';
import 'package:appdalada/pages/user/user_profile_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaAtual = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        children: [
          ExplorarRoute(),
          ExplorarPage(),
          ChatPage(),
          UserProfilePage(),
        ],
        onPageChanged: setPaginaAtual,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.pedal_bike,
                color: AppColors.principal,
              ),
              label: 'Rotas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.groups_sharp, color: AppColors.principal),
              label: 'Grupos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined, color: AppColors.principal),
              label: 'Chat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, color: AppColors.principal),
              label: 'Perfil'),
        ],
        onTap: (pagina) {
          pc.animateToPage(
            pagina,
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          );
        },
        selectedItemColor: AppColors.principal,
      ),
    );
  }
}
