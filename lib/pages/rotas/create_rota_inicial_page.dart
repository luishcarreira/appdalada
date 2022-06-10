import 'package:appdalada/core/app/app_colors.dart';
import 'package:appdalada/core/controllers/rotas_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateRotaInicialPage extends StatefulWidget {
  const CreateRotaInicialPage({Key? key}) : super(key: key);

  @override
  State<CreateRotaInicialPage> createState() => _CreateRotaInicialPageState();
}

class _CreateRotaInicialPageState extends State<CreateRotaInicialPage> {
  TextEditingController _lat = TextEditingController();
  TextEditingController _long = TextEditingController();

  final controller = Get.put(RotasController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.principal,
        title: const Text('Rota Inicial'),
        centerTitle: true,
        toolbarHeight: 150,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: Column(
              children: [
                TextFormField(
                  controller: _lat,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 15, 0),
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Icon(Icons.search),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _long,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 15, 0),
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Icon(Icons.search),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
            //_markers.add(Marker(markerId: MarkerId('mark'), position: latLng));
            setState(() {
              print(latLng);
            });
          },
        ),
      ),
    );
  }
}
