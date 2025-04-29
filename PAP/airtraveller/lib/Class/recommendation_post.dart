import 'dart:io';

class RecommendationPost {
  String title;
  String description;
  String author;
  DateTime timestamp;
  int likes;
  File? image;

  RecommendationPost({
    required this.title,
    required this.description,
    required this.author,
    DateTime? timestamp,
    this.likes = 0,
    this.image,
  }) : timestamp = timestamp ?? DateTime.now();
}
