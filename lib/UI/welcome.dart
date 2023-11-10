// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import './login.dart'; // Import the login.dart file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugShowCheckedModeBanner:
    false;
    return MaterialApp(
      title: 'Roommate Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Getting screen size for responsive layout
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.blue.shade600,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Using Expanded to make the image take up 1/3 of the screen height
                Expanded(
                  flex: 3,
                  child: Image.asset(
                    'assets/Roomie/Login.png', // Replace with your asset image path
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Find your ideal roommate',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.08, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Find your perfect roommate using our survey and preferences to connect with potential roommates who share similar lifestyle habits and preferences',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.04, // Responsive font size
                    color: Colors.white70,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue.shade600,
                        backgroundColor: Colors.white, // Button text color
                        minimumSize:
                            Size(screenSize.width * 0.8, 50), // Button size
                        shape: RoundedRectangleBorder(),
                      ),
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize:
                              screenSize.width * 0.045, // Responsive font size
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
