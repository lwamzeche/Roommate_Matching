// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:roomie_project/UI/nationality.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './firestore_service.dart';

class TimeInDorm extends StatefulWidget {
  final User currentUser;
  TimeInDorm({required this.currentUser});
  @override
  _TimeInDormState createState() => _TimeInDormState();
}

class _TimeInDormState extends State<TimeInDorm> {
  String? _selectedHabit;

  Widget _buildSelectionOption(String habit) {
    bool isSelected = _selectedHabit == habit;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedHabit = habit;
          });
        },
        child: Container(
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.symmetric(vertical: 16.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.blue),
          ),
          alignment: Alignment.center,
          child: Text(
            habit,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.blue,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> options = [
      'All the time',
      'Rare',
      'Sometimes',
      'Does not matter'
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Handle skip action
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => Nationality(currentUser: widget.currentUser)),
              );
            },
            child: Text('Take it Later', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lifestyle preference',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Select your preferences in ideal roommate',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 32.0),
            Text(
              'Amount of time spent in room',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.0),
            // First row of options
            Row(
              children: options
                  .sublist(0, 2)
                  .map((habit) => _buildSelectionOption(habit))
                  .toList(),
            ),
            // Second row of options
            Row(
              children: options
                  .sublist(2)
                  .map((habit) => _buildSelectionOption(habit))
                  .toList(),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  if (widget.currentUser?.uid != null) {
                    FirestoreService.updateUserData(widget.currentUser.uid, "roommatePreferenceDormTime", _selectedHabit ?? 'Sometimes in dorm');
                  };
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Nationality(currentUser: widget.currentUser)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 60), // Width and height
                ),
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
