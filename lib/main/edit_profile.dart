import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  final User currentUser;

  EditProfilePage({required this.currentUser});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _dormitoryController = TextEditingController();

  String? _currentName;
  String? _currentAge;
  String? _currentDepartment;
  String? _currentBio;
  String? _currentDormitory;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    String? userId = widget.currentUser.uid;
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('userProfiles')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _currentName = data['Name'];
          _currentAge = data['Age'].toString();
          _currentDepartment = data['Department'];
          _currentBio = data['Bio'];
          _currentDormitory = data['Dormitory'];
        });
      }
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }

  Future<void> _saveProfile() async {
    Map<String, dynamic> updatedData = {};

    if (_nameController.text.isNotEmpty && _nameController.text != _currentName) {
      updatedData['Name'] = _nameController.text;
    }
    if (_ageController.text.isNotEmpty && _ageController.text != _currentAge) {
      updatedData['Age'] = int.tryParse(_ageController.text) ?? 0;
    }
    if (_departmentController.text.isNotEmpty && _departmentController.text != _currentDepartment) {
      updatedData['Department'] = _departmentController.text;
    }
    if (_bioController.text.isNotEmpty && _bioController.text != _currentBio) {
      updatedData['Bio'] = _bioController.text;
    }
    if (_dormitoryController.text.isNotEmpty && _dormitoryController.text != _currentDormitory) {
      updatedData['Dormitory'] = _dormitoryController.text;
    }

    if (updatedData.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('userProfiles')
          .doc(widget.currentUser.uid)
          .update(updatedData)
          .then((value) => Navigator.pop(context, true))
          .catchError((error) => print("Failed to update user profile: $error"));
    } else {
      Navigator.pop(context, false); // No update was made
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: _currentName,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(
                labelText: 'Age',
                hintText: _currentAge,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _departmentController,
              decoration: InputDecoration(
                labelText: 'Department',
                hintText: _currentDepartment,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            TextField(
              controller: _dormitoryController,
              decoration: InputDecoration(
                labelText: 'Dormitory',
                hintText: _currentDormitory,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                labelText: 'Bio',
                hintText: _currentBio,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Save'),
              onPressed: _saveProfile,
            ),
          ],
        ),
      ),
    );
  }
}
