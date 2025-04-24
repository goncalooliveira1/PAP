import 'dart:io';

class RecommendationPost {
  final String title;
  final String description;
  final File? image;
  final String author;
  final List<String> comments; // Adiciona uma lista de comentários ao post

  RecommendationPost({
    required this.title,
    required this.description,
    this.image,
    required this.author,
    this.comments = const [], // Inicializa a lista de comentários como vazia
  });
}
