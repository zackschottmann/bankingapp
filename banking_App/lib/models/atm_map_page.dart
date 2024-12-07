import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class ATMMapPage extends StatelessWidget {
  final List<MapLatLng> atmLocations = [
    const MapLatLng(37.7749, -122.4194), // Example: San Francisco
    const MapLatLng(34.0522, -118.2437), // Example: Los Angeles
    const MapLatLng(40.7128, -74.0060),  // Example: New York City
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
            initialZoomLevel: 5,
            initialFocalLatLng: const MapLatLng(37.7749, -122.4194), // Center map on a location
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
