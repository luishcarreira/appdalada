import 'dart:math';
import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:appdalada/pages/chat/create_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ExplorarPage extends StatefulWidget {
  const ExplorarPage({Key? key}) : super(key: key);

  @override
  _ExplorarPageState createState() => _ExplorarPageState();
}

class _ExplorarPageState extends State<ExplorarPage> {
  List<int> grupoCod = [0];
  String searchtxt = '';
  final ramdom = Random();

  @override
  void initState() {
    initMeusGrupos();
    // TODO: implement initState
    super.initState();
  }

  initMeusGrupos() {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);

    firebase.firestore
        .collection('grupos')
        .where('participantes', arrayContains: firebase.usuario!.uid)
        .get()
        .then(
          (value) => {
            value.docs.asMap().forEach(
              (index, data) {
                if (mounted) {
                  setState(() {
                    grupoCod.add(value.docs[index]['id_grupo']);
                  });
                }
              },
            ),
          },
        );
  }

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
                  'Grupos',
                  style: GoogleFonts.quicksand(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 15,
                    left: 40,
                    right: 40,
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
      body: StreamBuilder<QuerySnapshot>(
        stream: firebase.firestore
            .collection('grupos')
            .where('id_grupo', whereNotIn: grupoCod)
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
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Até o momento, não existem grupos.',
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
                      'Para criar uma grupo!',
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
                          _showDialog(
                            context,
                            data['docRef'],
                          );
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(data['imagem']),
                          backgroundColor: Colors.blueGrey,
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
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final numero = ramdom.nextInt(999999);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateGroup(
                id_grupo: numero,
              ),
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

void _showDialog(BuildContext context, String docRef) {
  AuthFirebaseService firebase =
      Provider.of<AuthFirebaseService>(context, listen: false);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("Grupos"),
        content: new Text("Deseja entrar no grupo?"),
        actions: <Widget>[
          new TextButton(
            child: new Text("Sim"),
            onPressed: () async {
              await firebase.firestore.collection('grupos').doc(docRef).update(
                {
                  'participantes': FieldValue.arrayUnion([
                    firebase.usuario!.uid,
                  ]),
                },
              );
              Navigator.of(context).pop();
            },
          ),
          new TextButton(
            child: new Text("Não"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
