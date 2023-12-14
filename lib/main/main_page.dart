// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:roomie_project/main/list_chat.dart';
import 'package:roomie_project/main/my_profile.dart';
import 'package:roomie_project/main/view_profile.dart';
import 'matches.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'match_page.dart';

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
  Map<String, dynamic> currentUserPreferences = {};

  @override
  void initState() {
    super.initState();
    fetchCurrentUserInfo();
    // fetchProfilesFromFirestore();
  }

  Future<void> fetchCurrentUserInfo() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    DocumentSnapshot snapshot =
        await firestore.collection('userProfiles').doc(uid).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    UserProfile currentUserProfile = UserProfile(
      id: uid,
      dormitory: data['Dormitory'],
      userType: data['User Type'],
      sleepingHabit: data['roommatePreferenceSleep'],
      timeInDorm: data['roommatePreferenceDormTime'],
      smokingHabit: data['roommatePreferenceDormSmoking'],
      preferenceNationality: data['roommatePreferenceNationality'],
    );
    setState(() {
      currentUserPreferences = {
        'Dormitory': currentUserProfile.dormitory,
        'User Type': currentUserProfile.userType,
        'roommatePreferenceSleep': currentUserProfile.sleepingHabit,
        'roommatePreferenceDormTime': currentUserProfile.timeInDorm,
        'roommatePreferenceDormSmoking': currentUserProfile.smokingHabit,
        'roommatePreferenceNationality':
            currentUserProfile.preferenceNationality,
      };
      debugPrint(
          'Current user preferences: $currentUserPreferences'.toString());
      fetchProfilesFromFirestore();
    });
  }

  Future<void> fetchProfilesFromFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    String currentUserUid = auth.currentUser!.uid;

    // Fetching the current user's profile data to compare with other profiles
    DocumentSnapshot currentUserSnapshot =
        await firestore.collection('userProfiles').doc(currentUserUid).get();
    Map<String, dynamic> currentUserData =
        currentUserSnapshot.data() as Map<String, dynamic>;
    String currentUserGender = currentUserData['Gender'];

    // Fetching all user profiles from Firestore
    QuerySnapshot snapshot = await firestore.collection('userProfiles').get();
    List<UserProfile> fetchedProfiles = [];

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // Skipping the current user's profile
      if (doc.id == currentUserUid) {
        continue;
      }

      // Filtering out profiles with a different gender if needed
      if (data['Gender'] != currentUserGender) {
        continue;
      }

      try {
        // Constructing a UserProfile object for each fetched profile
        UserProfile profile = UserProfile(
          id: doc.id, // Assigning the Firestore document ID to the profile
          name: data['Name'],
          age: data['Age'].toString(),
          bio: data['Bio'],
          mbti: data['MBTI'],
          imageUrl: data['ImageUrl'],
          department: data['Department'],
          dormitory: data['Dormitory'],
          schoolProgram: data['School Program'],
          userType: data['User Type'],
          sleepingHabit: data['roommatePreferenceSleep'],
          timeInDorm: data['roommatePreferenceDormTime'],
          smokingHabit: data['roommatePreferenceSmoking'],
          gamingHabit: data['roommatePreferenceGaming'],
          roomieImage: data['roomieImage'],
          roomieName: data['roomieName'],
          roomieBio: data['roomieBio'],
          roomieDescription: data['roomieDescription'],
          preferenceNationality: data['roommatePreferenceNationality'],
          matchPercentage: 0.0, // Initial match percentage set to 0.0
        );

        // Calculating the match percentage based on the current user's preferences
        double match =
            calculateMatchPercentage(profile, currentUserPreferences);
        profile.matchPercentage = match;
        debugPrint('Match for ${profile.name}: $match%');
        fetchedProfiles.add(profile);
      } catch (e) {
        print('Error in fetchProfilesFromFirestore: $e');
      }
    }

    // Updating the state with the fetched and processed profiles
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

  double calculateMatchPercentage(
      UserProfile profile, Map<String, dynamic> preferences) {
    // debugPrint('Preferences: $preferences'.toString()); // this is currentUser information
    double matchPercentage = 0;
    if (profile.dormitory == preferences['Dormitory']) {
      matchPercentage += 0.2;
    }
    if (profile.preferenceNationality == preferences['User Type']) {
      matchPercentage += 0.2;
    }
    if (profile.sleepingHabit == preferences['roommatePreferenceSleep']) {
      matchPercentage += 0.2;
    }
    if (profile.timeInDorm == preferences['roommatePreferenceDormTime']) {
      matchPercentage += 0.2;
    }
    if (profile.smokingHabit == preferences['roommatePreferenceSmoking']) {
      matchPercentage += 0.2;
    }
    return matchPercentage;
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

  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ViewProfilePage(userProfile: profile),
      ),
    );
  }

  void _connectWithThem(BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String user1Id =
        FirebaseAuth.instance.currentUser!.uid; // ID of the current user
    String user2Id = profile.id; // ID of the user to connect with
    double matchPercentage = profile.matchPercentage; // Match percentage

    DocumentReference userMatchesDoc =
        firestore.collection('matches').doc(user1Id);

    firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userMatchesDoc);

      // If the document does not exist, create a new one with user2Id and matchPercentage in the list
      if (!snapshot.exists) {
        transaction.set(userMatchesDoc, {
          'user2Id': [user2Id],
          'matchPercentage': [
            matchPercentage
          ], // Store as an array of match percentages
          'timestamp': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Match with $user2Id added successfully')),
        );
        return;
      }

      // If the document exists, update the list of user2Id and match percentages
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<dynamic> existingMatches = List.from(data['user2Id'] ?? []);
      List<dynamic> matchPercentages = List.from(data['matchPercentage'] ?? []);

      if (!existingMatches.contains(user2Id)) {
        existingMatches.add(user2Id);
        matchPercentages.add(
            matchPercentage); // Add match percentage at the corresponding index
        transaction.update(userMatchesDoc, {
          'user2Id': existingMatches,
          'matchPercentage':
              matchPercentages // Update the array of match percentages
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Match with $user2Id added successfully')),
        // );
      } else {
        // If user2Id is already in the list, show a pop-up message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$user2Id is already in your matches list')),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add match: $error')),
      );
    });

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MatchPage(
        currentUserId: FirebaseAuth.instance.currentUser!.uid,
        matchedUserId: profile.id,
        matchPercentage: profile.matchPercentage,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () => _navigateToProfile(context),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                profile.imageUrl ?? 'https://via.placeholder.com/150',
                width: double.infinity,
                height: screenSize.height * 0.7,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: InkWell(
                onTap: () => _navigateToProfile(context),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
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
                      Text(
                        // "match percentage is not defined",
                        "Match: ${(profile.matchPercentage * 100).toStringAsFixed(0)}%",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => _navigateToProfile(context),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                            SizedBox(height: 2),
                            Text(
                              profile.department ?? 'Department: Unavailable',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            SizedBox(height: 16),
                            Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 8.0,
                              children: [
                                Chip(
                                  label:
                                      Text(profile.mbti ?? 'MBTI: Unavailable'),
                                  labelStyle: TextStyle(color: Colors.white),
                                  backgroundColor: Colors.blue.shade300,
                                ),
                                Chip(
                                  label: Text(profile.dormitory ??
                                      'Dormitory: Unavailable'),
                                  labelStyle: TextStyle(color: Colors.white),
                                  backgroundColor: Colors.blue.shade300,
                                ),
                                Chip(
                                  label: Text(profile.userType ??
                                      'User Type: Unavailable'),
                                  labelStyle: TextStyle(color: Colors.white),
                                  backgroundColor: Colors.blue.shade300,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _connectWithThem(context),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 8.0),
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        child: Text('Connect with them'),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
  final String? roomieDescription;
  final String? preferenceNationality;
  final String? gamingHabit;
  final String id;
  double matchPercentage;

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
    this.roomieDescription,
    this.preferenceNationality,
    required this.id,
    this.matchPercentage = 0.0,
    this.gamingHabit,
  });

  factory UserProfile.fromDocument(DocumentSnapshot doc) {
    return UserProfile(
      id: doc.id,
    );
  }
}
