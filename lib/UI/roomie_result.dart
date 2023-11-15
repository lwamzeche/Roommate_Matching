import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'roomate_survey.dart';

class RoomieSuccessPage extends StatelessWidget {
  final String roomieName = "SBE";
  final String roomieImagePath = 'assets/Roomie/SBE.jpg';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

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
        padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
            Text(
              'Your Roomie type is:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20), // Space between text and name
            Text(
              roomieName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20), // Space between name and image
            Image.asset(
              roomieImagePath,
              width: screenSize.width * 0.5,
            ),
            SizedBox(height: 20), // Space between image and description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
              child: Text(
                'Someone who smokes however preferring to wake up early and spending their time outside of dormitory to study and other activities.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(
                        vertical: 16, horizontal: screenSize.width * 0.3),
                ),
                onPressed: () {
                    Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => RoomatePreferenceScreen()),
                    );
                },
                child: Text('Continue',
                    style: TextStyle(
                        fontSize: 18)), 
                    ),
            SizedBox(height: screenSize.height * 0.02),
          ],
        ),
      ),
    );
  }
}
