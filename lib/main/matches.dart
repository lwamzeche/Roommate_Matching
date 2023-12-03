// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, curly_braces_in_flow_control_structures, unnecessary_brace_in_string_interps, unnecessary_cast
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  }

  Stream<List<UserProfile>> _getMatches() {
    return _firestore
        .collection('matches')
        .where(FieldPath.documentId,
            isEqualTo:
                currentUserId) // Make sure this is the correct document ID
        .snapshots()
        .asyncMap((QuerySnapshot matchSnapshot) async {
      List<UserProfile> matchedProfiles = [];

      if (matchSnapshot.docs.isNotEmpty) {
        final matchData =
            matchSnapshot.docs.first.data() as Map<String, dynamic>;
        final List<dynamic> matchedUserIds = matchData['user2Id'] ?? [];
        final List<dynamic> matchPercentages =
            matchData['matchPercentage'] ?? [];

        for (int i = 0; i < matchedUserIds.length; i++) {
          final otherUserId = matchedUserIds[i];
          // Handle the case where there are fewer percentages than user IDs
          final matchPercentage = i < matchPercentages.length
              ? (matchPercentages[i] as num).toDouble() *
                  100 // Convert to percentage
              : 0.0; // Default to 0 if no percentage is found

          try {
            final userProfileSnapshot = await _firestore
                .collection('userProfiles')
                .doc(otherUserId)
                .get();

            if (userProfileSnapshot.exists) {
              final userData =
                  userProfileSnapshot.data() as Map<String, dynamic>;
              matchedProfiles.add(UserProfile(
                documentId: otherUserId,
                imageUrl:
                    userData['ImageUrl'] ?? 'https://via.placeholder.com/150',
                name: userData['Name'] ?? 'Unavailable',
                matchPercentage:
                    matchPercentage, // Now correctly retrieving the percentage
              ));
            } else {
              print('User profile for ID $otherUserId does not exist.');
            }
          } catch (e) {
            print('Error fetching profile for user ID $otherUserId: $e');
          }
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

  void _createOrGetChat(String matchedUserId, BuildContext context) {
    List<String> ids = [currentUserId, matchedUserId];
    ids.sort(); // Ensure consistent order for generating the chatId

    String chatId =
        ids.join('_'); // This creates a chatId by combining both user IDs

    // Check Firestore for an existing chat document
    _firestore.collection('chats').doc(chatId).get().then((chatDoc) {
      if (!chatDoc.exists) {
        // Chat doesn't exist, create a new chat document
        _firestore.collection('chats').doc(chatId).set({
          'userIds': ids,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
      // Navigate to the chat screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ChatScreen(chatId: chatId, currentUserId: currentUserId),
        ),
      );
    });
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
                    _createOrGetChat(match.documentId, context);
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
