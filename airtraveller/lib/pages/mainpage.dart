import 'package:flutter/material.dart';
import 'CommentsPage.dart';
import 'mappage.dart'; // Import the MapPage class
import 'profile.dart';
import 'settings.dart';

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
        primaryColor: const Color.fromARGB(255, 12, 41, 206),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo,
        ).copyWith(secondary: Colors.amberAccent),
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 12, 41, 206),
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: const Color.fromARGB(255, 12, 41, 206),
              ),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ProfilePage(
                          userName:
                              'User Name', // Replace with actual user name
                          totalPoints: 100, // Replace with actual total points
                          feedbacks: [], // Replace with actual feedbacks list
                        ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: const Color.fromARGB(255, 12, 41, 206),
              ),
              title: Text('Definições'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapScreen()),
                );
              },
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
                try {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CommentsPage()),
                  );
                } catch (e) {
                  print("Erro ao abrir CommentsPage: \$e");
                }
              },
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
      body: Container(),
    );
  }
}
