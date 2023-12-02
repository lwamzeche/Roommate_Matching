// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../UI/survey.dart';
import '../UI/roomate_survey.dart';

class RetakePage extends StatefulWidget {
  final User currentUser;
  RetakePage({required this.currentUser});
  @override
  _RetakePageState createState() => _RetakePageState();
}

class _RetakePageState extends State<RetakePage> {
  String? _selectedTest;

  Widget _buildSelectionOption(String test) {
    bool isSelected = _selectedTest == test;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTest = test;
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
            test,
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
    List<String> options = ['My Lifestyle', 'Roommate Preference'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What test are you retaking?',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 32.0),
            Row(
              children: options
                  .map((test) => _buildSelectionOption(test))
                  .toList(),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedTest == 'My Lifestyle') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SurveyScreen(currentUser: widget.currentUser),
                      ),
                    );
                  } else if (_selectedTest == 'Roommate Preference') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RoomatePreferenceScreen(currentUser: widget.currentUser),
                      ),
                    );
                  }
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
