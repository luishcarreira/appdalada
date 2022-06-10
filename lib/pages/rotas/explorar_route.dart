import 'dart:math';

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
  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);

    return Scaffold(
      appBar: AppBarExplorarRoute(),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Até o momento, não existem rotas.',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            'Clique no "+" no canto inferior direito',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            'Para criar uma rota!',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ],
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
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(data['imagem']),
                                  backgroundColor: Colors.blueGrey,
                                ),
                                title: Text(
                                  data['nome'],
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                ),
                                subtitle: Text(
                                  data['classificacao'],
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const Divider(),
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateRotaInicialPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
