import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AtmMapPage extends StatefulWidget {
  const AtmMapPage({super.key});

  @override
  _AtmMapPageState createState() => _AtmMapPageState();
}

class _AtmMapPageState extends State<AtmMapPage> {
  late GoogleMapController _mapController;

  // Set initial camera position
  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(43.65107, -79.347015), // Example: Toronto, Canada
    zoom: 12,
  );

  // List of sample ATM markers
  final List<Marker> _atmMarkers = [
    const Marker(
      markerId: MarkerId('atm1'),
      position: LatLng(43.653225, -79.383186), // Example: Toronto ATM 1
      infoWindow: InfoWindow(title: "ATM 1", snippet: "123 Main St"),
    ),
    const Marker(
      markerId: MarkerId('atm2'),
      position: LatLng(43.65107, -79.347015), // Example: Toronto ATM 2
      infoWindow: InfoWindow(title: "ATM 2", snippet: "456 Queen St"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby ATMs"),
      ),
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        markers: Set<Marker>.of(_atmMarkers),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
