// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'survey.dart';
import './firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MBTIScreen extends StatefulWidget {
  final User currentUser;
  MBTIScreen({required this.currentUser});
  @override
  _MBTIScreenState createState() => _MBTIScreenState();
}

class _MBTIScreenState extends State<MBTIScreen> {
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    // Getting screen size for responsive layout
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // TODO: Implement skip functionality
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SurveyScreen(currentUser: widget.currentUser)),
              );
            },
            child: Text(
              'Skip',
              style: TextStyle(color: Colors.blue),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: screenSize.height * 0.05),
            Text(
              'Select your MBTI',
              style: TextStyle(
                fontSize: screenSize.width * 0.08, // Responsive font size
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenSize.height * 0.05),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              hint: Text('Select MBTI'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue!;
                });
              },
              items: <String>[
                'INTJ',
                'INTP',
                'INFJ',
                'ISTP',
                'ISFP',
                'ISFJ',
                'INFP',
                'ESTP',
                'ESFP',
                'ENFP',
                'ENTP',
                'ESTJ',
                'ESFJ',
                'ENFJ',
                'ENTJ',
                'Do not know',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Select your MBTI',
                border: OutlineInputBorder(),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                if (widget.currentUser?.uid != null) {
                  print("selectedGender: $_selectedGender");
                  FirestoreService.updateUserData(widget.currentUser.uid, "MBTI", _selectedGender?? 'INFP');
                }
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SurveyScreen(currentUser: widget.currentUser)),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Text color
                padding: EdgeInsets.symmetric(vertical: 18),
              ),
              child: Text('Next'),
            ),
            SizedBox(height: screenSize.height * 0.05),
          ],
        ),
      ),
    );
  }
}
