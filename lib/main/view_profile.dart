import 'package:flutter/material.dart';
import 'main_page.dart';

class ViewProfilePage extends StatelessWidget {
  final UserProfile userProfile;

  ViewProfilePage({Key? key, required this.userProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            _buildRoomieHeading(),
             _buildRoomieSection(context),
            Divider(),
            _buildRoommatePreferencesSection(),
            _buildPreferencesSection(),
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
          userProfile.imageUrl ?? 'https://via.placeholder.com/150',
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
                '${userProfile.name ?? 'Unavailable'}, ${userProfile.age ?? 'N/A'} yrs',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                '${userProfile.department ?? 'N/A'}',
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
          Text(userProfile.bio ?? 'N/A'),
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
          Text('All about ${userProfile.name ?? 'User'}',
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
          _buildLabel(userProfile.mbti ?? 'MBTI: Unavailable'),
          _buildLabel(userProfile.dormitory ?? 'Dormitory: Unavailable'),
          _buildLabel(userProfile.userType ?? 'User Type: Unavailable'),
        ],
      ),
    );
  }

  Widget _buildRoommatePreferencesSection() {
    return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: EdgeInsets.only(left: 16.0, top: 16.0),
        child: Flexible(
        child: Text(
          "${userProfile.name ?? 'User'}'s Preferences in Roommates",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
       ),
      ),
      ],
    );
  }
    Widget _buildPreferencesSection() {
      return Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 4.0),
        child: Wrap(
          spacing: 8.0,
          children: <Widget>[
            _buildLabel(userProfile.sleepingHabit ?? 'Sleeping Habit'),
            _buildLabel(userProfile.timeInDorm ?? 'Time in Dorm'),
            _buildLabel(userProfile.smokingHabit ?? 'Smoking Habit'),
          ],
        ),
      );
    }

  Widget _buildLabel(String text) {
    return Chip(
      label: Text(text),
      labelStyle: TextStyle(color: Colors.blue),
      backgroundColor: Colors.white,
      shape: StadiumBorder(side: BorderSide(color: Colors.blue)),
    );
  }

  Widget _buildRoomieHeading(){
    return Row (
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
        padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
        child: Text(
          "${userProfile.name ?? 'User'}'s Roomie",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
         ),
        ),
      ],
    );
  }

  Widget _buildRoomieSection(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
          child: Text(
            "${userProfile.roomieName ?? 'User'}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(height: 8), // Space between heading and roomie name
      Container(
        width: MediaQuery.of(context).size.width * 0.9, 
        padding: EdgeInsets.symmetric(horizontal: 16.0), 
        child: userProfile.roomieImage != null 
          ? Image.network(
              userProfile.roomieImage!,
              fit: BoxFit.cover, 
            )
          : SizedBox(height: 250, child: Placeholder()), 
      ),
      SizedBox(height: 16), // Space between roomie name and image
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Text(
          userProfile.roomieBio ?? 'Roomie Bio',
          style: TextStyle(fontSize: 16),
        ),
      ),
    ],
  );
}

}


