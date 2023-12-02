// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'sleep_habit.dart';
import 'roomate_survey.dart';
import 'roomie_result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './firestore_service.dart';



class LifestyleSurveyScreen extends StatefulWidget {
  final User currentUser;
  LifestyleSurveyScreen({required this.currentUser});
  @override
  _LifestyleSurveyScreenState createState() => _LifestyleSurveyScreenState();
}

class _LifestyleSurveyScreenState extends State<LifestyleSurveyScreen> {
  final Map<String, int?> _responses = {};

  void checkAndStoreResponses() {
    _responses.forEach((question, answer) {
      String firestoreField = "";
      if (question == "I spend majority time in my dormitory room") {
        firestoreField = "roomieDormTime";
      } else if (question == "I generally go to sleep late at night") {
        firestoreField = "roomieSleep";
      } else if (question == "I am habitual smoker") {
        firestoreField = "roomieSmoker";
      }

      if (firestoreField.isNotEmpty) {
        FirestoreService.updateUserData(widget.currentUser.uid, firestoreField, answer?.toString() ?? 'Not Answered');
      }

    });
  }


  @override
  Widget build(BuildContext context) {
    List<String> questions = [
      'I prefer keeping my place clean and neat',
      'I prefer eating in dormitory room',
      'I engage in activities that usually create significant amount of noise',
      'I am comfortable with sharing my personal things with my roommate',
      'My religious/cultural practice significantly affect my routine in dorm',
      'I generally go to sleep late at night',
      'I am habitual smoker',
      'I play noisy games in my room',
      'I spend majority time in my dormitory room',
      'I often bring visitors'
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // actions: [
        //   TextButton(
        //     onPressed: () {
        //       // Handle skip action
        //       Navigator.of(context).push(
        //         MaterialPageRoute(builder: (context) => RoomatePreferenceScreen(currentUser: widget.currentUser)),
        //       );
        //     },
        //     child: Text('Skip', style: TextStyle(color: Colors.blue)),
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            Text(
              'Lifestyle survey',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Enter your lifestyle habits to get a better match',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 24.0),
            ...questions.map((question) => buildQuestion(question)).toList(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: ElevatedButton(
                onPressed: () {
                  checkAndStoreResponses(); // Store responses
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RoomieSuccessPage(currentUser: widget.currentUser)),
                  );
                  // Save action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('Save', style: TextStyle(fontSize: 16.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuestion(String question) {
    int? groupValue = _responses[question];

    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 16.0), // Add padding between questions
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            question,
            textAlign: TextAlign.center, // Center-align text
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16), // Space between question text and radio buttons
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center-align the row content
              children: [
                Text('Disagree', style: TextStyle(fontSize: 14)),
                SizedBox(
                    width:
                        8), // Provide some spacing between the text and radio buttons
                ...List.generate(
                    5, (index) => buildRadio(index, question, groupValue)),
                SizedBox(
                    width:
                        8), // Provide some spacing between the radio buttons and text
                Text('Agree', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget buildRadio(int index, String question, int? groupValue) {
    return InkWell(
      onTap: () {
        setState(() {
          // If the current value is already selected, set it to null (unselect it)
          // Otherwise, set it to the new value
          _responses[question] = _responses[question] == index ? null : index;
        });
      },
      child: Container(
        width: 40, // Set a fixed size for hit area
        height: 40, // Set a fixed size for hit area
        padding: EdgeInsets.all(10), // Padding inside the container
        child: Container(
          width: index == 0 || index == 4
              ? 24
              : 16, // Large size for "Disagree" and "Agree"
          height: index == 0 || index == 4
              ? 24
              : 16, // Large size for "Disagree" and "Agree"
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: groupValue == index ? Colors.blue : Colors.grey),
            color: groupValue == index ? Colors.blue : Colors.transparent,
          ),
          child: groupValue == index
              ? Icon(Icons.check,
                  color: Colors.white, size: 18) // Check icon for selected
              : null,
        ),
      ),
    );
  }
}
