import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class LocalMarker {
  final LatLng position;
  final String title;
  final String description;
  final List<File> images;

  LocalMarker({
    required this.position,
    required this.title,
    required this.description,
    required this.images,
  });
}

class _MapPageState extends State<MapPage> {
  List<LocalMarker> localMarkers = [];
  late MapController _mapController;
  bool _isAdding = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  void _handleMapTap(LatLng latlng) {
    if (_isAdding) {
      _isAdding = false;
      _openAddModal(latlng);
    }
  }

  void _openAddModal(LatLng position) {
    String title = '';
    String description = '';
    List<File> _selectedImages = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Novo Local',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Título'),
                  onChanged: (val) => title = val,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  onChanged: (val) => description = val,
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.photo),
                  label: const Text('Adicionar fotos'),
                  onPressed: () async {
                    final picked = await _picker.pickMultiImage();
                    if (picked != null) {
                      setState(() {
                        _selectedImages =
                            picked.map((e) => File(e.path)).toList();
                      });
                    }
                  },
                ),
                if (_selectedImages.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: _selectedImages.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemBuilder:
                          (_, index) => ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _selectedImages[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                    ),
                  ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (title.isNotEmpty ||
                        description.isNotEmpty ||
                        _selectedImages.isNotEmpty) {
                      setState(() {
                        localMarkers.add(
                          LocalMarker(
                            position: position,
                            title: title,
                            description: description,
                            images: _selectedImages,
                          ),
                        );
                      });
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text("Guardar Local"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMarkerDetails(LocalMarker marker) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                marker.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(marker.description),
              const SizedBox(height: 10),
              if (marker.images.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: marker.images.length,
                    itemBuilder:
                        (_, index) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              marker.images[index],
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: LatLng(39.4036, -9.1354),
            zoom: 13.0,
            minZoom: 3.0,
            maxZoom: 19.0,
            onTap: (_, latlng) => _handleMapTap(latlng),
          ),
          children: [
            TileLayer(
              urlTemplate:
                  "https://api.maptiler.com/tiles/satellite-v2/{z}/{x}/{y}.jpg?key=sMVgxkL1jmZoQP53txBh",
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(
              markers:
                  localMarkers
                      .map(
                        (marker) => Marker(
                          point: marker.position,
                          width:
                              60, // Aumentei um pouco o tamanho para caber a foto
                          height: 60,
                          builder:
                              (ctx) => GestureDetector(
                                onTap: () => _showMarkerDetails(marker),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.blue,
                                      size: 40,
                                    ),
                                    if (marker.images.isNotEmpty)
                                      Positioned(
                                        bottom: 0,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: Image.file(
                                              marker.images.first,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                _isAdding = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Toca no mapa para adicionar um local"),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
