import 'dart:math';
import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:appdalada/pages/chat/create_group.dart';
import 'package:appdalada/pages/home/home_page.dart';
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

  List<String> items = [
    'Todos',
    'Livre',
    'Iniciante',
    'Intermediário',
    'Avançado'
  ];
  String? selectedItem = 'Todos';

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
                  'Grupos',
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
        stream: selectedItem != 'Todos'
            ? firebase.firestore
                .collection('grupos')
                .where('id_grupo', whereNotIn: grupoCod)
                .where('classificacao', isEqualTo: selectedItem)
                .snapshots()
            : firebase.firestore
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
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
          SizedBox(height: 15),
          FloatingActionButton(
            onPressed: () {
              _configurandoModalBottomSheet(context);
            },
            child: Icon(Icons.filter_list),
            backgroundColor: AppColors.principal,
          ),
        ],
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
            child: new Text(
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
          new TextButton(
            child: new Text(
              "Sim",
              style: GoogleFonts.quicksand(
                fontSize: 14,
                color: AppColors.principal,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            onPressed: () async {
              await firebase.firestore.collection('grupos').doc(docRef).update(
                {
                  'participantes': FieldValue.arrayUnion([
                    firebase.usuario!.uid,
                  ]),
                },
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => HomePage(),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
