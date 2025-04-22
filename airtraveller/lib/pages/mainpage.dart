import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'commentspage.dart';
import 'profile.dart';
import 'settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AirTraveller',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.indigo,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
            .copyWith(secondary: Colors.amberAccent),
      ),
      home: AirTravellerHomePage(),
    );
  }
}

class AirTravellerHomePage extends StatefulWidget {
  @override
  _AirTravellerHomePageState createState() => _AirTravellerHomePageState();
}

class _AirTravellerHomePageState extends State<AirTravellerHomePage> {
  int _selectedIndex = 0;

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
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.person, color: Colors.indigo),
                      title: Text('Profile'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                    userName: 'User Name',
                                    totalPoints: 100,
                                    feedbacks: [],
                                  )),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.settings, color: Colors.indigo),
                      title: Text('Definições'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.black),
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _onItemTapped(0), // Vai para o Mapa
              child: Text(
                'Mapa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      _selectedIndex == 0 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                // Navega para a página de comentários
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommentsPage(),
                  ),
                );
              }, // Vai para Comentários
              child: Text(
                'Comentários',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      _selectedIndex == 1 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: _selectedIndex == 0
          ? MapPage()
          : Container(), // Aqui o botão de Comentários já leva diretamente para a página de Comentários
    );
  }
}

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _controller;

  // Posição inicial do mapa (exemplo em San Francisco)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194), // Latitude e Longitude de exemplo
    zoom: 10,
  );

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: _initialPosition,
      onMapCreated: (GoogleMapController controller) {
        setState(() {
          _controller = controller;
        });
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }
}
