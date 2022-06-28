// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:appdalada/pages/user/user_view_profile_page.dart';
import 'package:appdalada/pages/explorar/explorar_user_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ParticipantesPage extends StatefulWidget {
  final List<dynamic> participantes;
  const ParticipantesPage({Key? key, required this.participantes})
      : super(key: key);

  @override
  _ParticipantesPageState createState() => _ParticipantesPageState();
}

class _ParticipantesPageState extends State<ParticipantesPage> {
  List<String> usuariosList = [];
  @override
  void initState() {
    setState(() {
      usuariosList = widget.participantes.map((e) => e as String).toList();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.principal,
        title: Text(
          'Participantes',
          style: GoogleFonts.quicksand(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firebase.firestore
            .collection('usuarios')
            .where('uid', whereIn: usuariosList)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  'Não tem nenhum participante',
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
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
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ExplorarUserProfilePage(
                                uid: data['uid'],
                              ),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(data['imagem']),
                          backgroundColor: Colors.blueGrey,
                        ),
                        title: Text(
                          data['apelido'],
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              ).toList(),
            );
          }
          //}
        },
      ),
    );
  }
}
