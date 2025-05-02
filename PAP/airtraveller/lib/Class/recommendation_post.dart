// Class/recommendation_post.dart
import 'dart:io';

class RecommendationPost {
  String title;
  String description;
  String author;
  DateTime timestamp;
  int likes;
  File? image;
  // Adiciona uma lista para guardar os comentários da publicação
  List<String> comments;

  RecommendationPost({
    required this.title,
    required this.description,
    required this.author,
    DateTime? timestamp,
    this.likes = 0,
    this.image,
    this.comments =
        const [], // Inicializa a lista de comentários como vazia por padrão
  }) : timestamp = timestamp ?? DateTime.now();
}
