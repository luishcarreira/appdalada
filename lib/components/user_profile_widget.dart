// import 'dart:html';

import 'dart:io';

import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:appdalada/pages/user/user_alterar_classificacao_page.dart';
import 'package:appdalada/pages/user/user_update_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserProfileWidget extends StatefulWidget {
  final String foto;
  final String? apelido;
  final String? classificacao;
  final String? sobre;

  const UserProfileWidget({
    Key? key,
    this.apelido,
    this.classificacao,
    this.sobre,
    required this.foto,
  }) : super(key: key);

  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  String ref = '';

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
              Navigator.pop(context);
              taskSnapshot.ref.getDownloadURL().then((url) => {
                    firebase.firestore
                        .collection('usuarios')
                        .doc(firebase.usuario!.uid)
                        .update(
                      {
                        'imagem': url,
                      },
                    ),
                  });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('O arquivo foi carregado com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            });
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase = Provider.of<AuthFirebaseService>(
      context,
      listen: false,
    );

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Column(
          children: [
            //CARD TOP
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.principal,
              ),
            ),
          ],
        ),
        //#BOTAO DE LOGOUT
        Positioned(
          top: 45,
          left: 30,
          child: IconButton(
            onPressed: () {
              firebase.logout();
              firebase.usuario!.reload();
            },
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ),
        //#BOTAO DE UPDATE
        Positioned(
          top: 45,
          right: 30,
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserUpdatePage(),
                ),
              );
            },
            icon: Icon(Icons.edit, color: Colors.white),
          ),
        ),
        //#CARD NOME, APELIDO, DATA NASCIMENTO, CLASSIFICACAO
        Positioned(
          top: 150,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 4,
            child: Container(
              margin: EdgeInsets.only(left: 180, right: 180, top: 200),
            ),
          ),
        ),

        // #TEXT NOME
        Positioned(
          top: 225,
          child: Column(
            children: <Widget>[
              Text(
                'Olá, ${widget.apelido}',
                style: GoogleFonts.quicksand(
                  color: AppColors.principal,
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  _showDialogClassificacao(context);
                },
                child: (widget.classificacao == 'Iniciante')
                    ? CardClassificacao(
                        classificacao: '# ${widget.classificacao!}',
                        cor: 0xFF39E11E,
                      )
                    : (widget.classificacao == 'Intermediário')
                        ? CardClassificacao(
                            classificacao: '# ${widget.classificacao!}',
                            cor: 0xFFFFD500,
                          )
                        : CardClassificacao(
                            classificacao: '# ${widget.classificacao!}',
                            cor: 0xFFFF0000,
                          ),
              ),
            ],
          ),
        ),
        // #IMAGEM PERFIL
        Positioned(
          top: 80, // (background container size) - (circle height / 2)
          child: GestureDetector(
            onTap: () {
              _showDialogFoto(context, pickAndUploadImage);
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.foto),
              radius: 60,
            ),
          ),
        ),
        // #CARD SOBRE
        Positioned(
          top: 380,
          child: Card(
            elevation: 4,
            child: Container(
              margin: EdgeInsets.all(120),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.sobre!,
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 173,
          width: 40,
          child: CircleAvatar(
            backgroundColor: AppColors.principal.withOpacity(0.60),
            radius: 25,
          ),
        ),

        Positioned(
          top: 173,
          child: IconButton(
            onPressed: () {
              _showDialogFoto(context, pickAndUploadImage);
            },
            icon: Icon(Icons.edit, color: Colors.white),
          ),
        ),
        Positioned(
          top: 316,
          child: Text(
            'clique para alterar',
            style: GoogleFonts.quicksand(
              color: Colors.grey.shade400,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}

class CardClassificacao extends StatelessWidget {
  final String classificacao;
  final int cor;
  const CardClassificacao({
    Key? key,
    required this.classificacao,
    required this.cor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          classificacao,
          style: GoogleFonts.quicksand(
            color: Color(cor),
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

void _showDialogClassificacao(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Classificação"),
        content: const Text("Deseja alterar a classificação?"),
        actions: <Widget>[
          TextButton(
            child: Text("Sim"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => UserAlterarClassificacaoPage())));
            },
          ),
          TextButton(
            child: Text("Não"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _showDialogFoto(BuildContext context, VoidCallback pickAndUploadImage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Foto"),
        content: const Text("Deseja alterar a foto?"),
        actions: <Widget>[
          TextButton(
            child: Text("Sim"),
            onPressed: pickAndUploadImage,
          ),
          TextButton(
            child: Text("Não"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
