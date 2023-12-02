// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'life_survey.dart';
import 'sleep_habit.dart';
import 'roomate_survey.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SurveyScreen extends StatelessWidget {
  final User currentUser;
  SurveyScreen({required this.currentUser});
  @override
  Widget build(BuildContext context) {
    // Getting screen size for responsive layout
    var screenSize = MediaQuery.of(context).size;
    // Check platform and adjust font size
    double baseFontSize = screenSize.width * 0.08;
    double titleFontSize = screenSize.width * 0.05;
    double subtitleFontSize = screenSize.width * 0.03;
    if (Platform.isAndroid) {
      baseFontSize = screenSize.width * 0.05;
      titleFontSize = screenSize.width * 0.04;
      subtitleFontSize = screenSize.width * 0.03;
    }

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
        //       // TODO: Handle skip survey action
              
        //     },
        //     child: Text(
        //       'Skip',
        //       style: TextStyle(color: Colors.blue),
        //     ),
        //   )
        // ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'assets/Roomie/Lifestyle Survey Intro.png', // Replace with your image asset.
              height: screenSize.height * 0.3,
            ),
            SizedBox(height: screenSize.height * 0.05),
            Text(
              'What type of roomate are you?',
              style: TextStyle(
                fontSize: baseFontSize, // Responsive font size
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, // Align items vertically to the center
                children: [
                  Container(
                    padding: EdgeInsets.all(8), // Adjust padding as needed
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Space between circle and text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '10 questions',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Take a survey about your lifestyle habits to find what type of roommate you are',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: subtitleFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, // Align items vertically to the center
                children: [
                  Container(
                    padding: EdgeInsets.all(8), // Adjust padding as needed
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: Text(
                      '2',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Space between circle and text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find your match',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Our system will match you with the most compatible roommate according to your results',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: subtitleFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            OutlinedButton(
              onPressed: () {
                // TODO: Handle skip survey action
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>  RoomatePreferenceScreen(currentUser: currentUser)),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: BorderSide(color: Colors.blue),
                padding: EdgeInsets.symmetric(
                    vertical: 16), // Add vertical padding to increase height
              ),
              child: Text('Skip survey',
                  style: TextStyle(
                      fontSize: 18)), // You can adjust the font size as needed
            ),
            SizedBox(height: screenSize.height * 0.02),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(
                    vertical: 16), // Add vertical padding to increase height
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => LifestyleSurveyScreen(currentUser: currentUser)),
                );
              },
              child: Text('Start survey',
                  style: TextStyle(
                      fontSize: 18)), // You can adjust the font size as needed
            ),
            SizedBox(height: screenSize.height * 0.02),
          ],
        ),
      ),
    );
  }
}
