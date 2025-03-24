import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String userName;
  final int totalPoints;
  final List<String> feedbacks;

  ProfilePage({
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
      appBar: AppBar(
        title: Text('$userName\'s Profile'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildUserInfo(),
            SizedBox(height: 20),
            _buildUserRank(),
            SizedBox(height: 20),
            _buildUserFeedbacks(),
            SizedBox(height: 20),
            _buildUserPoints(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nome de Usuário: $userName',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'Feedbacks:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildUserRank() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Rank: ${_getUserRank()}', style: TextStyle(fontSize: 18)),
      ],
    );
  }

  Widget _buildUserFeedbacks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...feedbacks.map((feedback) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text('- $feedback', style: TextStyle(fontSize: 16)),
          );
        }).toList(),
        if (feedbacks.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Nenhum feedback ainda.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
      ],
    );
  }

  Widget _buildUserPoints() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text('Pontos: $totalPoints', style: TextStyle(fontSize: 18))],
    );
  }
}
