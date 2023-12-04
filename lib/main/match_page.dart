import 'package:flutter/material.dart';
import 'main_page.dart'; // Make sure this import points to the correct file
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchPage extends StatefulWidget {
  final String currentUserId;
  final String matchedUserId;
  final double matchPercentage;

  MatchPage({
    required this.currentUserId,
    required this.matchedUserId,
    required this.matchPercentage,
  });

  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  String currentUserImageUrl = '';
  String matchedUserImageUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchUserImages();
  }

  Future<void> _fetchUserImages() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Fetch Current User Image
    DocumentSnapshot currentUserSnapshot = await firestore
        .collection('userProfiles')
        .doc(widget.currentUserId)
        .get();
    if (currentUserSnapshot.data() is Map<String, dynamic>) {
      Map<String, dynamic> currentUserData =
          currentUserSnapshot.data() as Map<String, dynamic>;
      currentUserImageUrl = currentUserData['ImageUrl'] ?? 'default_image_url';
    }

    // Fetch Matched User Image
    DocumentSnapshot matchedUserSnapshot = await firestore
        .collection('userProfiles')
        .doc(widget.matchedUserId)
        .get();
    if (matchedUserSnapshot.data() is Map<String, dynamic>) {
      Map<String, dynamic> matchedUserData =
          matchedUserSnapshot.data() as Map<String, dynamic>;
      matchedUserImageUrl = matchedUserData['ImageUrl'] ?? 'default_image_url';
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the top margin dynamically based on screen size
    double topMargin = MediaQuery.of(context).size.height * 0.2;

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: topMargin,
            child: Text(
              "It's a Match!",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          // Positioned widgets for images and percentage
          Positioned(
            top: topMargin + 50, // Adjust the position according to your design
            left: 50, // Left margin for the first image
            child: ClipOval(
              child: Image.network(
                currentUserImageUrl,
                height: 150, // Adjust the size according to your design
                width: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.person, size: 150),
              ),
            ),
          ),
          Positioned(
            top: topMargin +
                50, // This should be the same as the first image for alignment
            right: 50, // Right margin for the second image
            child: ClipOval(
              child: Image.network(
                matchedUserImageUrl,
                height: 150, // Adjust the size according to your design
                width: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.person, size: 150),
              ),
            ),
          ),
          Positioned(
            top: topMargin + 110, // Position for the match percentage
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${(widget.matchPercentage * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100, // Adjust this value to position the button as needed
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Keep Scrolling'),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
