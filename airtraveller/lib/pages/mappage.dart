import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LeafletMapPage(),
    );
  }
}

class LeafletMapPage extends StatefulWidget {
  const LeafletMapPage({Key? key}) : super(key: key);

  @override
  _LeafletMapPageState createState() => _LeafletMapPageState();
}

class _LeafletMapPageState extends State<LeafletMapPage> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    WebView.platform =
        SurfaceAndroidWebView(); // Necessário para Android 12+ e versões mais recentes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaflet Map'),
      ),
      body: WebView(
        initialUrl: Uri.dataFromString(
          '''
          <!DOCTYPE html>
          <html lang="en">
          <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Leaflet Map</title>
            <link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" />
            <style>
              #map {
                height: 100%;
              }
            </style>
          </head>
          <body>
            <div id="map"></div>
            <script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js"></script>
            <script>
              var map = L.map('map').setView([51.505, -0.09], 13);
              L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
              }).addTo(map);
              L.marker([51.505, -0.09]).addTo(map)
                .bindPopup('A pretty CSS3 popup.<br> Easily customizable.')
                .openPopup();
            </script>
          </body>
          </html>
          ''',
          mimeType: 'text/html',
          encoding: Encoding.getByName('utf-8'),
        ).toString(),
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
        },
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
