// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, library_private_types_in_public_api
import 'package:flutter/material.dart';
import './mbti.dart';

class DormitoryScreen extends StatefulWidget {
  @override
  _DormitoryScreenState createState() => _DormitoryScreenState();
}

class _DormitoryScreenState extends State<DormitoryScreen> {
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
              'Select your dormitory',
              style: TextStyle(
                fontSize: screenSize.width * 0.08, // Responsive font size
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenSize.height * 0.05),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              hint: Text('Select dormitory'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue!;
                });
              },
              items: <String>[
                'Sarang Hall',
                'Somang Hall',
                'Silloe Hall',
                'Jihye Hall',
                'Heemang Hall',
                'Sejong Hall',
                'Mir Hall',
                'Jilli Hall',
                'Munji Hall',
                'Hwaam Hall',
                'Seonhsil Hall',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Select dormitory',
                border: OutlineInputBorder(),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MBTIScreen()),
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
