// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chat.dart';

class MatchesPage extends StatefulWidget {
  @override
  _MatchesPageState createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  late final CollectionReference _userProfiles;
  // Assuming the current user's preferences are already fetched and stored
  // You will need to replace currentUserPreferences with actual data
  final Map<String, String> currentUserPreferences = {
    'sleepingHabit': 'Early bird',
    'smokingHabit': 'Non-smoker',
    'timeInDorm': 'Sometimes'
  };

  @override
  void initState() {
    super.initState();
    _userProfiles = FirebaseFirestore.instance.collection('userProfiles');
  }

  Stream<List<UserProfile>> _getMatches() {
    return _userProfiles.snapshots().map((snapshot) {
      final userProfiles = snapshot.docs.map((doc) {
        return UserProfile.fromSnapshot(doc);
      }).toList();

      // Calculate match score for each profile and sort them
      userProfiles.sort((a, b) =>
          _calculateMatchScore(b, currentUserPreferences)
              .compareTo(_calculateMatchScore(a, currentUserPreferences)));

      return userProfiles; // Make sure to return the sorted list
    });
  }

  int _calculateMatchScore(
      UserProfile profile, Map<String, String> preferences) {
    int score = 0;
    if (profile.sleepingHabit == preferences['sleepingHabit']) score += 1;
    if (profile.smokingHabit == preferences['smokingHabit']) score += 1;
    if (profile.timeInDorm == preferences['timeInDorm']) score += 1;
    return score;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Matches'),
      ),
      body: StreamBuilder<List<UserProfile>>(
        stream: _getMatches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching matches'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No matches found'));
          }

          final matches = snapshot.data!;
          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              final matchScore =
                  _calculateMatchScore(match, currentUserPreferences);
              return ListTile(
                leading:
                    CircleAvatar(backgroundImage: NetworkImage(match.imageUrl)),
                title: Text(match.name),
                subtitle: Text(
                    'Match: ${matchScore * 33}%'), // Example score calculation
                trailing: ElevatedButton(
                  onPressed: () {
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => ChatScreen()),
                    // );
                  },
                  child: Text('Chat'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class UserProfile {
  final String imageUrl;
  final String name;
  final String sleepingHabit;
  final String smokingHabit;
  final String timeInDorm;

  UserProfile({
    required this.imageUrl,
    required this.name,
    required this.sleepingHabit,
    required this.smokingHabit,
    required this.timeInDorm,
  });

  factory UserProfile.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserProfile(
      imageUrl: data['ImageUrl'],
      name: data['Name'],
      sleepingHabit: data['sleepingHabit'],
      smokingHabit: data['smokingHabit'],
      timeInDorm: data['timeInDorm'],
    );
  }
}
