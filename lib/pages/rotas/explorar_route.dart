import 'dart:math';

import 'package:appdalada/Resources/route-card.dart';
import 'package:appdalada/Resources/themes.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:appdalada/pages/home/home_page.dart';
import 'package:appdalada/pages/rotas/create_rota_inicial_page.dart';
import 'package:appdalada/pages/rotas/create_rota_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appdalada/components/app_bar_explorar_rote.dart';
import 'package:provider/provider.dart';

import '../../core/app/app_colors.dart';

class ExplorarRoute extends StatefulWidget {
  const ExplorarRoute({Key? key}) : super(key: key);

  @override
  State<ExplorarRoute> createState() => _ExplorarRouteState();
}

class _ExplorarRouteState extends State<ExplorarRoute> {
  final ramdom = Random();
  String searchtxt = '';
  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(122),
        child: Container(
          padding: EdgeInsets.only(
            top: 12 + MediaQuery.of(context).padding.bottom,
          ),
          color: AppColors.principal,
          child: SafeArea(
            top: true,
            child: Column(
              children: [
                Text(
                  'Rotas',
                  style: GoogleFonts.quicksand(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 15,
                    left: 30,
                    right: 30,
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(12),
                    elevation: 3,
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Pesquisar',
                        hintStyle: TextStyle(
                          color: AppColors.principal,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.search,
                            color: AppColors.principal,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: firebase.firestore.collection('rotas').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Até o momento, não existem rotas.',
                              style: GoogleFonts.quicksand(
                                fontSize: 18,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            Text(
                              'Clique no "+" no canto inferior direito',
                              style: GoogleFonts.quicksand(
                                fontSize: 18,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            Text(
                              'para criar uma rota!',
                              style: GoogleFonts.quicksand(
                                fontSize: 18,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return ListView(
                      children: snapshot.data!.docs.map(
                        (DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;

                          return Column(
                            children: [
                              PaidMenCard(
                                imagem: data['imagem'],
                                nome: data['nome'],
                                classificacao: data['classificacao'],
                              ),
                              const SizedBox(
                                height: 15,
                              )
                            ],
                          );
                        },
                      ).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.principal,
        onPressed: () async {
          DocumentReference docRef =
              firebase.firestore.collection('rotas').doc();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateRotaPage(
                refDoc: docRef.id,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
