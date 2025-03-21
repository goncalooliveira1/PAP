import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
// import 'profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const AirTravellerHomePage({super.key});

  @override
  _AirTravellerHomePageState createState() => _AirTravellerHomePageState();
}

class _AirTravellerHomePageState extends State<AirTravellerHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AirTraveller')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapPage()),
                );
              },
              child: const Text('Ver Mapa'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CommentsPage()),
                );
              },
              child: const Text('Ver Comentários'),
            ),
          ],
        ),
      ),
    );
  }
}

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 10,
        ),
      ),
    );
  }
}

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _commentController = TextEditingController();
  final List<String> _comments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comentários')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_comments[index]),
                    ),
                  );
                },
              ),
            ),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: 'Escreva um comentário...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_commentController.text.isNotEmpty) {
                  setState(() {
                    _comments.add(_commentController.text);
                    _commentController.clear();
                  });
                }
              },
              child: const Text('Adicionar Comentário'),
            ),
          ],
        ),
      ),
    );
  }
}
