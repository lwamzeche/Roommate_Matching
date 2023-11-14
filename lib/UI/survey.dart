// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'life_survey.dart';
import 'sleep_habit.dart';

class SurveyScreen extends StatelessWidget {
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
              'Take our survey',
              style: TextStyle(
                fontSize: baseFontSize, // Responsive font size
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Flexible(
              child: RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Container(
                        padding: EdgeInsets.all(6), // Adjust padding as needed
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
                    ),
                    TextSpan(
                      text: ' 10 questions\n',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          'Take a survey about your lifestyle habits to find your perfect match',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: subtitleFontSize,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Flexible(
              child: RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Container(
                        padding: EdgeInsets.all(6), // Adjust padding as needed
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
                    ),
                    TextSpan(
                      text: ' Find your match\n',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          'Our system will match you with the most compatible roommate',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: subtitleFontSize,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            OutlinedButton(
              onPressed: () {
                // TODO: Handle skip survey action
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SleepHabitScreen()),
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
                      builder: (context) => LifestyleSurveyScreen()),
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
