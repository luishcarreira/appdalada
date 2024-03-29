import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';

class UserUpdatePage extends StatefulWidget {
  UserUpdatePage({
    Key? key,
  }) : super(key: key);

  @override
  _UserUpdatePageState createState() => _UserUpdatePageState();
}

class _UserUpdatePageState extends State<UserUpdatePage> {
  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase = Provider.of<AuthFirebaseService>(
      context,
      listen: false,
    );

    CollectionReference users =
        FirebaseFirestore.instance.collection('usuarios');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(firebase.usuario!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          final format = DateFormat("dd-MM-yyyy");
          final GlobalKey _formKey = GlobalKey<FormState>();
          final TextEditingController _ctrlApelido = TextEditingController(
            text: data['apelido'],
          );

          final TextEditingController _ctrlData = TextEditingController(
            text: data['data_nascimento'],
          );
          final TextEditingController _ctrlSobre = TextEditingController(
            text: data['sobre'],
          );

          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            "Atualizar \nInformações",
                            style: GoogleFonts.quicksand(
                              color: AppColors.principal,
                              fontSize: 29,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Apelido',
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              color: Color.fromARGB(255, 148, 145, 145),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Material(
                            borderRadius: BorderRadius.circular(10),
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12, 2, 2, 2),
                              child: TextFormField(
                                controller: _ctrlApelido,
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.name,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Preencha o campo corretamente!';
                                  }

                                  return null;
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            'Data Nascimento',
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              color: Color.fromARGB(255, 148, 145, 145),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Material(
                            borderRadius: BorderRadius.circular(10),
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: DateTimeField(
                                controller: _ctrlData,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.date_range,
                                    color: AppColors.principal,
                                  ),
                                ),
                                format: format,
                                //controller: _ctrlData,
                                onShowPicker: (context, currentValue) {
                                  return showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100),
                                  );
                                },
                                validator: (text) {
                                  if (text == null) {
                                    return 'Preencha o campo corretamente!';
                                  }

                                  return null;
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            'Sobre',
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              color: Color.fromARGB(255, 148, 145, 145),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Material(
                            borderRadius: BorderRadius.circular(10),
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12, 0, 6, 6),
                              child: TextFormField(
                                textAlign: TextAlign.start,
                                controller: _ctrlSobre,
                                maxLines: 6,
                                style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.name,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Preencha o campo corretamente!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.all(26),
                            child: GestureDetector(
                              onTap: () {
                                firebase.firestore
                                    .collection('usuarios')
                                    .doc(firebase.usuario!.uid)
                                    .update(
                                  {
                                    'apelido': _ctrlApelido.text,
                                    'data_nascimento': _ctrlData.text,
                                    'sobre': _ctrlSobre.text,
                                  },
                                );

                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.principal,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        'Atualizar',
                                        style: GoogleFonts.quicksand(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
