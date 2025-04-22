import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'CommentsPage.dart';
import 'profile.dart';
import 'settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AirTraveller',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 12, 41, 206),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo,
        ).copyWith(secondary: Colors.amberAccent),
      ),
      home: const AirTravellerHomePage(),
    );
  }
}

class AirTravellerHomePage extends StatefulWidget {
  const AirTravellerHomePage({super.key});

  @override
  _AirTravellerHomePageState createState() => _AirTravellerHomePageState();
}

class _AirTravellerHomePageState extends State<AirTravellerHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const EmbeddedMap(),
    const CommentsPage(),
  ];

  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 12, 41, 206),
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person,
                  color: Color.fromARGB(255, 12, 41, 206)),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(
                      userName: 'User Name',
                      totalPoints: 100,
                      feedbacks: [],
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings,
                  color: Color.fromARGB(255, 12, 41, 206)),
              title: const Text('Definições'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
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
                      _selectedIndex == 0 ? FontWeight.bold : FontWeight.normal,
                  color: _selectedIndex == 0 ? Colors.white : Colors.white70,
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
                      _selectedIndex == 1 ? FontWeight.bold : FontWeight.normal,
                  color: _selectedIndex == 1 ? Colors.white : Colors.white70,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PlaceSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Coloca os botões no topo do corpo
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _onItemTapped(0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedIndex == 0
                          ? Colors.blue
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Mapa',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: _selectedIndex == 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color:
                            _selectedIndex == 0 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () => _onItemTapped(1),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedIndex == 1
                          ? Colors.blue
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Recomendações',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: _selectedIndex == 1
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color:
                            _selectedIndex == 1 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Corpo da tela com o conteúdo dependendo do botão selecionado
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500), // Tempo da animação
              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}

class EmbeddedMap extends StatelessWidget {
  const EmbeddedMap({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: MapController(),
      options: const MapOptions(
        initialCenter: LatLng(39.4036, -9.1354), // Caldas da Rainha
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://api.maptiler.com/tiles/hillshade/{z}/{x}/{y}.png?key=sMVgxkL1jmZoQP53txBh",
          subdomains: ['a', 'b', 'c'],
          userAgentPackageName: 'com.example.app',
        ),
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
    );
  }
}

// ===========================
// Search Delegate funcional
// ===========================

final List<Map<String, dynamic>> searchItems = [
  {'name': 'Parque D. Carlos I 🏛️', 'type': 'monument'},
  {'name': 'Hospital Termal 🏛️', 'type': 'monument'},
  {'name': 'Museu José Malhoa 🏛️', 'type': 'monument'},
  {'name': 'Centro Cultural e de Congressos 🏛️', 'type': 'monument'},
  {'name': 'Chafariz das Cinco Bicas 🏛️', 'type': 'monument'},
  {'name': 'Estátua da Rainha D. Leonor 🏛️', 'type': 'monument'},
];

class PlaceSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
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
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = searchItems.where(
      (item) => item['name'].toLowerCase().contains(query.toLowerCase()),
    );

    return ListView(
      children: results
          .map(
            (item) => ListTile(
              title: Text(item['name']),
              onTap: () {
                close(context, item['name']);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selecionado: ${item['name']}')),
                );
              },
            ),
          )
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = searchItems.where(
      (item) => item['name'].toLowerCase().contains(query.toLowerCase()),
    );

    return ListView(
      children: suggestions
          .map(
            (item) => ListTile(
              title: Text(item['name']),
              onTap: () {
                query = item['name'];
                showResults(context);
              },
            ),
          )
          .toList(),
    );
  }
}
