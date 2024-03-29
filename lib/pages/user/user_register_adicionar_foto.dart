import 'dart:io';

import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:appdalada/pages/user/user_register_nascimento_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserRegisterAdicionarFoto extends StatefulWidget {
  const UserRegisterAdicionarFoto({Key? key}) : super(key: key);

  @override
  State<UserRegisterAdicionarFoto> createState() =>
      _UserRegisterAdicionarFotoState();
}

class _UserRegisterAdicionarFotoState extends State<UserRegisterAdicionarFoto> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _apelido = TextEditingController();

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
            taskSnapshot.ref.getDownloadURL().then((url) => imagem = url);

            setState(() {
              sucess = true;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('O arquivo foi carregado com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );

            break;
        }
      });
    }
  }

  _onSubmit() async {
    try {
      AuthFirebaseService firebase =
          Provider.of<AuthFirebaseService>(context, listen: false);

      firebase.firestore.collection('usuarios').doc(firebase.usuario!.uid).set(
        {
          'uid': firebase.usuario!.uid,
          'email': firebase.usuario!.email,
          'apelido': _apelido.text,
          'imagem': imagem,
          'imagens': [imagem],
        },
      );

      firebase.usuario!.updateDisplayName(_apelido.text);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UserRegisterNascimentoPage(),
        ),
      );
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red[400],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  color: Color(0xFFA1C69C),
                ),
              ),
              Text(
                'do aplicativo.',
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  color: Color(0xFFA1C69C),
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
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
          SizedBox(height: 25),
          Column(
            children: [
              Text(
                'Nome que ficará visível para todos os',
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  color: Color(0xFFA1C69C),
                ),
              ),
              Text(
                'usuários do aplicativo.',
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  color: Color(0xFFA1C69C),
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: TextFormField(
                    controller: _apelido,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Apelido',
                      hintStyle: GoogleFonts.quicksand(
                        fontSize: 18,
                        color: Color(0xFFA1C69C),
                      ),
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
            ),
          ),
          const SizedBox(height: 40),
          sucess
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: GestureDetector(
                    onTap: () async {
                      _onSubmit();
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
                              'Continuar',
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
    );
  }
}
