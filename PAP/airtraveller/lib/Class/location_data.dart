// location_data.dart
import 'package:latlong2/latlong.dart';
import 'dart:io';

class LocalMarker {
  final LatLng position;
  final String title;
  final String description;
  final List<File> images;
  final String? type;
  final List<String> comments;

  LocalMarker({
    required this.position,
    required this.title,
    required this.description,
    required this.images,
    this.type,
    this.comments = const [],
  });
}

class LocationData {
  static final LocationData _instance = LocationData._internal();

  factory LocationData() {
    return _instance;
  }

  LocationData._internal();

  final List<LocalMarker> createdLocations = [];

  void clearLocations() {
    createdLocations.clear();
  }

  // Método para adicionar um comentário a um local existente
  void addComment(LatLng position, String comment) {
    final index = createdLocations.indexWhere(
      (loc) => loc.position == position,
    );
    if (index != -1) {
      createdLocations[index] = createdLocations[index].copyWithNewComment(
        comment,
      );
    }
  }
}

extension on LocalMarker {
  LocalMarker copyWithNewComment(String newComment) {
    return LocalMarker(
      position: position,
      title: title,
      description: description,
      images: images,
      type: type,
      comments: [...comments, newComment],
    );
  }
}
