import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'settings.dart'; // Certifica-te que tens este ficheiro com SettingsPage definida

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
  final List<String> monumentos = [
    'Parque D. Carlos I',
    'Museu José Malhoa',
    'Hospital Termal das Caldas',
    'Praça da Fruta',
    'Igreja Nossa Senhora do Pópulo',
    'Centro de Artes',
    'Ermida de São Sebastião',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
                    color: _selectedIndex == 0 ? Colors.black : Colors.white,
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
                    color: _selectedIndex == 1 ? Colors.black : Colors.white,
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
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CommentSearchDelegate(monumentos),
                );
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('Gonçalo'),
              accountEmail: Text('goncalo@email.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150',
                ),
              ),
              decoration: BoxDecoration(color: Colors.blueGrey),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      body: _selectedIndex == 0 ? const MapPage() : const FeedPage(),
    );
  }
}

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(39.4036, -9.1354),
        zoom: 15.0,
        minZoom: 3.0,
        maxZoom: 19.0,
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://api.maptiler.com/tiles/satellite-v2/{z}/{x}/{y}.jpg?key=sMVgxkL1jmZoQP53txBh",
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(39.4036, -9.1354),
              width: 40,
              height: 40,
              builder:
                  (context) => const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
            ),
            Marker(
              point: LatLng(39.4045, -9.1362), // Museu José Malhoa
              width: 40,
              height: 40,
              builder:
                  (context) => const Icon(
                    Icons.location_on,
                    color: Colors.blue,
                    size: 40,
                  ),
            ),
            Marker(
              point: LatLng(39.4050, -9.1340), // Hospital Termal
              width: 40,
              height: 40,
              builder:
                  (context) => const Icon(
                    Icons.local_hospital,
                    color: Colors.green,
                    size: 40,
                  ),
            ),
            Marker(
              point: LatLng(39.4030, -9.1350), // Praça da Fruta
              width: 40,
              height: 40,
              builder:
                  (context) =>
                      const Icon(Icons.store, color: Colors.orange, size: 40),
            ),
          ],
        ),
      ],
    );
  }
}

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final List<String> posts = [];
  final TextEditingController _controller = TextEditingController();

  void _addPost(String text) {
    if (text.isNotEmpty) {
      setState(() {
        posts.insert(0, text);
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Escreve uma recomendação...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _addPost(_controller.text),
              ),
            ],
          ),
        ),
        Expanded(
          child:
              posts.isEmpty
                  ? const Center(child: Text("Nenhuma recomendação ainda."))
                  : ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(posts[index]),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}

class CommentSearchDelegate extends SearchDelegate<String> {
  final List<String> monumentos;

  CommentSearchDelegate(this.monumentos);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results =
        monumentos
            .where(
              (monumento) =>
                  monumento.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.location_city),
          title: Text(results[index]),
          onTap: () => close(context, results[index]),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions =
        monumentos
            .where(
              (monumento) =>
                  monumento.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
}
