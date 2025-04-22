import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Tema claro para um visual normal
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mapa 3D")),
      body: FlutterMap(
        mapController: MapController(),
        options: const MapOptions(
          initialCenter: LatLng(39.4036, -9.1354), // Caldas da Rainha
          initialZoom: 13.0,
        ),
        children: [
          // Camada de sombreamento de relevo para efeito 3D
          TileLayer(
            urlTemplate:
                "https://api.maptiler.com/tiles/hillshade/{z}/{x}/{y}.png?key=sMVgxkL1jmZoQP53txBh",
            subdomains: ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.app',
          ),
          // Camada de mapa satélite
          TileLayer(
            urlTemplate:
                "https://api.maptiler.com/tiles/satellite/{z}/{x}/{y}.jpg?key=sMVgxkL1jmZoQP53txBh",
            subdomains: ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(39.4036, -9.1354),
                width: 80,
                height: 80,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
