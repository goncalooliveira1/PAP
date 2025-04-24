// main.dart
import 'package:airtraveller/Class/location_data.dart';
import 'package:airtraveller/Class/recommendation_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'settings.dart';
import 'interactive_map_page.dart';
import 'package:airtraveller/Class/location_data.dart';
import 'package:airtraveller/Class/recommendation_post.dart'; // Importa o modelo do post

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const MainPage(),
      routes: {'/settings': (context) => const SettingsPage()},
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    LocationData().clearLocations();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToAddLocation(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InteractiveMapPage()),
    );
  }

  void _navigateToLocationDetail(BuildContext context, LocalMarker location) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationDetailPage(location: location),
      ),
    );
  }

  IconData _getIconForType(String? type) {
    switch (type) {
      case 'Monumento':
        return Icons.flag;
      case 'Restaurante':
        return Icons.restaurant;
      case 'Hotel':
        return Icons.hotel;
      default:
        return Icons.location_on;
    }
  }

  Widget _buildMapPage() {
    final locationData = LocationData();
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(center: LatLng(39.4036, -9.1354), zoom: 13.0),
      children: [
        TileLayer(
          urlTemplate:
              "https://api.maptiler.com/tiles/satellite-v2/{z}/{x}/{y}.jpg?key=sMVgxkL1jmZoQP53txBh",
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers:
              locationData.createdLocations.map((location) {
                print(
                  "A construir marcador para: ${location.title}, ${location.position}, Tipo: ${location.type}",
                ); // DEBUG
                return Marker(
                  point: location.position,
                  width: 120,
                  height: 60,
                  builder:
                      (context) => GestureDetector(
                        onTap:
                            () => _navigateToLocationDetail(context, location),
                        child: Column(
                          children: [
                            Icon(
                              _getIconForType(location.type),
                              color: Colors.red,
                              size: 30,
                            ),
                            if (location.title.isNotEmpty)
                              Text(
                                location.title,
                                style: const TextStyle(
                                  fontSize: 12,
                                  backgroundColor: Colors.white70,
                                ),
                                textAlign: TextAlign.center,
                              ),
                          ],
                        ),
                      ),
                );
              }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _onItemTapped(0),
                child: Text(
                  'Mapa',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        _selectedIndex == 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                    color:
                        _selectedIndex == 0 ? Colors.black : Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () => _onItemTapped(1),
                child: Text(
                  'Recomendações',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        _selectedIndex == 1
                            ? FontWeight.bold
                            : FontWeight.normal,
                    color:
                        _selectedIndex == 1 ? Colors.black : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.black),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildMapPage(),
          FeedPage(), // Usa o FeedPage atualizado
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddLocation(context),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'AirTraveller',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Mapa'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Recomendações'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LocationDetailPage extends StatefulWidget {
  final LocalMarker location;

  const LocationDetailPage({super.key, required this.location});

  @override
  State<LocationDetailPage> createState() => _LocationDetailPageState();
}

class _LocationDetailPageState extends State<LocationDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  List<String> _currentComments = [];

  @override
  void initState() {
    super.initState();
    _currentComments = List.from(widget.location.comments);
  }

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        _currentComments.add(_commentController.text);
        LocationData().addComment(
          widget.location.position,
          _commentController.text,
        );
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.location.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.location.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (widget.location.images.isNotEmpty)
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.location.images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          widget.location.images[index],
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (widget.location.images.isEmpty)
              const Text('Nenhuma foto adicionada.'),
            const SizedBox(height: 20),
            Text(widget.location.description),
            const SizedBox(height: 20),
            const Text(
              'Comentários',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _currentComments.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(_currentComments[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      labelText: 'Adicionar comentário',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addComment,
                  child: const Text('Enviar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FeedPage extends StatelessWidget {
  FeedPage({super.key});

  // Dados de exemplo para os posts
  final List<RecommendationPost> _posts = [
    RecommendationPost(
      title: "Melhor vista da cidade",
      description:
          "Não percam o pôr do sol deste miradouro! Simplesmente espetacular.",
      author: "Ana Silva",
    ),
    RecommendationPost(
      title: "Restaurante imperdível",
      description:
          "Experimentei o novo restaurante italiano e adorei a massa fresca.",
      author: "Pedro Gomes",
    ),
    RecommendationPost(
      title: "Aventura na montanha",
      description:
          "A trilha até ao pico é desafiadora mas a recompensa é incrível.",
      author: "Mariana Costa",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(post.description),
                const SizedBox(height: 8.0),
                Text(
                  "Publicado por: ${post.author}",
                  style: const TextStyle(color: Colors.grey),
                ),
                // Adicionar aqui a lógica para exibir a imagem do post, se existir
              ],
            ),
          ),
        );
      },
    );
  }
}
