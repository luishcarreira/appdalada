// ignore_for_file: prefer_const_constructors

import 'package:appdalada/components/app_bar_chat_page.dart';
import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:appdalada/pages/chat/chat_message.dart';
import 'package:appdalada/pages/chat/create_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/src/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('grupos')
        .where(
          'participantes',
          arrayContains: firebase.usuario!.uid,
        )
        //.where('') //campo de pesquisa
        .snapshots();
    return Scaffold(
      appBar: AppBarChatPage(),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

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
                            builder: (_) => ChatGroup(
                              idGrupo: data['id_grupo'],
                              classificacao: data['classificacao'],
                              nome: data['nome'],
                            ),
                          ),
                        );
                      },
                      leading: Column(
                        children: [
                          if (data['classificacao'] == 'Iniciante')
                            Container(
                              child: CircleAvatar(
                                backgroundImage: AssetImage(
                                    'assets/images/ciclista_iniciante.png'),
                              ),
                            ),
                          if (data['classificacao'] == 'Intermediário')
                            Container(
                              child: CircleAvatar(
                                backgroundImage: AssetImage(
                                    'assets/images/ciclista_medio.png'),
                              ),
                            ),
                          if (data['classificacao'] == 'Avançado')
                            Container(
                              child: CircleAvatar(
                                backgroundImage: AssetImage(
                                    'assets/images/ciclista_dificil.png'),
                              ),
                            ),
                        ],
                      ),
                      title: Text(
                        data['nome'],
                      ),
                    ),
                    Divider(),
                  ],
                );
              },
            ).toList(),
          );
          //}
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateGroup(),
            ),
          );
        },
        backgroundColor: AppColors.principal,
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
