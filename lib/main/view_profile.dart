import 'package:flutter/material.dart';
import 'main_page.dart';

class ViewProfilePage extends StatelessWidget {
  final UserProfile userProfile;

  // Constructor
  ViewProfilePage({Key? key, required this.userProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userProfile.name ?? 'Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildProfileImage(),
            _buildProfileDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Image.network(
      userProfile.imageUrl ?? 'https://via.placeholder.com/150',
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget _buildProfileDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Name: ${userProfile.name ?? 'N/A'}', style: TextStyle(fontSize: 20)),
          Text('Age: ${userProfile.age ?? 'N/A'}'),
          Text('Bio: ${userProfile.bio ?? 'N/A'}'),
          Text('Department: ${userProfile.department ?? 'N/A'}'),
          // Add more fields as necessary
        ],
      ),
    );
  }
}