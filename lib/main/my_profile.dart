// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../UI/sleep_habit.dart';
import 'main_page.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final _nameController = TextEditingController(text: "Lily Evans, 22 yrs");
  final _majorController = TextEditingController(text: "Industrial Design");
  final _bioController = TextEditingController(
      text:
          "Hey there! I’m Lily, a software engineer enthusiast with a passion for exploring the world. Originally from Suwon, I recently moved to Daejeon to study at KAIST. I’m cheerful and outgoing person who values a balance between work and play.");
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
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  void _onNavBarTapped(int index) {
    setState(() {
      // Update the selected index here if you want to keep the BottomNavigationBar in sync
      // _selectedIndex = index;
    });

    if (index == 0) {
      // Home
      Navigator.pushReplacementNamed(
          context, '/home'); // Use the named route for your home screen
    } else if (index == 2) {
      // Chats
      Navigator.pushReplacementNamed(
          context, '/Chats'); // Use the named route for your chats screen
    } else if (index == 3) {
      // Profile
      // Here we are already in profile, so we may not want to push the screen again
      // This is just a placeholder if you have a different profile screen to navigate to
      Navigator.pushReplacementNamed(context, '/profile');
    }
    // Handle other indices if there are other screens
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/Roomie/LOGO.png',
            height: 30), // Replace with your assets image path
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Expanded(
            // Use Expanded widget to push the logo to the right
            child: Align(
              alignment: Alignment.topRight,
              child: Image.asset('assets/Roomie/LOGO.png',
                  height: 30), // Your asset image path
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement navigation to edit profile
            },
            child: Text('Edit', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.1), // Adds space at the top, adjust the multiplier as needed
              GestureDetector(
                onTap: _chooseImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _image != null
                      ? FileImage(_image!) as ImageProvider
                      : AssetImage('assets/Roomie/Michelle Choi.jpg'),
                ),
              ),
              SizedBox(height: 16),
              Text(
                _nameController.text,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                _majorController.text,
                style: TextStyle(fontSize: 16, color: Colors.grey),
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
              Text(
                _bioController.text,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => SleepHabitScreen()),
                    );
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
      // Bottom navigation remains the same...
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
