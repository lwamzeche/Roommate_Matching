// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat.dart';
import 'main_page.dart';
import 'my_profile.dart';

class MyChatsScreen extends StatefulWidget {
  @override
  _MyChatsScreenState createState() => _MyChatsScreenState();
}

class _MyChatsScreenState extends State<MyChatsScreen> {
  int _selectedIndex = 2; // Assuming index 2 is 'Chats'

  void _onNavBarTapped(int index) {
    if (_selectedIndex == index) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    // Navigate based on the index tapped
    switch (index) {
      case 0:
        // Navigate to home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
        break;
      case 3:
        // Navigate to profile
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyProfilePage()),
        );
        break;
      default:
        // Handle other tabs if necessary
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference chatsCollection =
        FirebaseFirestore.instance.collection('chats');

    return Scaffold(
      appBar: AppBar(
        title: Text('My Chats'),
        // Add other AppBar properties as needed
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: chatsCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Convert the snapshot
          final chatData = snapshot.data!.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();

          return ListView.separated(
            itemCount: chatData.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              final DocumentSnapshot chatDocument = snapshot.data!.docs[index];
              final Map<String, dynamic> chat =
                  chatDocument.data() as Map<String, dynamic>;

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(chat['avatarUrl']),
                ),
                title: Text(chat['name']),
                subtitle: Text(chat['lastMessage']),
                trailing: Text(chat['timestamp']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                          chatId: chatDocument
                              .id), // Assuming chatDocument.id is the chat ID used to open the chat room
                    ),
                  );
                },
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
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Matches'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: _onNavBarTapped,
      ),
    );
  }
}
