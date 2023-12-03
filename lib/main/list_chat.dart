// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_literals_to_create_immutables
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
// import 'dart:math';

import 'chat.dart';
import 'main_page.dart';
import 'matches.dart';
import 'my_profile.dart';

class MyChatsScreen extends StatefulWidget {
  @override
  _MyChatsScreenState createState() => _MyChatsScreenState();
}

class _MyChatsScreenState extends State<MyChatsScreen> {
  List<UserProfile> matches = [];
  int _selectedIndex = 2;
  late final String currentUserId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
    _getMatches();
  }

  void getCurrentUserId() {
    // Replace with your method of getting the current user's ID from your auth system.
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
  }

  void _getMatches() {
    // Fetch matches for the current user
    _firestore
        .collection('matches')
        .doc(currentUserId) // Use the current user's ID
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        List<dynamic> matchedUserIds = data['user2Id'] ?? [];

        // For each matched user ID, fetch the corresponding user profile
        for (String userId in matchedUserIds) {
          _firestore
              .collection('userProfiles')
              .doc(userId)
              .get()
              .then((userDoc) {
            if (userDoc.exists) {
              // Add the user profile to the matches list
              setState(() {
                matches.add(UserProfile.fromSnapshot(userDoc));
              });
            }
          });
        }
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MatchesPage()),
        );
        break;
      case 2:
        // Current index is chat, no action needed
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Chats'),
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
      body: ListView.builder(
        itemCount: matches.length,
        itemBuilder: (context, index) {
          final match = matches[index];
          return ListTile(
            leading:
                CircleAvatar(backgroundImage: NetworkImage(match.imageUrl)),
            title: Text(match.name),
            onTap: () {
              _createOrGetChat(match.documentId);
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

  void _createOrGetChat(String matchedUserId) {
    List<String> ids = [currentUserId, matchedUserId];
    ids.sort(); // Ensure consistent order
    String chatId = ids.join('_');

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
}

class UserProfile {
  final String documentId;
  final String imageUrl;
  final String name;

  UserProfile({
    required this.documentId,
    required this.imageUrl,
    required this.name,
  });

  factory UserProfile.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserProfile(
      documentId: snapshot.id,
      imageUrl: data['ImageUrl'] as String? ?? '',
      name: data['Name'] as String? ?? '',
    );
  }
}
