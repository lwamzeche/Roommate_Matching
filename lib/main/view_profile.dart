// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'main_page.dart';
import 'dart:io' show Platform;
import 'my_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ViewProfilePage extends StatefulWidget {
  final UserProfile userProfile;

  ViewProfilePage({Key? key, required this.userProfile}) : super(key: key);

  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
}
// class ViewProfilePage extends StatelessWidget {
class _ViewProfilePageState extends State<ViewProfilePage> {
  // final UserProfile userProfile;
  // ViewProfilePage({Key? key, required this.userProfile}) : super(key: key) {
  //   print("User Profile Details:");
  //   print("Name: ${userProfile.name}");
  //   print("Bio: ${userProfile.smokingHabit}");
  // }
  String? roomieBio;
  String? roomieDescription;
  String? roomieImage;

  @override
  void initState() {
    super.initState();
    fetchRoomieInfo(widget.userProfile.roomieName);
  }

  Future<void> fetchRoomieInfo(String? roomieName) async {
    if (roomieName != null && roomieName.isNotEmpty) {
      try {
        DocumentSnapshot roomieDoc = await FirebaseFirestore.instance
            .collection('roomieInfo')
            .doc(roomieName)
            .get();

        if (roomieDoc.exists) {
          Map<String, dynamic> roomieData =
              roomieDoc.data() as Map<String, dynamic>;
          setState(() {
            roomieBio = roomieData['roomieBio'];
            roomieDescription = roomieData['roomieDescription'];
            roomieImage = roomieData['roomieImage'];
          });
        }
      } catch (e) {
        print("Error fetching roomie info: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('View Profile', style: TextStyle(color: Colors.white)),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildProfileImage(context),
            _buildBioSection(),
            Divider(),
            _buildDetailsSection(),
            _buildLabelsSection(),
            Divider(),
            _buildRoommatePreferencesSection(widget.userProfile),
            Divider(),
            _buildRoomieHeading(),
            _buildRoomieSection(context, screenSize),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image.network(
          widget.userProfile.imageUrl ?? 'https://via.placeholder.com/150',
          width: double.infinity,
          height: screenSize.height * 0.6,
          fit: BoxFit.cover,
        ),
        Container(
          width: screenSize.width * 0.8,
          height: 80,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${widget.userProfile.name ?? 'Unavailable'}, ${widget.userProfile.age ?? 'N/A'} yrs',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                '${widget.userProfile.department ?? 'N/A'}',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBioSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Bio',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8), // Added space
          Text(widget.userProfile.bio ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('All about ${widget.userProfile.name ?? 'User'}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8), // Added space
        ],
      ),
    );
  }

  Widget _buildLabelsSection() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Wrap(
        spacing: 8.0,
        children: <Widget>[
          _buildLabel(widget.userProfile.mbti ?? 'MBTI: Unavailable'),
          _buildLabel(widget.userProfile.dormitory ?? 'Dormitory: Unavailable'),
          _buildLabel(widget.userProfile.userType ?? 'User Type: Unavailable'),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Chip(
      label: Text(
        text,
        style: TextStyle(
          color: Colors.blue,
          fontSize: 16, // Increased font size
        ),
      ),
      backgroundColor: Colors.white,
      shape: StadiumBorder(side: BorderSide(color: Colors.blue)),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    );
  }

  String _getFirstName(String? fullName) {
    if (fullName == null || fullName.isEmpty) {
      return 'User';
    }
    return fullName
        .split(' ')[0]; // Split the string by space and take the first part
  }

  Widget _buildRoomieHeading() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
          child: Text(
            "${_getFirstName(widget.userProfile.name)}'s Roomie",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

   Widget _buildRoommatePreferencesSection(UserProfile myProfile) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(16, 32, 16, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              // "${_getFirstName(myProfile.name)'s Preference in Roommate",
              "${_getFirstName(widget.userProfile.name)}'s Preference in Roommate",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        PreferencesWidget(
          title: 'Time in Dorm',
          value: myProfile.timeInDorm ?? 'Not specified',
        ),
        SizedBox(height: 8),
        PreferencesWidget(
          title: 'Gaming',
          value: myProfile!.gamingHabit ??
              'Not specified',
                    ),
        SizedBox(height: 8),
        PreferencesWidget(
          title: 'Nationality',
          value: myProfile.preferenceNationality ?? 'Not specified',
        ),
        SizedBox(height: 8),
        PreferencesWidget(
          title: 'Sleeping Habit',
          value: myProfile.sleepingHabit ?? 'Not specified',
        ),
        SizedBox(height: 8),
        PreferencesWidget(
          title: 'Smoking Habit',
          value: myProfile.smokingHabit ?? 'Not specified',
        ),

        SizedBox(height: 16),
        Divider(),
      ],
    );
  }

  Widget _buildRoomieSection(BuildContext context, Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
          child: Text(
            "${widget.userProfile.roomieName ?? 'User'}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 8), // Space between heading and roomie name
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: widget.userProfile.roomieImage != null
              ? Image.network(
                  roomieImage!,
                  fit: BoxFit.cover,
                )
              : SizedBox(height: 250, child: Placeholder()),
        ),
        SizedBox(height: 30), // Space between roomie name and image
        Text(
              roomieDescription ?? 'Roomie Description',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
        SizedBox(height: 15), // Space between image and description
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.15),
          child: Text(
            roomieBio ?? 'Roomie Bio',
            style: TextStyle(fontSize: 16),
            textAlign:
                TextAlign.justify, // Align the roomie description to the center
          ),
        ),
        SizedBox(height: 50),
      ],
    );
  }
}
