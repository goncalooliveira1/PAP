import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String userName;
  final int totalPoints;
  final List<String> feedbacks;

  const ProfilePage({
    super.key,
    required this.userName,
    required this.totalPoints,
    required this.feedbacks,
  });

  String _getUserRank() {
    if (totalPoints < 50) {
      return "Novato";
    } else if (totalPoints < 100) {
      return "Intermediário";
    } else {
      return "Experiente";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Perfil"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.start, // Mantém os elementos no topo
          crossAxisAlignment:
              CrossAxisAlignment.center, // Centraliza horizontalmente
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Text(
                userName[0],
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            Text(
              userName,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "Rank: ${_getUserRank()}",
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pontos: $totalPoints",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Feedbacks:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    ...feedbacks.map(
                      (feedback) => ListTile(
                        leading: Icon(Icons.feedback, color: Colors.blue),
                        title: Text(feedback, style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    if (feedbacks.isEmpty)
                      Text(
                        "Nenhum feedback ainda.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
