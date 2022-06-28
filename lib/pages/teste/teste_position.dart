import 'package:appdalada/core/controllers/rotas_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class TestePosition extends StatefulWidget {
  const TestePosition({Key? key}) : super(key: key);

  @override
  State<TestePosition> createState() => _TestePositionState();
}

class _TestePositionState extends State<TestePosition> {
  final controller = Get.put(RotasController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
            'StartPoint Latitude: ${controller.startLat} and Longitude: ${controller.startLong}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
