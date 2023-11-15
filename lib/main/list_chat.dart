// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

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
    currentUserId = Uuid().v4(); // Generate a random user ID for simulation
    _getMatches();
  }

  void _getMatches() {
    // Subscribe to the userProfiles collection
    _firestore.collection('userProfiles').snapshots().listen((snapshot) {
      final List<UserProfile> matchList = snapshot.docs.map((doc) {
        return UserProfile.fromSnapshot(doc);
      }).toList();

      // Perform any sorting or filtering logic if needed
      // For simplicity, we're not doing that here

      // Update the matches list
      setState(() {
        matches = matchList;
      });
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
