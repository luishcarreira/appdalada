// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:appdalada/Resources/themes.dart';
import 'package:appdalada/components/app_bar_chat_page.dart';
import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:appdalada/pages/chat/chat_message_page_v2.dart';
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
  String searchtxt = '';

  List<String> items = [
    'Todos',
    'Livre',
    'Iniciante',
    'Intermediário',
    'Avançado'
  ];
  String? selectedItem = 'Todos';

  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(105),
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
                  'Meus grupos',
                  style: GoogleFonts.quicksand(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 45,
                    right: 45,
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(8),
                    elevation: 3,
                    child: SizedBox(
                      height: 35,
                      width: 270,
                      child: TextFormField(
                        onChanged: (text) {
                          searchtxt = text;
                          setState(
                            () {
                              searchtxt;
                            },
                          );
                        },
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 3),
                          border: InputBorder.none,
                          hintText: 'Pesquisar',
                          hintStyle: GoogleFonts.quicksand(
                            fontSize: 14,
                            color: AppColors.principal,
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(
                                top: 2, bottom: 1, left: 1, right: 1),
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
                ),
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: (searchtxt != '' && searchtxt != null)
            ? selectedItem != 'Todos'
                ? firebase.firestore
                    .collection('grupos')
                    .where('participantes',
                        arrayContains: firebase.usuario!.uid)
                    .where('classificacao', isEqualTo: selectedItem)
                    .where('nome', isGreaterThanOrEqualTo: searchtxt)
                    .where('nome', isLessThanOrEqualTo: searchtxt + '\uf7ff')
                    .snapshots()
                : firebase.firestore
                    .collection('grupos')
                    .where('participantes',
                        arrayContains: firebase.usuario!.uid)
                    .where('nome', isGreaterThanOrEqualTo: searchtxt)
                    .where('nome', isLessThanOrEqualTo: searchtxt + '\uf7ff')
                    .snapshots()
            : selectedItem != 'Todos'
                ? firebase.firestore
                    .collection('grupos')
                    .where('participantes',
                        arrayContains: firebase.usuario!.uid)
                    .where('classificacao', isEqualTo: selectedItem)
                    .snapshots()
                : firebase.firestore
                    .collection('grupos')
                    .where('participantes',
                        arrayContains: firebase.usuario!.uid)
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Você ainda não participa de',
                      style: GoogleFonts.quicksand(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      'nenhum grupo!',
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
                            : Text('Nenhuma mensagem ainda...'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _configurandoModalBottomSheet(context);
        },
        child: Icon(Icons.filter_list),
        backgroundColor: AppColors.principal,
      ),
    );
  }

  void _configurandoModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return DropdownButtonFormField<String>(
          value: selectedItem,
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        //color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ))
              .toList(),
          onChanged: (item) => setState(() => selectedItem = item),
          // onChanged: null,
        );
      },
    );
  }
}
