// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:io';

import 'package:appdalada/components/app_bar_group.dart';
import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:appdalada/pages/chat/chat_message_page_v2.dart';
import 'package:appdalada/pages/home/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class CreateGroup extends StatefulWidget {
  final int id_grupo;
  const CreateGroup({Key? key, required this.id_grupo}) : super(key: key);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nome = TextEditingController();
  String dropdownValue = 'Iniciante';

  final FirebaseStorage storage = FirebaseStorage.instance;
  String ref = '';
  String imagem = '';
  bool sucess = false;

  Future<XFile?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<UploadTask> upload(String path) async {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);
    File file = File(path);
    try {
      ref = 'Images/grp-${widget.id_grupo}.jpg';
      return storage.ref(ref).putFile(file);
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  pickAndUploadImage() async {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);
    XFile? file = await getImage();
    if (file != null) {
      UploadTask task = await upload(file.path);

      task.snapshotEvents.listen((taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            print("Upload is $progress% complete.");

            break;
          case TaskState.paused:
            print("Upload is paused.");
            break;
          case TaskState.canceled:
            print("Upload was canceled");
            break;
          case TaskState.error:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro ao inserir a imagem'),
                backgroundColor: Colors.red[400],
              ),
            );
            break;
          case TaskState.success:
            setState(() {
              taskSnapshot.ref.getDownloadURL().then((url) => imagem = url);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('O arquivo foi carregado com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
            sucess = true;
            break;
        }
      });
    }
  }

  _onSubmit() async {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      DocumentReference docRef = firebase.firestore.collection('grupos').doc();
      firebase.firestore.collection('grupos').doc(docRef.id).set(
        {
          'id_grupo': widget.id_grupo,
          'administrador': firebase.usuario!.uid,
          'participantes': [
            firebase.usuario!.uid,
          ],
          'nome': nome.text,
          'classificacao': dropdownValue,
          'docRef': docRef.id,
          'imagem': imagem,
        },
      );

      Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao inserir grupo!'),
        backgroundColor: Colors.red[400],
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: SafeArea(
          top: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  'Criar grupo',
                  style: GoogleFonts.quicksand(
                    fontSize: 36,
                    color: AppColors.principal,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ],
            ),
            SizedBox(height: 45),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextButton(
                onPressed: pickAndUploadImage,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Adiconar Imagem',
                      style: TextStyle(color: AppColors.principal),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              'Imagem que será exibida no perfil do grupo',
              style: GoogleFonts.quicksand(
                fontSize: 14,
                color: Color.fromARGB(255, 148, 145, 145),
              ),
            ),
            SizedBox(height: 15),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Material(
                      borderRadius: BorderRadius.circular(12),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: nome,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Nome do Grupo',
                            hintStyle: TextStyle(
                              color: AppColors.principal,
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return '';
                            }

                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Nome de exibição do grupo',
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  color: Color.fromARGB(255, 148, 145, 145),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Material(
                borderRadius: BorderRadius.circular(15),
                elevation: 5,
                child: DropdownButtonHideUnderline(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: AppColors.principal),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>[
                        'Livre',
                        'Iniciante',
                        'Intermediário',
                        'Avançado',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                'Classificação do grupo.',
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  color: Color.fromARGB(255, 148, 145, 145),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            sucess
                ? Padding(
                    padding: EdgeInsets.all(24),
                    child: GestureDetector(
                      onTap: () {
                        _onSubmit();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.principal,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                'Salvar',
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
                  )
                : Text(''),
          ],
        ),
      ),
    );
  }
}
