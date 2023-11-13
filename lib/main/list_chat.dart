// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat.dart';
import 'main_page.dart';
import 'matches.dart';
import 'my_profile.dart';

class MyChatsScreen extends StatefulWidget {
  @override
  _MyChatsScreenState createState() => _MyChatsScreenState();
}

class _MyChatsScreenState extends State<MyChatsScreen> {
  List<ChatEntry> chats = [];
  int _selectedIndex = 2; // Since the chat page is at index 2

  @override
  void initState() {
    super.initState();
    loadMatchesAsChats();
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

  // This function is called to load all matches as chats
  void loadMatchesAsChats() {
    // Assuming you have access to some function that fetches your matches
    fetchMatches().then((matchList) {
      setState(() {
        chats = matchList.map((match) {
          // Assuming 'match' is a UserProfile object like the one from your MatchesPage
          return ChatEntry(
            chatId: match
                .documentId, // Or any other unique id that represents the chat
            currentUserId:
                'yourCurrentUserId', // Replace with the actual current user ID
            imageUrl: match.imageUrl,
            name: match.name,
            lastMessage:
                'You matched with ${match.name}!', // Placeholder for last message
          );
        }).toList();
      });
    });
  }

  Future<List<UserProfile>> fetchMatches() async {
    // Here you should write the code to fetch the matches from your Firestore collection
    // For now, let's assume this function returns a list of UserProfiles
    var firestore = FirebaseFirestore.instance;
    var querySnapshot = await firestore.collection('userProfiles').get();
    return querySnapshot.docs
        .map((doc) => UserProfile.fromSnapshot(doc))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Chats'),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(chat.imageUrl),
            ),
            title: Text(chat.name),
            subtitle: Text(chat.lastMessage),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    chatId: chat.chatId,
                    currentUserId: chat.currentUserId,
                  ),
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

class ChatEntry {
  final String chatId;
  final String currentUserId;
  final String imageUrl;
  final String name;
  final String lastMessage;

  ChatEntry({
    required this.chatId,
    required this.currentUserId,
    required this.imageUrl,
    required this.name,
    required this.lastMessage,
  });
}

// Assume UserProfile is defined elsewhere in your project
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
      imageUrl: data['ImageUrl'],
      name: data['Name'],
    );
  }
}
