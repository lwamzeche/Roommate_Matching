import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roomie_project/UI/survey_success.dart';
import './firestore_service.dart';

class ReorderablePage extends StatefulWidget {
  final User currentUser;
  ReorderablePage({required this.currentUser});

  @override
  _ReorderablePageState createState() => _ReorderablePageState();
}


class _ReorderablePageState extends State<ReorderablePage> {
  final List<String> _factors = ['Smoking', 'Time in Dorm', 'Sleeping Habits'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // TODO: Implement skip functionality
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SurveySuccessScreen(currentUser: widget.currentUser)),
              );
            },
            child: Text(
              'Take it Later',
              style: TextStyle(color: Colors.blue),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rank Your Preferences',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            RichText(
            text: TextSpan(
                style: TextStyle(fontSize: 16.0, color: Colors.black), // default style
                children: <TextSpan>[
                TextSpan(text: 'Rank these factors from '),
                TextSpan(text: 'most important', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' to '),
                TextSpan(text: 'least important', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' to find a roommate whose values closely align with yours.'),
                ],
            ),
            ),
            SizedBox(height: 16.0),
            // Text(
            //   'Most Important Factor',
            //   style: TextStyle(
            //     fontSize: 20.0,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            Expanded(
              child: ReorderableListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: <Widget>[
                  for (int index = 0; index < _factors.length; index++)
                    _buildReorderableItem(_factors[index], index),
                ],
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final String item = _factors.removeAt(oldIndex);
                    _factors.insert(newIndex, item);
                  });
                },
              ),
            ),
            // Text(
            //   'Least Important Factor',
            //   style: TextStyle(
            //     fontSize: 20.0,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () => _saveRankingToFirestore(),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 60), // Width and height
                ),
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReorderableItem(String factor, int index) {
    return Container(
      key: Key('$factor-$index'), // Unique key for the item
      height: 60,
      margin: const EdgeInsets.all(5),
      color: Colors.blue[400],
      child: Row(
        children: [
          Expanded(
            child: Text(
              factor,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          // Drag handle
          ReorderableDragStartListener(
            index: index,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(Icons.drag_handle, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _saveRankingToFirestore() async {
    try {
      FirebaseFirestore.instance.collection('userProfiles').doc(widget.currentUser.uid).set({
        'RankingArray': _factors,
      }, SetOptions(merge: true));
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SurveySuccessScreen(currentUser: widget.currentUser)),
      );
    } catch (e) {
      print(e); // Log the error
    }
  }
}