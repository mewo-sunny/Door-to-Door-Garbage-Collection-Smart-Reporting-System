import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const LatLng _center = LatLng(37.4219999, -122.0840575);

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('bin1'),
      position: LatLng(37.4219999, -122.0840575),
      infoWindow: InfoWindow(title: 'Garbage Bin 1', snippet: 'Full'),
    ),
    const Marker(
      markerId: MarkerId('bin2'),
      position: LatLng(37.421800, -122.085000),
      infoWindow: InfoWindow(title: 'Garbage Bin 2', snippet: 'Almost Empty'),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map of Bins')),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: const CameraPosition(
          target: _center,
          zoom: 14.0,
        ),
        markers: _markers,
      ),
    );
  }
}
