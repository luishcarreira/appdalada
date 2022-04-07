import 'package:appdalada/components/app_bar_explorar_page.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExplorarPage extends StatefulWidget {
  const ExplorarPage({Key? key}) : super(key: key);

  @override
  _ExplorarPageState createState() => _ExplorarPageState();
}

class _ExplorarPageState extends State<ExplorarPage> {
  Map<String, String> listaParticipantes = {};

  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);
    final Stream<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collection('grupos').snapshots();
    return Scaffold(
      appBar: AppBarExplorarPage(),
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
                        //abri alertdialog perguntando se deseja entrar no grupo
                        _showDialog(
                          context,
                          data['docRef'],
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
        },
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
                  'participantes':
                      FieldValue.arrayUnion([firebase.usuario!.uid]),
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
