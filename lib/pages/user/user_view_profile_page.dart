import 'dart:io';
import 'dart:math';

import 'package:appdalada/components/image_icon_widget.dart';
import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:appdalada/pages/user/user_alterar_classificacao_page.dart';
import 'package:appdalada/pages/user/user_update_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class UserViewProfilePage extends StatefulWidget {
  final String uid;
  const UserViewProfilePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<UserViewProfilePage> createState() => _UserViewProfilePageState();
}

class _UserViewProfilePageState extends State<UserViewProfilePage> {
  String imageAdicionar =
      'https://cdn.pixabay.com/photo/2018/11/13/21/43/instagram-3814051_960_720.png';

  String apelido = '';
  String classificacao = '';
  String sobre = '';
  String imagem = '';
  String nascimento = '';
  String telefone = '';

  List<dynamic> imagens = [];

  @override
  void initState() {
    initUser();
    // TODO: implement initState
    super.initState();
  }

  var maskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  initUser() async {
    final usuario = context
        .read<AuthFirebaseService>()
        .firestore
        .collection('usuarios')
        .doc(widget.uid);

    imagens.clear();

    await usuario.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          apelido = data['apelido'];
          classificacao = data['classificacao'];
          sobre = data['sobre'];
          imagem = data['imagem'];
          nascimento = data['data_nascimento'];
          telefone = data['numero_telefone'];
          imagens = data['imagens'];
          imagens.add(imageAdicionar);
        });
      }
    });
  }

  FirebaseStorage storage = FirebaseStorage.instance;
  List<XFile>? _image;
  final imagePicker = ImagePicker();
  List<String> downloadURL = [];
  List<String> urls = [];
  var isLoading = false;
  int uploadItem = 0;
  UploadTask? uploadTask;
  final ramdom = Random();

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(
      content: Text(snackText),
      duration: d,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future imagePickerMethod() async {
    final pick = await imagePicker.pickMultiImage();
    setState(() {
      if (pick != null) {
        _image = pick;
        uploadFunction(_image!);
      } else {
        showSnackBar("No file selected", const Duration(milliseconds: 400));
      }
    });
  }

  void uploadFunction(List<XFile> images) async {
    setState(() {
      isLoading = true;
    });

    for (int i = 0; i < images.length; i++) {
      var imgUrl = await uploadFile(images[i]);
      urls.add(imgUrl.toString());
    }

    add().whenComplete(() {
      urls.clear();
      setState(() {
        isLoading = false;
        initUser();
      });
    });
  }

  Future<String> uploadFile(XFile images) async {
    final numero = ramdom.nextInt(99999);
    Reference ref = storage
        .ref()
        .child('Images/')
        .child("usr_${widget.uid + numero.toString()}");
    uploadTask = ref.putFile(File(images.path));
    await uploadTask?.whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });

    return await ref.getDownloadURL();
  }

  Future<void> add() {
    final DocumentReference reference =
        FirebaseFirestore.instance.collection('usuarios').doc(widget.uid);

    return reference.update({
      'imagens': FieldValue.arrayUnion(urls),
    }).then(
      (value) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O arquivo foi carregado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase = Provider.of<AuthFirebaseService>(
      context,
      listen: false,
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(330),
          child: Container(
            color: AppColors.principal,
            child: SafeArea(
              top: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.logout, color: Colors.white),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(0),
                        onSelected: (value) {
                          switch (value) {
                            case 'perfil':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => UserUpdatePage(),
                                ),
                              );

                              break;
                            case 'classificacao':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      UserAlterarClassificacaoPage(),
                                ),
                              );

                              break;
                          }
                        },
                        itemBuilder: (BuildContext contesxt) {
                          return [
                            PopupMenuItem(
                              child: Text("Editar Perfil"),
                              value: 'perfil',
                            ),
                            PopupMenuItem(
                              child: Text("Editar Classificação"),
                              value: 'classificacao',
                            )
                          ];
                        },
                      ),
                    ],
                  ),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 150,
                          child: imagem != ""
                              ? ImageIconWidget(
                                  imagePath: imagem,
                                  onClicked: () async {},
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 60,
                                ),
                        ),
                        Text(
                          apelido,
                          style: GoogleFonts.quicksand(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TabBar(
                      labelColor: Colors.black54,
                      indicatorColor: Colors.white,
                      indicator: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(50), // Creates border
                          color: Colors.white),
                      tabs: <Widget>[
                        Tab(
                          text: 'Fotos',
                        ),
                        // Tab(
                        //   text: 'Sobre',
                        // ),
                        Tab(
                          text: 'Informações',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            (imagens.isNotEmpty)
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      crossAxisCount: 3,
                    ),
                    itemCount: imagens.length,
                    itemBuilder: (context, index) {
                      // Item rendering
                      return GestureDetector(
                        onTap: () {
                          if (imagens[index] == imageAdicionar) {
                            imagePickerMethod();
                          } else {
                            _showDialog(context, widget.uid, imagens[index]);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(imagens[index]),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      label: Text(
                        'Classificação',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    enabled: false,
                    initialValue: classificacao,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      label: Text(
                        'Data de Nascimento',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    enabled: false,
                    initialValue: nascimento,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    inputFormatters: [
                      maskFormatter,
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      label: Text(
                        'Telefone',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    enabled: false,
                    initialValue: telefone,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      label: Text(
                        'Sobre',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    enabled: false,
                    initialValue: sobre,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showDialog(BuildContext context, String uid, String imagem) {
  AuthFirebaseService firebase =
      Provider.of<AuthFirebaseService>(context, listen: false);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(
          child: Text("Excluir Foto"),
        ),
        content: Text("Confirma a exclusão dessa imagem?"),
        actions: <Widget>[
          TextButton(
            child: Text("Sim"),
            onPressed: () async {
              //rxcluir

              await firebase.firestore.collection('usuarios').doc(uid).update({
                'imagens': FieldValue.arrayRemove(
                  [
                    imagem,
                  ],
                )
              });

              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text("Não"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
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
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
