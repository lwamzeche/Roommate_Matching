import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String chatId;

  ChatScreen({required this.chatId});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement your chat UI here. For now, it's just a placeholder.
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Chat with $chatId'), // You might want to display the user's name instead
      ),
      body: Center(
        child: Text('Chat room for user with ID: $chatId'),
      ),
    );
  }
}
