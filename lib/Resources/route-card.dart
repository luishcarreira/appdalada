import 'package:appdalada/Resources/themes.dart';
import 'package:appdalada/core/app/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

NumberFormat format = NumberFormat.simpleCurrency();

class RouteCard extends StatelessWidget {
  final String imagem;
  final String nome;
  final String classificacao;
  final GeoPoint startPosition;
  final GeoPoint finalPosition;

  const RouteCard({
    Key? key,
    required this.imagem,
    required this.nome,
    required this.classificacao,
    required this.finalPosition,
    required this.startPosition,
  }) : super(key: key);

  rotaInicial(context) async {
    try {
      final coords = Coords(startPosition.latitude, startPosition.longitude);
      final title = "Inicio da Rota";
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: title,
                        ),
                        title: Text(map.mapName),
                        leading: SvgPicture.asset(
                          map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  rotaFinal(context) async {
    try {
      final coords = Coords(finalPosition.latitude, finalPosition.longitude);
      final title = "Fim da Rota";
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: title,
                        ),
                        title: Text(map.mapName),
                        leading: SvgPicture.asset(
                          map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(4)),
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 150,
                    width: 150,
                    child: Container(
                      child: Image.network(
                        imagem,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nome,
                                  style: GoogleFonts.quicksand(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  classificacao,
                                  style: GoogleFonts.quicksand(
                                    fontSize: 10,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(color: Colors.black12),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 5,
                              right: 5,
                            ),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              // mainAxisSize: MainAxisSize.max,

                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    // Text(
                                    //   "km",
                                    //   style: smallGreyStyle,
                                    // ),

                                    GestureDetector(
                                      onTap: () {
                                        rotaInicial(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        // color: Colors.pink,
                                        // padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: AppColors.principal,
                                            ),
                                            Text(
                                              'Como chegar',
                                              style: GoogleFonts.quicksand(
                                                fontSize: 11,
                                                color: AppColors.principal,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    Divider(color: Colors.black12),

                                    GestureDetector(
                                      onTap: () {
                                        rotaFinal(context);
                                      },
                                      child: Container(
                                        // color: Colors.pink,
                                        // padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          // crossAxisAlignment:
                                          //     CrossAxisAlignment.center,
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.show_chart,
                                              color: AppColors.principal,
                                            ),
                                            Text(
                                              'Começar percurso',
                                              style: GoogleFonts.quicksand(
                                                fontSize: 11,
                                                color: AppColors.principal,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Container(
                                    //   padding: EdgeInsets.symmetric(
                                    //       horizontal: 3, vertical: 1),
                                    //   decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.all(
                                    //       Radius.circular(24),
                                    //     ),
                                    //     border: Border.all(
                                    //         color: AppColors.principal),
                                    //   ),

                                    // child: Text(
                                    //   'Ver percurso',
                                    //   style: GoogleFonts.quicksand(
                                    //     fontSize: 14,
                                    //     color: AppColors.principal,
                                    //     fontWeight: FontWeight.w700,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // SizedBox(),
              // Divider(
              //   color: Colors.black12,
              //   height: 2,
              // ),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     GestureDetector(
              //       onTap: () {
              //         rotaInicial(context);
              //       },
              //       child: Container(
              //         color: Colors.white,
              //         padding: const EdgeInsets.all(8.0),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Text(
              //               'Como chegar',
              //               style: GoogleFonts.quicksand(
              //                 fontSize: 14,
              //                 color: AppColors.principal,
              //                 fontWeight: FontWeight.w700,
              //               ),
              //             ),
              //             Icon(
              //               Icons.location_on,
              //               color: AppColors.principal,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //     GestureDetector(
              //       onTap: () {
              //         rotaFinal(context);
              //       },
              //       child: Container(
              //         color: Colors.white,
              //         padding: const EdgeInsets.all(8.0),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Text(
              //               'Iniciar percurso',
              //               style: GoogleFonts.quicksand(
              //                 fontSize: 14,
              //                 color: AppColors.principal,
              //                 fontWeight: FontWeight.w700,
              //               ),
              //             ),
              //             Icon(
              //               Icons.show_chart,
              //               color: AppColors.principal,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ],
      ),
    );
  }
}
