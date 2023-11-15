// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors
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

  final Map<String, String> currentUserPreferences = {
    'sleepingHabit': 'Early bird',
    'smokingHabit': 'Non-smoker',
    'timeInDorm': 'Sometimes'
  };

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _userProfiles = FirebaseFirestore.instance.collection('userProfiles');
    super.initState();
    currentUserId = Uuid().v4();
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

      return userProfiles; // return the sorted list
    });
  }

  int _calculateMatchScore(
      UserProfile profile, Map<String, String> preferences) {
    double score = 0.0;

    const weightSleepingHabit = 0.3;
    const weightSmokingHabit =
        0.4; // Smoking might be a deal breaker so it has a higher weight
    const weightTimeInDorm = 0.3;

    if (profile.sleepingHabit == preferences['sleepingHabit'])
      score += weightSleepingHabit;
    if (profile.smokingHabit == preferences['smokingHabit'])
      score += weightSmokingHabit;
    if (profile.timeInDorm == preferences['timeInDorm'])
      score += weightTimeInDorm;

    double randomFactor =
        Random().nextDouble() * 0.2; // Random value between 0.0 and 0.2
    score += randomFactor;

    if (score > 1.0) score = 1.0;

    return (score * 100).toInt(); // Convert to percentage
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
      ),
      body: StreamBuilder<List<UserProfile>>(
        stream: _getMatches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print(snapshot.error); // Log the error to the console for debugging
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
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
                subtitle:
                    Text('Match: ${matchScore}%'), // Example score calculation
                trailing: ElevatedButton(
                  onPressed: () {
                    String matchedUserId = matches[index].documentId;
                    // This should be the document ID of the matched profile

                    // Generate the chatId
                    List<String> ids = [currentUserId, matchedUserId];
                    ids.sort(); // Ensure consistent order
                    String chatId = ids.join('_');

                    // Check Firestore for an existing chat document
                    _firestore
                        .collection('chats')
                        .doc(chatId)
                        .get()
                        .then((chatDoc) {
                      if (!chatDoc.exists) {
                        // Chat doesn't exist, create a new chat document
                        _firestore.collection('chats').doc(chatId).set({
                          'userIds': [currentUserId, matchedUserId],
                          'timestamp': FieldValue.serverTimestamp(),
                          // other initial data for a new chat
                        });
                      }
                      // Navigate to the chat screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                              chatId: chatId, currentUserId: currentUserId),
                        ),
                      );
                    });
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
  final String documentId; // Add a field for the document ID
  final String imageUrl;
  final String name;
  final String sleepingHabit;
  final String smokingHabit;
  final String timeInDorm;

  UserProfile({
    required this.documentId, // Initialize the document ID
    required this.imageUrl,
    required this.name,
    required this.sleepingHabit,
    required this.smokingHabit,
    required this.timeInDorm,
  });

  factory UserProfile.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserProfile(
      documentId: snapshot.id, // Set the document ID from the snapshot
      imageUrl:
          data['ImageUrl'] as String? ?? '', // Provide a default value if null
      name: data['Name'] as String? ?? '', // Provide a default value if null
      sleepingHabit: data['sleepingHabit'] as String? ??
          '', // Provide a default value if null
      smokingHabit:
          data['Smoker'] as String? ?? '', // Adjusted to the correct field name
      timeInDorm: data['Sometimes in dorm'] as String? ??
          '', // Adjusted to the correct field name
    );
  }
}
