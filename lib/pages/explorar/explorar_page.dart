import 'package:appdalada/components/app_bar_explorar_page.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initMeusGrupos();
  }

  List<String> grupoCod = [''];

  String searchtxt = '';

  initMeusGrupos() {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);
    Stream<QuerySnapshot> _meusGrupos = firebase.firestore
        .collection('grupos')
        .where('participantes', arrayContains: firebase.usuario!.uid)
        .snapshots();

    _meusGrupos.forEach((element) {
      element.docs.asMap().forEach((index, data) {
        setState(() {
          grupoCod.add(element.docs[index]['codigo']);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Container(
          padding: EdgeInsets.only(
            top: 14 + MediaQuery.of(context).padding.bottom,
          ),
          color: AppColors.principal,
          child: SafeArea(
            top: true,
            child: Column(
              children: [
                Text(
                  'Explorar',
                  style: GoogleFonts.quicksand(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 1,
                    left: 20,
                    right: 20,
                  ),
                  child: TextFormField(
                    onChanged: (text) => {
                      searchtxt = text,
                      setState(
                        () {
                          searchtxt;
                        },
                      )
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 15, 0),
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.search),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
        stream: (searchtxt != '' && searchtxt.isNotEmpty)
            ? firebase.firestore
                .collection('grupos')
                .where('nome', isGreaterThanOrEqualTo: searchtxt)
                .where('nome', isLessThanOrEqualTo: searchtxt + '\uf7ff')
                .where('id_grupo', whereIn: grupoCod)
                .snapshots()
            : firebase.firestore
                .collection('grupos')
                .where('id_grupo', whereIn: grupoCod)
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
