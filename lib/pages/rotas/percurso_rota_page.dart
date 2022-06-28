import 'package:appdalada/core/controllers/rotas_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final controller = Get.put(RotasController());

  double startLat = -20.8093773;
  double startLong = -49.346889;
  double endLat = -20.8068968;
  double endLong = -49.3528858;

  Set<Marker> markers = {};

  _createMarkers() {
    // Start Location Marker
    Marker startMarker = Marker(
      markerId: MarkerId('start'),
      position: LatLng(startLat, startLong), //-20.8093773,-49.346889
      infoWindow: InfoWindow(
        title: 'Start',
        //snippet: _startAddress,
      ),
      icon: BitmapDescriptor.defaultMarker,
    );

    // Destination Location Marker
    Marker destinationMarker = Marker(
      markerId: MarkerId('final'),
      position: LatLng(endLat, endLong), //-20.7603956,-49.416106
      infoWindow: InfoWindow(
        title: 'Destination',
        //snippet: _destinationAddress,
      ),
      icon: BitmapDescriptor.defaultMarker,
    );

    setState(() {
      markers.add(startMarker);
      markers.add(destinationMarker);
    });
  }

  // Object for PolylinePoints
  late PolylinePoints polylinePoints;

// List of coordinates to join
  List<LatLng> polylineCoordinates = [];

// Map storing polylines created by connecting two points
  Map<PolylineId, Polyline> polylines = {};

  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyBq9eem4NHWHOB6YARuVVRKBeBA3aUOuso', // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.driving,
    );

    print(result.points);

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      print('certo');
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print('errado');
    }

    // Adding the polyline to the map
    setState(() {
      // Defining an ID
      PolylineId id = PolylineId('poly');

      // Initializing Polyline
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates,
        width: 3,
      );
      polylines[id] = polyline;
    });
  }

  buscarRota() {
    _createMarkers();
    _createPolylines(startLat, startLong, endLat, endLong);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Teste'),
          actions: [
            IconButton(
              onPressed: () {
                buscarRota();
              },
              icon: Icon(Icons.check),
            )
          ],
        ),
        body: GoogleMap(
          initialCameraPosition:
              CameraPosition(target: controller.position, zoom: 15),
          myLocationEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          onMapCreated: controller.onMapCreated,
          markers: Set<Marker>.from(markers),
          polylines: Set<Polyline>.of(polylines.values),
        ),
      ),
    );
  }
}
