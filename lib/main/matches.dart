// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, curly_braces_in_flow_control_structures, unnecessary_brace_in_string_interps
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

import 'chat.dart';
import 'list_chat.dart';
import 'main_page.dart';
import 'my_profile.dart';

class MatchesPage extends StatefulWidget {
  @override
  _MatchesPageState createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  late final CollectionReference _userProfiles;
  late final FirebaseFirestore _firestore;
  int _selectedIndex = 1;
  late final String currentUserId;

  Map<String, String> currentUserPreferences = {};

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _userProfiles = FirebaseFirestore.instance.collection('userProfiles');
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    _fetchCurrentUserPreferences();
  }

  Future<void> _fetchCurrentUserPreferences() async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('userProfiles').doc(currentUserId).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      setState(() {
        // Update preferences directly from the database values
        currentUserPreferences['sleepingHabit'] =
            data['roommatePreferenceSleep'] == "Early bird"
                ? "Early bird"
                : "Night Owl";
        currentUserPreferences['smokingHabit'] =
            data['roommatePreferenceSmoking'] == "Smoker"
                ? "Smoker"
                : "Non-smoker";
        currentUserPreferences['timeInDorm'] =
            data['roommatePreferenceDormTime'] == "All the time"
                ? "All the time"
                : "sometimes";
        // The nationality preference is not included in the score calculation
      });
    } catch (e) {
      print("Error fetching user preferences: $e");
      // Handle the error or set default preferences
    }
  }

  Stream<List<UserProfile>> _getMatches() {
    return _firestore
        .collection('matches')
        .where('userIds', arrayContains: currentUserId)
        .snapshots()
        .asyncMap((QuerySnapshot matchSnapshot) async {
      List<UserProfile> matchedProfiles = [];

      // Loop through all match documents.
      for (var matchDoc in matchSnapshot.docs) {
        final matchData = matchDoc.data() as Map<String, dynamic>;
        final otherUserId = (matchData['userIds'] as List)
            .firstWhere((id) => id != currentUserId);

        // Get user profile details from the 'userProfiles' collection.
        final userProfileSnapshot =
            await _firestore.collection('userProfiles').doc(otherUserId).get();
        final userData = userProfileSnapshot.data() as Map<String, dynamic>?;

        // If user profile exists, add to the list.
        if (userData != null) {
          matchedProfiles.add(UserProfile(
            documentId: otherUserId,
            imageUrl: userData['ImageUrl'] ?? 'https://via.placeholder.com/150',
            name: userData['Name'] ?? 'Unavailable',
            matchPercentage: matchData['matchPercentage']?.toDouble() ?? 0.0,
          ));
        }
      }

      return matchedProfiles;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else if (index == 1) {
      // No action needed as we are already on the Matches page
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyChatsScreen()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Matches'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          },
        ),
      ),
      body: StreamBuilder<List<UserProfile>>(
        stream: _getMatches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No matches found'));
          }
          final matches = snapshot.data!;
          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(match.imageUrl),
                  backgroundColor: Colors.transparent,
                ),
                title: Text(match.name),
                subtitle:
                    Text('Match: ${match.matchPercentage.toStringAsFixed(0)}%'),
                trailing: ElevatedButton(
                  onPressed: () {
                    // You would handle the chat logic here
                  },
                  child: Text('Chat'),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Matches'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class UserProfile {
  final String documentId;
  final String imageUrl;
  final String name;
  final double matchPercentage;

  UserProfile({
    required this.documentId,
    required this.imageUrl,
    required this.name,
    required this.matchPercentage,
  });

  factory UserProfile.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserProfile(
      documentId: snapshot.id,
      imageUrl:
          data['ImageUrl'] as String? ?? 'https://via.placeholder.com/150',
      name: data['Name'] as String? ?? 'Unavailable',
      matchPercentage: data['MatchPercentage']?.toDouble() ?? 0.0,
    );
  }
}
