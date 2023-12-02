import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'roomate_survey.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomieSuccessPage extends StatefulWidget {
  final User currentUser;
  RoomieSuccessPage({required this.currentUser});
  @override
  _RoomieSuccessPageState createState() => _RoomieSuccessPageState();
}

class _RoomieSuccessPageState extends State<RoomieSuccessPage> {
  String roomieName = "";
  String roomieImagePath = "";
  String roomieExplanation = "";
  String roomieBio = "";

  @override
  void initState() {
    super.initState();
    fetchUserProfileAndConstructString().then((roomieString) {
      fetchRoomieInfo(roomieString);
    });
  }

  Future<String> fetchUserProfileAndConstructString() async {
    try {
      // Fetch user profile data
      DocumentSnapshot userProfile = await FirebaseFirestore.instance
          .collection('userProfiles')
          .doc(widget.currentUser.uid)
          .get();

      if (!userProfile.exists) {
        throw Exception("User profile not found");
      }

      // Construct the 3-character string
      String roomieString = "";
      roomieString += (userProfile['roomieSmoker'] == "4" || userProfile['roomieSmoker'] == "3") ? "S" : "N";
      roomieString += (userProfile['roomieSleep'] == "4" || userProfile['roomieSleep'] == "3") ? "O" : "B";
      roomieString += (userProfile['roomieDormTime'] == "4" || userProfile['roomieDormTime'] == "3") ? "I" : "E";

      // Store the 3-character string in profiles collection
      await FirebaseFirestore.instance
          .collection('userProfiles')
          .doc(widget.currentUser.uid)
          .set({'roomieName': roomieString}, SetOptions(merge: true));

      return roomieString;
    } catch (e) {
      print('Error in fetchUserProfileAndConstructString: $e');
      return '';
    }
  }

  void fetchRoomieInfo(String roomieString) async {
    if (roomieString.isEmpty) {
      print('Roomie string is empty, skipping fetchRoomieInfo');
      return;
    }

    try {
      // Fetch specific document from roomieInfo collection
      DocumentSnapshot roomieDoc = await FirebaseFirestore.instance
          .collection('roomieInfo')
          .doc(roomieString) // Using the constructed string
          .get();

      if (!roomieDoc.exists) {
        roomieDoc = await FirebaseFirestore.instance
          .collection('roomieInfo')
          .doc("NOE")
          .get();
      }

      if (roomieDoc.exists) {
        setState(() {
          roomieName = roomieDoc['roomieName'];
          roomieImagePath = roomieDoc['roomieImage'];
          roomieExplanation = roomieDoc['roomieDescription'];
          roomieBio = roomieDoc['roomieBio'];
        });
      } else {
        print("Roomie info not found for $roomieString");
      }
    } catch (e) {
      print('Error in fetchRoomieInfo: $e');
    }
  }

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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20), // Space between text and name
            Text(
              roomieName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 15), // Space between name and image
            // Image.asset(
            //   roomieImagePath,
            //   width: screenSize.width * 0.5,
            // ),
            Container(
            width: MediaQuery.of(context).size.width * 0.6,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: roomieImagePath.isNotEmpty
                ? Image.network(
                    roomieImagePath,
                    fit: BoxFit.cover,
                  )
                : SizedBox(height: 100, child: Placeholder()),
            ),
            SizedBox(height: 15),
            Text(
              roomieExplanation,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 20), // Space between image and description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
              child: Text(
                roomieBio,
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.justify,
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
                        builder: (context) => RoomatePreferenceScreen(currentUser: widget.currentUser)),
                    );
                },
                child: Text('Next',
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
