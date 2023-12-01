// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:roomie_project/main/list_chat.dart';
import 'package:roomie_project/main/my_profile.dart';
import 'package:roomie_project/main/view_profile.dart';
import 'matches.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roomie',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        iconTheme: IconThemeData(color: Colors.blue),
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  // final User currentUser;
  // MainPage({required this.currentUser});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<UserProfile> profiles = [];

  @override
  void initState() {
    super.initState();
    fetchProfilesFromFirestore();
  }

  Future<void> fetchProfilesFromFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection('userProfiles').get();

    List<UserProfile> fetchedProfiles = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return UserProfile(
        name: data['Name'],
        age: data['Age'].toString(),
        bio: data['Bio'],
        imageUrl: data['ImageUrl'],
        department: data['Department'],
        dormitory: data['Dormitory'],
        mbti: data['MBTI'],
        schoolProgram: data['School Program'],
        userType: data['User Type'],
        sleepingHabit: data['sleepingHabit'],
        timeInDorm: data['timeInDorm'],
        smokingHabit: data['smokingHabit'],
        roomieImage: data['roomieImage'],
        roomieName: data['roomieName'],
        roomieBio: data['roomieBio'],
      );
    }).toList();

    setState(() {
      profiles = fetchedProfiles;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MatchesPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyChatsScreen()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyProfilePage()),
      );
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
      ),
      body: profiles.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Swiper(
              itemBuilder: (BuildContext context, int index) {
                return ProfileCard(profile: profiles[index]);
              },
              itemCount: profiles.length,
              layout: SwiperLayout.STACK,
              itemWidth: MediaQuery.of(context).size.width * 0.8,
              itemHeight: MediaQuery.of(context).size.height * 0.6,
              pagination: SwiperPagination(),
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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

class ProfileCard extends StatelessWidget {
  final UserProfile profile;

  ProfileCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    // Determine the size of the screen for responsive layout
    final Size screenSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              profile.imageUrl ?? 'https://via.placeholder.com/150',
              width: double.infinity,
              height: screenSize.height * 0.7, // 60% of the screen height
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 16, // Adjust the positioning as needed
            right: 16, // Adjust the positioning as needed
            child: InkWell(
              onTap: () {
                // TODO: Navigate to the full profile view
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ViewProfilePage(userProfile: profile),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue, // Use your brand color
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.unfold_more, // Replace with a suitable icon
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 1),
                  ],
                ),
              ),
            ),
          ),

          // Blue information box
          Positioned(
            left: 0,
            right: 0,
            bottom: screenSize.height *
                0.0021, // Adjust this value as needed to position the blue box
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ViewProfilePage(userProfile: profile),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Centered Row for Name and Age
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${profile.name ?? 'Unavailable'}, ${profile.age ?? 'N/A'} yrs',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: 8), // Space between name/age and department
                      // Department Text with smaller font
                      Text(
                        profile.department ?? 'Department: Unavailable',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16), // Smaller font size for department
                      ),
                      SizedBox(
                          height:
                              16), // Space between department and attributes
                      // Attributes Row
                      Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 8.0, // Space between chips
                        children: [
                          Chip(
                            label: Text(profile.mbti ?? 'MBTI: Unavailable'),
                            labelStyle: TextStyle(color: Colors.white),
                            backgroundColor: Colors.blue.shade300,
                          ),
                          Chip(
                            label: Text(
                                profile.dormitory ?? 'Dormitory: Unavailable'),
                            labelStyle: TextStyle(color: Colors.white),
                            backgroundColor: Colors.blue.shade300,
                          ),
                          Chip(
                            label: Text(
                                profile.userType ?? 'User Type: Unavailable'),
                            labelStyle: TextStyle(color: Colors.white),
                            backgroundColor: Colors.blue.shade300,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserProfile {
  final String? name;
  final String? age;
  final String? bio;
  final String? imageUrl;
  final String? department;
  final String? dormitory;
  final String? mbti;
  final String? schoolProgram;
  final String? userType;
  final String? sleepingHabit;
  final String? timeInDorm;
  final String? smokingHabit;
  final String? roomieImage;
  final String? roomieName;
  final String? roomieBio;

  UserProfile({
    this.name,
    this.age,
    this.bio,
    this.imageUrl,
    this.department,
    this.dormitory,
    this.mbti,
    this.schoolProgram,
    this.userType,
    this.sleepingHabit,
    this.timeInDorm,
    this.smokingHabit,
    this.roomieImage,
    this.roomieName,
    this.roomieBio,
  });
}
