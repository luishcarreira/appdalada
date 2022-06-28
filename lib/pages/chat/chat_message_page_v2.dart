import 'dart:io';

import 'package:appdalada/components/OwnMessgaeCrad.dart';
import 'package:appdalada/components/ReplyCard.dart';
import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/core/models/message.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:appdalada/pages/chat/participantes_page.dart.dart';
import 'package:appdalada/pages/home/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatMessagePage extends StatefulWidget {
  final String refGrupo;
  final int idGrupo;
  final String classificacao;
  final String nome;
  final String imagem;
  const ChatMessagePage({
    Key? key,
    required this.nome,
    required this.refGrupo,
    required this.classificacao,
    required this.idGrupo,
    required this.imagem,
  }) : super(key: key);

  @override
  State<ChatMessagePage> createState() => _ChatMessagePageState();
}

class _ChatMessagePageState extends State<ChatMessagePage> {
  final TextEditingController txtMensagemCtrl = TextEditingController();
  bool show = false;
  FocusNode focusNode = FocusNode();
  String nomeUsuario = '';

  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              backgroundColor: AppColors.principal,
              leadingWidth: 70,
              titleSpacing: 0,
              leading: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomePage(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 24,
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.imagem),
                      backgroundColor: Colors.blueGrey,
                    ),
                  ],
                ),
              ),
              title: InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.nome,
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                PopupMenuButton<String>(
                  padding: EdgeInsets.all(0),
                  onSelected: (value) {
                    print(value);
                  },
                  itemBuilder: (BuildContext contesxt) {
                    return [
                      PopupMenuItem(
                        child: TextButton(
                          onPressed: () async {
                            await firebase.firestore
                                .collection('grupos')
                                .doc(widget.refGrupo)
                                .get()
                                .then((DocumentSnapshot doc) {
                              final data = doc.data() as Map<String, dynamic>;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ParticipantesPage(
                                    participantes: data['participantes'],
                                  ),
                                ),
                              );
                            });
                          },
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Participantes',
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        onTap: null,
                      ),
                      PopupMenuItem(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _showDialog(context, widget.refGrupo);
                          },
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Sair',
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        onTap: null,
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: WillPopScope(
              onWillPop: () {
                if (show) {
                  setState(() {
                    show = false;
                  });
                } else {
                  Navigator.pop(context);
                }
                return Future.value(false);
              },
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: firebase.firestore
                          .collection('grupos')
                          .doc(widget.refGrupo)
                          .collection('mensagens')
                          .orderBy('data', descending: true)
                          .snapshots(),
                      builder: (_, snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                            'Something went wrong',
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData && snapshot.data!.docs.isEmpty) {
                          return loading();
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
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 60,
                                child: Card(
                                  margin: EdgeInsets.only(
                                      left: 12, right: 12, bottom: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextFormField(
                                    controller: txtMensagemCtrl,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Esvreva sua mensagem",
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade400),
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                      ),
                                      contentPadding: EdgeInsets.all(5),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8,
                                  right: 2,
                                  left: 2,
                                ),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: AppColors.principal,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      await firebase.firestore
                                          .collection('usuarios')
                                          .where('uid',
                                              isEqualTo: firebase.usuario!.uid)
                                          .get()
                                          .then((value) => {
                                                value.docs
                                                    .asMap()
                                                    .forEach((index, data) {
                                                  nomeUsuario = value
                                                      .docs[index]['apelido'];
                                                })
                                              });

                                      MensagemModel m = MensagemModel(
                                        uid: firebase.usuario!.uid,
                                        nome: nomeUsuario,
                                        mensagem: txtMensagemCtrl.text,
                                        data: Timestamp.now(),
                                        idGrupo: widget.idGrupo,
                                      );

                                      await firebase.firestore
                                          .collection('grupos')
                                          .doc(widget.refGrupo)
                                          .collection('mensagens')
                                          .add(m.toMap());

                                      await firebase.firestore
                                          .collection('grupos')
                                          .doc(widget.refGrupo)
                                          .update({
                                        'ultimaMensagem': txtMensagemCtrl.text,
                                        'dataUltimaMensagem': Timestamp.now(),
                                      });

                                      txtMensagemCtrl.clear();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // show ? emojiSelect() : Container(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDialog(BuildContext context, String docRef) {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Grupos"),
          content: const Text("Deseja sair no grupo?"),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Não",
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  color: AppColors.principal,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "Sim",
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  color: AppColors.principal,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              onPressed: () async {
                await firebase.firestore
                    .collection('grupos')
                    .doc(docRef)
                    .update(
                  {
                    'participantes': FieldValue.arrayRemove([
                      firebase.usuario!.uid,
                    ]),
                  },
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomePage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Widget bottomSheet() {
  //   return Container(
  //     height: 278,
  //     width: MediaQuery.of(context).size.width,
  //     child: Card(
  //       margin: const EdgeInsets.all(18.0),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
  //         child: Column(
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 iconCreation(
  //                     Icons.insert_drive_file, Colors.indigo, "Document"),
  //                 SizedBox(
  //                   width: 40,
  //                 ),
  //                 iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
  //                 SizedBox(
  //                   width: 40,
  //                 ),
  //                 iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
  //               ],
  //             ),
  //             SizedBox(
  //               height: 30,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 iconCreation(Icons.headset, Colors.orange, "Audio"),
  //                 SizedBox(
  //                   width: 40,
  //                 ),
  //                 iconCreation(Icons.location_pin, Colors.teal, "Location"),
  //                 SizedBox(
  //                   width: 40,
  //                 ),
  //                 iconCreation(Icons.person, Colors.blue, "Contact"),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

}

loading() {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            backgroundColor: Colors.grey,
            color: AppColors.principal,
            strokeWidth: 10,
          ),
          SizedBox(height: 20),
          Text('Aguarde um momento...')
        ],
      ),
    ),
  );
}

class Mensagem extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final MensagemModel model;

  Mensagem(this.model);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (model.uid! == auth.currentUser!.uid)
            ? OwnMessageCard(
                message: model.mensagem!,
                time:
                    '${model.data!.toDate().hour}:${model.data!.toDate().minute}',
              )
            : ReplyCard(
                nome: model.nome!,
                message: model.mensagem!,
                time:
                    '${model.data!.toDate().hour}:${model.data!.toDate().minute}'),
      ],
    );
  }
}
