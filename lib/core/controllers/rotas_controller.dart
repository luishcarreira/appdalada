import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RotasController extends GetxController {
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  LatLng _position = LatLng(-23.571505, -46.689104);
  GoogleMapController? _mapsController;

  final markers = Set<Marker>();

  static RotasController get to => Get.find<RotasController>();

  get mapsController => _mapsController;
  get position => _position;

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    getPosicao();
    //loadAnimais(/*filtro*/);
  }

  loadAnimais(/*String filtro*/) async {
    //if (filtro != '') {
    /*final animais = await firestore
        .collection('rotas')
        .where('refAnimal',
            isEqualTo: 'Wyr7GZgCqNnNr84tbU7s') //referecia ou cod animal
        .get();

    markers.clear();
    animais.docs.forEach((element) => addMarker(element));*/
    //} else {
    // print('vazio');
    //}
  }

  addMarker(element) async {
    GeoPoint point = element.get('position.geopoint');

    markers.add(
      Marker(
        markerId: MarkerId(element.id),
        position: LatLng(point.latitude, point.longitude),
        infoWindow: InfoWindow(title: element.get('nome')),
        onTap: () => showDetails(element),
      ),
    );
    update();
  }

  showDetails(element) {
    /*Get.bottomSheet(
      OngDetalhes(
        nome: element.get('nome'),
      ),
      barrierColor: Colors.transparent,
    );*/
  }

  Future<Position> _posicaoAtual() async {
    LocationPermission permissao;
    bool ativado = await Geolocator.isLocationServiceEnabled();

    if (!ativado) {
      return Future.error('Por favor, habilite a localização no smartphone.');
    }

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();

      if (permissao == LocationPermission.denied) {
        return Future.error('Você precisa autorizar o acesso à localização.');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      return Future.error('Autorize o acesso à localização nas configurações.');
    }

    return await Geolocator.getCurrentPosition();
  }

  getPosicao() async {
    try {
      final posicao = await _posicaoAtual();
      latitude.value = posicao.latitude;
      longitude.value = posicao.longitude;
      _mapsController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(latitude.value, longitude.value),
        ),
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        e.toString(),
        backgroundColor: Colors.grey[900],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
