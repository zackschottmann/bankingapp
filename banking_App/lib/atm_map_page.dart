import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class ATMMapPage extends StatelessWidget {
  final List<MapLatLng> atmLocations = [
    MapLatLng(43.4643, -80.5204), 
    MapLatLng(43.4668, -80.5222), 
    MapLatLng(43.4503, -80.5255), 
    MapLatLng(43.4743, -80.5438), 
    MapLatLng(43.4621, -80.4955),
    MapLatLng(43.4535, -80.4920), 
    MapLatLng(43.4823, -80.5442), 
    MapLatLng(43.4750, -80.5127), 
    MapLatLng(43.4617, -80.5209),
    MapLatLng(43.4562, -80.5075),
  ];

 ATMMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ATM Locations'),
      ),
      body: SfMaps(
        layers: [
          MapTileLayer(
            urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OpenStreetMap tiles
            initialZoomLevel: 13,
            initialFocalLatLng: const MapLatLng(43.4643, -80.5204), // Center map on a location
            zoomPanBehavior: MapZoomPanBehavior(),
            markerBuilder: (BuildContext context, int index) {
              return MapMarker(
                latitude: atmLocations[index].latitude,
                longitude: atmLocations[index].longitude,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 30,
                ),
              );
            },
            initialMarkersCount: atmLocations.length,
          ),
        ],
      ),
    );
  }
}
