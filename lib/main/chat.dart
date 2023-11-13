// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors_in_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String currentUserId;

  ChatScreen({required this.chatId, required this.currentUserId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _sendMessage() {
    final String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      DocumentReference messageRef =
          _firestore.collection('chats/${widget.chatId}/messages').doc();
      WriteBatch batch = _firestore.batch();
      batch.set(messageRef, {
        'text': messageText,
        'senderId': widget.currentUserId, // Replace with the actual sender ID
        'timestamp': FieldValue.serverTimestamp(),
      });
      batch.set(
        _firestore.collection('chats').doc(widget.chatId),
        {
          'lastMessage': messageText,
          'lastMessageTimestamp': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
      batch.commit();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              // StreamBuilder can be expanded to take all available space minus the input container
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chats/${widget.chatId}/messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No messages yet'));
                  }
                  List<DocumentSnapshot> messages = snapshot.data!.docs;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var message =
                          messages[index].data() as Map<String, dynamic>;
                      bool isMine = message['senderId'] == widget.currentUserId;
                      return Align(
                        alignment: isMine
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          margin: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: isMine ? Colors.blue : Colors.grey,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            message['text'],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 8.0,
                right: 8.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Send a message...',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10.0),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.blue),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
