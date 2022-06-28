import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/core/controllers/rotas_controller.dart';
import 'package:appdalada/core/service/auth/auth_firebase_service.dart';
import 'package:appdalada/pages/home/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CreateRotaFinalPage extends StatefulWidget {
  final String refRota;
  const CreateRotaFinalPage({Key? key, required this.refRota})
      : super(key: key);

  @override
  State<CreateRotaFinalPage> createState() => _CreateRotaFinalPageState();
}

class _CreateRotaFinalPageState extends State<CreateRotaFinalPage> {
  double _lat = 0.0;
  double _long = 0.0;

  final controller = Get.put(RotasController());

  _onSubmit() async {
    await context
        .read<AuthFirebaseService>()
        .firestore
        .collection('rotas')
        .doc(widget.refRota)
        .update({
      'final_position': GeoPoint(_lat, _long),
    });

    controller.markers.clear();

    Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.principal,
        title: const Text('Rota Final'),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      body: GetBuilder<RotasController>(
        init: controller,
        builder: (value) => GoogleMap(
          mapType: MapType.normal,
          zoomControlsEnabled: true,
          initialCameraPosition: CameraPosition(
            target: controller.position,
            zoom: 13,
          ),
          onMapCreated: controller.onMapCreated,
          myLocationEnabled: true,
          markers: controller.markers,
          onTap: (LatLng latLng) {
            setState(() {
              _lat = latLng.latitude;
              _long = latLng.longitude;
            });

            controller.markers.add(
              Marker(
                markerId: MarkerId('refRota'),
                position: LatLng(latLng.latitude, latLng.longitude),
                infoWindow: InfoWindow(title: 'Ponto final'),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _onSubmit();
        },
        label: Text('Salvar'),
        backgroundColor: AppColors.principal,
        icon: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
