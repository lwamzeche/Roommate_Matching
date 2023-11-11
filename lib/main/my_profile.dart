// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../UI/sleep_habit.dart';
import 'list_chat.dart';
import 'main_page.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  int _selectedIndex = 3;

  final _nameController = TextEditingController();
  final _majorController = TextEditingController();
  final _bioController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _majorController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _chooseImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _onNavBarTapped(int index) {
    if (_selectedIndex == index) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainPage()));
        break;
      case 2:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyChatsScreen()));
        break;
      default:
        break;
    }
  }

  ImageProvider<Object> _getImage() {
    if (_image != null) {
      return FileImage(_image!);
    } else {
      return AssetImage('assets/Roomie/avatar.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/Roomie/LOGO.png', height: 30),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement navigation to edit profile
                  },
                  child: Text('Edit', style: TextStyle(color: Colors.blue)),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              GestureDetector(
                onTap: _chooseImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _getImage(),
                  backgroundColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name and Age',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _majorController,
                decoration: InputDecoration(
                  labelText: 'Major',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bio',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _bioController,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SleepHabitScreen()));
                  },
                  child: Text(
                    'Retake tests',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Matches'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: _onNavBarTapped,
      ),
    );
  }
}
