// ignore_for_file: prefer_const_constructors

import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:appdalada/core/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
//biblioteca de data.dart

class ChatGroup extends StatefulWidget {
  final int idGrupo;
  final String classificacao;
  final String nome;

  const ChatGroup(
      {Key? key,
      required this.idGrupo,
      required this.classificacao,
      required this.nome})
      : super(key: key);
  @override
  _ChatGroupState createState() => _ChatGroupState();
}

class _ChatGroupState extends State<ChatGroup> {
  final TextEditingController txtMensagemCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            if (widget.classificacao == 'Iniciante')
              CircleAvatar(
                backgroundImage:
                    AssetImage("assets/images/ciclista_iniciante.png"),
                backgroundColor: Colors.white,
              ),
            if (widget.classificacao == 'Intermediário')
              CircleAvatar(
                backgroundImage: AssetImage("assets/images/ciclista_medio.png"),
                backgroundColor: Colors.white,
              ),
            if (widget.classificacao == 'Avançado')
              CircleAvatar(
                backgroundImage:
                    AssetImage("assets/images/ciclista_dificil.png"),
                backgroundColor: Colors.white,
              ),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.nome,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        toolbarHeight: 100,
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.principal),
      ),
      body: Column(
        children: [
          Flexible(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: firebase.firestore
                  .collection('mensagens')
                  .where('id_grupo', isEqualTo: widget.idGrupo)
                  .orderBy('data', descending: true)
                  .snapshots(),
              builder: (_, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData && snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (_, index) {
                    return Mensagem(
                      MensagemModel.fromMap(
                        snapshot.data!.docs[index].data(),
                      ),
                    );
                  },
                  reverse: true,
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    autofocus: true,
                    cursorColor: Colors.grey,
                    controller: txtMensagemCtrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                splashRadius: 20,
                icon: Icon(Icons.send),
                onPressed: () async {
                  MensagemModel m = MensagemModel(
                    uid: firebase.usuario!.uid,
                    nome: firebase.usuario!.displayName,
                    mensagem: txtMensagemCtrl.text,
                    data: Timestamp.now(),
                    idGrupo: widget.idGrupo,
                  );
                  await firebase.firestore
                      .collection('mensagens')
                      .add(m.toMap());
                  txtMensagemCtrl.clear();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Mensagem extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final MensagemModel model;

  Mensagem(this.model);

  EdgeInsets getMarginByUid() {
    if (model.uid! == auth.currentUser!.uid)
      return EdgeInsets.fromLTRB(100, 10, 20, 5);
    else
      return EdgeInsets.fromLTRB(20, 10, 100, 5);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: getMarginByUid(),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: model.uid! == auth.currentUser!.uid
            ? Colors.green[100]
            : Colors.blue[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.nome!,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 300,
                child: Text(model.mensagem!),
              ),
              Text(
                '${model.data!.toDate().hour}:${model.data!.toDate().minute}',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
