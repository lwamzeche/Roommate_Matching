// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat.dart'; // Make sure this import points to your chat screen file

class MyChatsScreen extends StatelessWidget {
  int _selectedIndex = 2;

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Assuming 'Home' is at index 0 and 'Profile' is at index 3
    switch (index) {
      case 0: // Home
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 3: // Profile
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      // Handle other indices, such as navigation to the current 'Chats' screen or 'Matches', if necessary
      // No default navigation is needed for the current 'Chats' screen
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
              final chat = chatData[index];
              return ListTile(
                leading: CircleAvatar(
                  // Use a placeholder image if the URL is not available
                  backgroundImage: NetworkImage(
                      chat['avatarUrl'] ?? 'https://via.placeholder.com/150'),
                ),
                title: Text(chat['name'] ?? 'No Name'),
                subtitle: Text(chat['lastMessage'] ?? 'No Last Message'),
                trailing: chat['unreadCount'] != 0
                    ? CircleAvatar(child: Text(chat['unreadCount'].toString()))
                    : null,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(chatId: chat['id']),
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
