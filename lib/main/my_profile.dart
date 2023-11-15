// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../UI/sleep_habit.dart';
import 'list_chat.dart';
import 'main_page.dart';
import 'matches.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class MyProfilePage extends StatefulWidget {

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  int _selectedIndex = 3;
  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainPage()));
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MatchesPage()));
        break;
      case 2:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyChatsScreen()));
        break;
      case 3:
        // Already on Profile page, no action needed.
        break;
    }
  }
  MyProfile? myProfile;
  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }
  Future<void> fetchUserProfile() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('userProfiles')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        print("User profile found");
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          myProfile = MyProfile(
            name: data['Name'],
            age: data['Age'].toString(),
            imageUrl: data['ImageUrl'],
            bio: data['Bio'],
            department: data['Department'],
          );
        });
      } else {
        print("User profile not found");
      }
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end, // Aligns the logo to the right
        children: [
          Image.asset('assets/Roomie/LOGO.png', height: 30),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 0,
    ),
    body: myProfile == null
      ? Center(child: Text("No user profile data"))
      : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 16, top: 10),
                  child: TextButton(
                    onPressed: () {
                      // TODO: Edit implementation should be here but i dont have time and it is not essential
                    },
                    child: Text('Edit', style: TextStyle(color: Colors.blue)),
                  ),
                ),
              ),
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(myProfile!.imageUrl ?? 'https://via.placeholder.com/150'),
                backgroundColor: Colors.grey[200],
              ),
              SizedBox(height: 16),
              Text(
                "${myProfile!.name ?? 'No Name'}, ${myProfile!.age} yrs",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8), // Space between name/age and department
              Text(
                myProfile!.department ?? 'Department',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16), // Space before bio heading
              Padding (
                padding: EdgeInsets.only(right: 350),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [ Text(
                "Bio",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ) ],
              ),),
              SizedBox(height: 8), // Space between bio heading and bio text
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  myProfile!.bio ?? 'No Bio',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 40), // Space at the bottom
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Retake test",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SleepHabitScreen(currentUser: FirebaseAuth.instance.currentUser!)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                      ),
                      child: Text('Retake'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), // Space at the bottom
            ],
          ),
        ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex, // Set the currentIndex to _selectedIndex
        onTap: _onNavBarTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Matches'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class MyProfile {
  final String? name;
  final String? age;
  final String? imageUrl;
  final String? bio;
  final String? department;

  MyProfile({this.name, this.age, this.imageUrl, this.bio, this.department});
}
