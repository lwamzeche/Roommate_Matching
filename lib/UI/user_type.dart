// ignore_for_file: prefer_const_constructors, avoid_print
import 'package:flutter/material.dart';
import './gender.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './firestore_service.dart';

class UserTypeScreen extends StatefulWidget {
  final User currentUser;
  UserTypeScreen({ required this.currentUser});
  @override
  _UserTypeScreenState createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  String selectedUserType = '';

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // actions: <Widget>[
        //   TextButton(
        //     onPressed: () {
        //       Navigator.of(context).push(
        //         MaterialPageRoute(builder: (context) => GenderScreen(currentUser: widget.currentUser)),
        //       );
        //     },
        //     child: Text(
        //       'Take it Later',
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
            SizedBox(height: screenSize.height * 0.05),
            Text(
              'Who are you?',
              style: TextStyle(
                fontSize: screenSize.width * 0.08,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenSize.height * 0.1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _userTypeButton('International', screenSize),
                _userTypeButton('Domestic', screenSize),
              ],
            ),
            Spacer(),
            ElevatedButton(
            onPressed: () {
              if (widget.currentUser.uid != null) {
                FirestoreService.updateUserData(widget.currentUser!.uid, "User Type", selectedUserType);
              }
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => GenderScreen(currentUser: widget.currentUser!)),
              );
            },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(
                    vertical: 17), // Increased height of the button
              ),
              child: Text(
                'Next',
                style: TextStyle(
                    fontSize: 18), // Optionally increase font size if needed
              ),
            ),
            SizedBox(height: screenSize.height * 0.07),
          ],
        ),
      ),
    );
  }

  Widget _userTypeButton(String userType, Size screenSize) {
    bool isSelected = selectedUserType == userType;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedUserType = userType;
        });
      },
      child: Container(
        margin:
            EdgeInsets.all(10), // Add margin to create space around the square
        padding: EdgeInsets.all(
            20), // Add padding inside the square to reduce the size of the circle
        decoration: BoxDecoration(
          color: Colors.white, // Set the color of the square
          border: Border.all(
              color: Colors.grey, width: 1), // Set the border of the square
          //   borderRadius:
          //       BorderRadius.circular(12), // Set the border radius of the square
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the circle and text vertically
          children: <Widget>[
            Container(
              width: screenSize.width *
                  0.2, // Set the smaller width for the circle
              height: screenSize.width *
                  0.2, // Set the same height for the circle to keep it circular
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blue
                    : Colors.grey[300], // Set the color of the circle
                shape: BoxShape.circle, // Make the inner Container circular
              ),
              child: isSelected
                  ? Icon(Icons.check,
                      color: Colors.white, size: screenSize.width * 0.1)
                  : Container(),
            ),
            SizedBox(height: 9),
            Text(
              userType,
              style: TextStyle(
                color: Colors.black, // Set the text color inside the square
              ),
            ),
          ],
        ),
      ),
    );
  }
}
