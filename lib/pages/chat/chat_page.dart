// ignore_for_file: prefer_const_constructors

import 'package:appdalada/components/app_bar_chat_page.dart';
import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:appdalada/pages/chat/chat_message_page_v2.dart';
import 'package:appdalada/pages/chat/create_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);

    return Scaffold(
      appBar: AppBarChatPage(),
      body: StreamBuilder<QuerySnapshot>(
        stream: firebase.firestore
            .collection('grupos')
            .where('participantes', arrayContains: firebase.usuario!.uid)
            .snapshots(),
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
                            builder: (_) => ChatMessagePage(
                              refGrupo: data['docRef'],
                              idGrupo: data['id_grupo'],
                              classificacao: data['classificacao'],
                              nome: data['nome'],
                              imagem: data['imagem'],
                            ),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(data['imagem']),
                        backgroundColor: Colors.blueGrey,
                      ),
                      title: Text(
                        data['nome'],
                      ),
                      subtitle: data['ultimaMensagem'] != null
                          ? Text(data['ultimaMensagem'])
                          : Text(''),
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
