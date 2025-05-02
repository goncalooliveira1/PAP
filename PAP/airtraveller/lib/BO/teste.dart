// main.dart
import 'package:airtraveller/Class/location_data.dart';
import 'package:airtraveller/Class/recommendation_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'settings.dart';
import 'interactive_map_page.dart';
import 'package:airtraveller/Class/location_data.dart';
import 'package:airtraveller/Class/recommendation_post.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(
    'pt_PT',
    null,
  ).then((_) => runApp(const MyApp()));
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
      floatingActionButton:
          _selectedIndex == 0
              ? FloatingActionButton(
                onPressed: () => _navigateToAddLocation(context),
                child: const Icon(Icons.add),
              )
              : null,
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
                const SizedBox(width: 8.0),
                InkWell(
                  onTap: _addComment,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FeedPage extends StatefulWidget {
  FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final TextEditingController _postController = TextEditingController();
  final List<RecommendationPost> _posts = [];
  final String _currentUser = "Você";
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      } else {
        print('Nenhuma imagem selecionada.');
      }
    });
  }

  void _addPost(String text) {
    if (text.isNotEmpty || _selectedImage != null) {
      setState(() {
        _posts.insert(
          0,
          RecommendationPost(
            title: "",
            description: text,
            author: _currentUser,
            image: _selectedImage,
          ),
        );
        _postController.clear();
        _selectedImage = null;
      });
    }
  }

  void _likePost(int index) {
    setState(() {
      _posts[index].likes++;
    });
  }

  void _deletePost(int index) {
    setState(() {
      if (_posts[index].author == _currentUser) {
        _posts.removeAt(index);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não pode apagar esta publicação.')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(icon: const Icon(Icons.image), onPressed: _pickImage),
              Expanded(
                child: TextField(
                  controller: _postController,
                  decoration: const InputDecoration(
                    hintText: "No que está a pensar?",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                ),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () => _addPost(_postController.text),
                child: const Text("Publicar"),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _posts.length,
            itemBuilder: (context, index) {
              final post = _posts[index];
              final formattedTime = DateFormat(
                'dd '
                    'de '
                    'MMMM'
                    ' às '
                    'HH:mm',
                'pt_PT',
              ).format(post.timestamp);

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            child: Icon(Icons.person),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      post.author,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (post.author == _currentUser)
                                      PopupMenuButton<String>(
                                        onSelected: (value) {
                                          if (value == 'delete') {
                                            _deletePost(index);
                                          }
                                        },
                                        itemBuilder:
                                            (BuildContext context) =>
                                                <PopupMenuEntry<String>>[
                                                  const PopupMenuItem<String>(
                                                    value: 'delete',
                                                    child: Text('Apagar'),
                                                  ),
                                                ],
                                        child: const Icon(Icons.more_horiz),
                                      ),
                                  ],
                                ),
                                Text(
                                  formattedTime,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (post.description.isNotEmpty) ...[
                        const SizedBox(height: 8.0),
                        Text(post.description),
                      ],
                      if (post.image != null) ...[
                        const SizedBox(height: 8.0),
                        Image.file(post.image!),
                      ],
                      const SizedBox(height: 12.0),
                      const Divider(thickness: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                TextButton.icon(
                                  onPressed: () => _likePost(index),
                                  icon: const Icon(
                                    Icons.thumb_up,
                                    color: Colors.blue,
                                  ),
                                  label: Text("${post.likes}"),
                                ),
                                const SizedBox(width: 8.0),
                                TextButton.icon(
                                  onPressed: () {
                                    // Lógica para comentar
                                    print(
                                      "Comentar na publicação de ${post.author}",
                                    );
                                  },
                                  icon: const Icon(Icons.chat_bubble_outline),
                                  label: const Text("Comentar"),
                                ),
                              ],
                            ),
                            const SizedBox(width: 4.0),
                          ],
                        ),
                      ),
                      const Divider(thickness: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          children: [
                            ...post.comments.asMap().entries.map((entry) {
                              final idx = entry.key;
                              final comment = entry.value;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 14,
                                        child: Icon(Icons.person, size: 16),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Expanded(child: Text(comment)),
                                      TextButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              final TextEditingController
                                              _replyController =
                                                  TextEditingController();
                                              return AlertDialog(
                                                title: const Text(
                                                  'Responder Comentário',
                                                ),
                                                content: TextField(
                                                  controller: _replyController,
                                                  decoration:
                                                      const InputDecoration(
                                                        hintText:
                                                            'Digite sua resposta',
                                                      ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                    },
                                                    child: const Text(
                                                      'Cancelar',
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      if (_replyController
                                                          .text
                                                          .isNotEmpty) {
                                                        setState(() {
                                                          post.comments.add(
                                                            "↳ ${_replyController.text}",
                                                          );
                                                        });
                                                        Navigator.of(
                                                          context,
                                                        ).pop();
                                                      }
                                                    },
                                                    child: const Text(
                                                      'Responder',
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: const Text('Responder'),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                ],
                              );
                            }),
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 14,
                                  child: Icon(Icons.person, size: 16),
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      hintText: 'Escreva um comentário...',
                                      border: InputBorder.none,
                                    ),
                                    onSubmitted: (value) {
                                      if (value.isNotEmpty && mounted) {
                                        setState(() {
                                          post.comments.add(value);
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
