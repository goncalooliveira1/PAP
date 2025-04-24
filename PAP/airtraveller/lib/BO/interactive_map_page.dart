// interactive_map_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:latlong2/latlong.dart';
import 'package:airtraveller/Class/location_data.dart';

class InteractiveMapPage extends StatefulWidget {
  const InteractiveMapPage({super.key});

  @override
  State<InteractiveMapPage> createState() => _InteractiveMapPageState();
}

class _InteractiveMapPageState extends State<InteractiveMapPage> {
  late MapController _mapController;
  bool _isAdding = false;
  final ImagePicker _picker = ImagePicker();
  String? _newLocationType;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _isAdding = false;
    super.dispose();
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
    _newLocationType = null;

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
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Tipo de Local'),
                  value: _newLocationType,
                  items:
                      <String>[
                        'Monumento',
                        'Restaurante',
                        'Hotel',
                        'Outro',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _newLocationType = value;
                    });
                  },
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
                    if (title.isNotEmpty) {
                      final newLocalMarker = LocalMarker(
                        position: position,
                        title: title,
                        description: description,
                        images: _selectedImages,
                        type: _newLocationType,
                        comments: [], // Inicializa a lista de comentários aqui
                      );
                      LocationData().createdLocations.add(newLocalMarker);
                      print(
                        "Local guardado no Mapa Interativo: ${newLocalMarker.title}, ${newLocalMarker.position}, Tipo: ${_newLocationType}",
                      ); // DEBUG
                      Navigator.pop(ctx);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, adicione um título.'),
                        ),
                      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa Interativo')),
      body: Stack(
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
              // Não precisamos de MarkerLayer aqui se o objetivo é só criar
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
      ),
    );
  }
}
