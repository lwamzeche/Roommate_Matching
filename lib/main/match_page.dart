import 'package:flutter/material.dart';
import 'main_page.dart';
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
    DocumentSnapshot currentUserSnapshot = await firestore.collection('userProfiles').doc(widget.currentUserId).get();
    if (currentUserSnapshot.data() is Map<String, dynamic>) {
      Map<String, dynamic> currentUserData = currentUserSnapshot.data() as Map<String, dynamic>;
      currentUserImageUrl = currentUserData['ImageUrl'] ?? 'default_image_url';
    }
    // currentUserImageUrl = currentUserSnapshot.data()['ImageUrl'];

    // Fetch Matched User Image
    DocumentSnapshot matchedUserSnapshot = await firestore.collection('userProfiles').doc(widget.matchedUserId).get();
    if (matchedUserSnapshot.data() is Map<String, dynamic>) {
      Map<String, dynamic> matchedUserData = matchedUserSnapshot.data() as Map<String, dynamic>;
      matchedUserImageUrl = matchedUserData['ImageUrl'] ?? 'default_image_url';
    }
    // matchedUserImageUrl = matchedUserSnapshot.data()['ImageUrl'];

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "It's a Match!",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network(currentUserImageUrl, height: 100, errorBuilder: (context, error, stackTrace) => Icon(Icons.person, size: 100)),
                Text(
                  '${(widget.matchPercentage * 100).toStringAsFixed(0)}%',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Image.network(matchedUserImageUrl, height: 100, errorBuilder: (context, error, stackTrace) => Icon(Icons.person, size: 100)),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Next'),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



