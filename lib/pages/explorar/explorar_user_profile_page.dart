import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ExplorarUserProfilePage extends StatefulWidget {
  final String uid;
  const ExplorarUserProfilePage({Key? key, required this.uid})
      : super(key: key);

  @override
  State<ExplorarUserProfilePage> createState() =>
      _ExplorarUserProfilePageState();
}

class _ExplorarUserProfilePageState extends State<ExplorarUserProfilePage> {
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
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
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
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(imagem),
                                  radius: 60,
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
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(imagens[index]),
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
                    enabled: true,
                    initialValue: nascimento,
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
                        'Telefone',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    enabled: true,
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
                    enabled: true,
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
