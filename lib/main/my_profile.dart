// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'retake_page.dart';
import 'list_chat.dart';
import 'main_page.dart';
import 'matches.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_profile.dart';

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

  Widget _buildDetailsSection() {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('All about Me',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8), // Added space
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

  Widget _buildLabelsSection() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Wrap(
        spacing: 8.0,
        children: <Widget>[
          _buildLabel(myProfile!.mbti ?? 'MBTI: Unavailable'),
          _buildLabel(myProfile!.dormitory ?? 'Dormitory: Unavailable'),
          _buildLabel(myProfile!.userType ?? 'User Type: Unavailable'),
        ],
      ),
    );
  }

  Widget buildRoomieSection(MyProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
              16, 32, 16, 8), // Adjust the padding as needed
          child: Text(
            "My Roomie",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Center(
          child: Text(
            profile.roomieName ?? 'N/A',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20),
        profile.roomieImage != null
            ? Center(
                child: Image.network(profile.roomieImage!,
                    height: 200)) // Adjust the height as needed
            : Icon(Icons.account_circle, size: 200), // Placeholder icon
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.2),
          child: Text(
            profile.roomieDescription ?? 'N/A',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
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
      // Fetch the user's profile.
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('userProfiles')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

        // Store roomieName to use it for fetching roomieBio.
        String? roomieName = data['roomieName'];

        // Initialize roomieBio to 'N/A'.
        String roomieBio = 'N/A';

        // If roomieName is provided, fetch roomieBio from roomieInfo.
        if (roomieName != null && roomieName.isNotEmpty) {
          DocumentSnapshot roomieDoc = await FirebaseFirestore.instance
              .collection('roomieInfo')
              .doc(roomieName)
              .get();

          // If roomieInfo is found, update roomieBio.
          if (roomieDoc.exists) {
            Map<String, dynamic> roomieData =
                roomieDoc.data() as Map<String, dynamic>;
            roomieBio = roomieData['roomieBio'] ?? 'N/A';
            roomieDescription = roomieData['roomieDescription'] ?? 'N/A';
          }
        }

        // Update the state with the fetched profile data and roomieBio.
        setState(() {
          myProfile = MyProfile(
            name: data['Name'],
            age: data['Age'].toString(),
            imageUrl: data['ImageUrl'],
            bio: data['Bio'],
            mbti: data['MBTI'],
            userType: data['User Type'],
            department: data['Department'],
            dormitory: data['Dormitory'],
            roommatePreferenceDormTime: data['roommatePreferenceDormTime'],
            roommatePreferenceGaming: data['roommatePreferenceGaming'],
            roommatePreferenceNationality:
                data['roommatePreferenceNationality'],
            roommatePreferenceSleep: data['roommatePreferenceSleep'],
            roommatePreferenceSmoking: data['roommatePreferenceSmoking'],
            roomieName: roomieName,
            roomieImage: data['roomieImage'],
            roomieBio: roomieBio, // Set the roomieBio from roomieInfo.
            roomieDescription: roomieDescription,
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
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.end, // Aligns the logo to the right
          children: [
            Image.asset('assets/Roomie/LOGO.png', height: 30),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.blue),
        //   onPressed: () {
        //     Navigator.of(context).pushReplacement(
        //       MaterialPageRoute(builder: (context) => MainPage()),
        //     );
        //   },
        // ),
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
                        onPressed: () async {
                          bool? result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(
                                  currentUser:
                                      FirebaseAuth.instance.currentUser!),
                            ),
                          );
                          if (result == true) {
                            fetchUserProfile(); // Refresh the profile data
                          }
                        },
                        child:
                            Text('Edit', style: TextStyle(color: Colors.blue)),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(myProfile!.imageUrl ??
                        'https://via.placeholder.com/150'),
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
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Bio",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                  SizedBox(height: 8), // Space between bio heading and bio text
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              myProfile!.bio ?? 'No Bio',
                              style: TextStyle(fontSize: 16),
                              
                            ),
                          ),
                        ],
                      )
                      // child: Text(
                      //   myProfile!.bio ?? 'No Bio',
                      //   style: TextStyle(fontSize: 16),
                      ),
                  SizedBox(height: 16), // Space before preferences heading
                  Divider(), // Spacer to push the preferences to the top
                  _buildDetailsSection(),
                  _buildLabelsSection(),
                  Divider(), // Spacer to push the preferences to the top

                  if (myProfile != null) ...[
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 32, 16, 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                      child: Text(
                        "My Preferences in Roommates",
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
                      value: myProfile!.roommatePreferenceDormTime ??
                          'Not specified',
                    ),
                    // Repeat this for each preference you want to show
                    PreferencesWidget(
                      title: 'Gaming',
                      value: myProfile!.roommatePreferenceGaming ??
                          'Not specified',
                    ),
                    PreferencesWidget(
                      title: 'Nationality',
                      value: myProfile!.roommatePreferenceNationality ??
                          'Not specified',
                    ),
                    PreferencesWidget(
                      title: 'Sleeping Habit',
                      value:
                          myProfile!.roommatePreferenceSleep ?? 'Not Specified',
                    ),
                    PreferencesWidget(
                      title: 'Smoking Habit',
                      value: myProfile!.roommatePreferenceSmoking ??
                          'Not specified',
                    ),
                    SizedBox(height: 16), // Space before roomie section
                    Divider(), // Spacer to push the preferences to the top
                    buildRoomieSection(myProfile!),
                  ],

                  SizedBox(height: 20), // Space at the bottom
                  Divider(), // Spacer to push the preferences to the top
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Retake test",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RetakePage(
                                      currentUser:
                                          FirebaseAuth.instance.currentUser!)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
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

class PreferencesWidget extends StatelessWidget {
  final String title;
  final String value;

  const PreferencesWidget({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Choose a less bright blue color
    final Color blueColor = Colors.blue.shade600;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1, // Reduced, so the title doesn't take too much space
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black, // Title text color
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 16), // Consistent spacing between title and value
          Expanded(
            flex: 2, // Increased, giving more width to the value box
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                  vertical: 12.0, horizontal: 20.0), // Increased padding
              decoration: BoxDecoration(
                border: Border.all(
                  color: blueColor, // Less bright blue color
                  width: 2, // Consistent border width
                ),
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
              ),
              child: Text(
                value,
                style: TextStyle(
                  color: blueColor, // Less bright blue color
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
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
  final String? mbti;
  final String? userType;
  final String? department;
  final String? dormitory;
  final String? roomieName;
  final String? roomieImage;
  final String? roomieBio;
  final String? roomieDescription;
  final String? roommatePreferenceDormTime;
  final String? roommatePreferenceGaming;
  final String? roommatePreferenceNationality;
  final String? roommatePreferenceSleep;
  final String? roommatePreferenceSmoking;

  MyProfile({
    this.name,
    this.age,
    this.imageUrl,
    this.bio,
    this.department,
    this.userType,
    this.mbti,
    this.dormitory,
    this.roomieName,
    this.roomieImage,
    this.roomieBio,
    this.roomieDescription,
    this.roommatePreferenceDormTime,
    this.roommatePreferenceGaming,
    this.roommatePreferenceNationality,
    this.roommatePreferenceSleep,
    this.roommatePreferenceSmoking,
  });
}
