// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, library_private_types_in_public_api
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
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Explicitly cast to File here
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

    // Navigate based on the index tapped
    switch (index) {
      case 0:
        // Navigate to home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
        break;
      case 2:
        // Navigate to profile
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyChatsScreen()),
        );
        break;
      default:
        // Handle other tabs if necessary
        break;
    }
  }

  ImageProvider<Object> _getImage() {
    if (_image != null) {
      return FileImage(_image!); // Use FileImage with the File object
    } else {
      return AssetImage(
          'assets/Roomie/avatar.png'); // Fallback to a placeholder image
    }
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              GestureDetector(
                onTap: _chooseImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _getImage(),
                  backgroundColor: Colors.grey[200],
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
