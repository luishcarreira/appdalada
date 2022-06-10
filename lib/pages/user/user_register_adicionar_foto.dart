import 'dart:io';

import 'package:appdalada/components/user_profile_widget.dart';
import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:appdalada/pages/user/user_register_apelido_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class userRegisterAdicionarFoto extends StatefulWidget {
  const userRegisterAdicionarFoto({Key? key}) : super(key: key);

  @override
  State<userRegisterAdicionarFoto> createState() =>
      _userRegisterAdicionarFotoState();
}

class _userRegisterAdicionarFotoState extends State<userRegisterAdicionarFoto> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  bool sucess = false;
  String ref = '';
  String imagem = '';
  double progress = 0.0;

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
      ref = 'Images/usr-${firebase.usuario!.uid}.jpg';
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
            progress = 100.0 *
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
              taskSnapshot.ref.getDownloadURL().then(
                    (url) => firebase.firestore
                        .collection('usuarios')
                        .doc(firebase.usuario!.uid)
                        .set(
                      {
                        'uid': firebase.usuario!.uid,
                        'imagem': url,
                      },
                    ),
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('O arquivo foi carregado com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
              sucess = true;
            });
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase = Provider.of<AuthFirebaseService>(context);
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 60),
          Column(
            children: [
              Text(
                'Para começar, vamos',
                style: GoogleFonts.quicksand(
                  fontSize: 32,
                  color: AppColors.principal,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              Text(
                'adicionar uma foto ',
                style: GoogleFonts.quicksand(
                  fontSize: 32,
                  color: AppColors.principal,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              Text(
                'de perfil',
                style: GoogleFonts.quicksand(
                  fontSize: 32,
                  color: AppColors.principal,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Column(
            children: [
              Text(
                'Sua imagem será exibida para os outros usuários',
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  color: Color.fromARGB(255, 185, 185, 185),
                ),
              ),
              Text(
                'do Appdalada.',
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  color: Color.fromARGB(255, 185, 185, 185),
                ),
              ),
            ],
          ),
          SizedBox(height: 80),
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
          SizedBox(height: 80),
          sucess
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const UserRegisterApelidoPage(),
                        ),
                      );
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
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Continuar',
                              style: GoogleFonts.quicksand(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
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
    );
  }
}
