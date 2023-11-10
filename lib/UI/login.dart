// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'user_type.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Getting screen size for responsive layout
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight, // Align logo to the top right
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: screenSize.height *
                            0.1), // Add some padding at the top
                    child: Image.asset(
                      'assets/Roomie/LOGO.png', // Replace with your asset image path for logo
                      height:
                          screenSize.height * 0.04, // Adjust the size as needed
                    ),
                  ), // Adjust the size as needed
                ),
                SizedBox(height: screenSize.height * 0.05),
                Text(
                  'Welcome',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.1, // Responsive font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Login into your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.05, // Responsive font size
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.08),
                // Email TextField
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    hintText: 'Enter your email',
                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),
                // Password TextField
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    hintText: 'Enter your password',
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: Text('Forgot password?'),
                    onPressed: () {
                      // TODO: Implement forgot password functionality
                    },
                  ),
                ),
                SizedBox(height: screenSize.height * 0.11),
                // University Login Button
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => UserTypeScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: screenSize.height *
                          0.022, // Increase vertical padding for bigger height
                      horizontal: 30.0,
                    ),
                  ),
                  child: Text('University login'),
                ),
                SizedBox(height: screenSize.height * 0.02),
                // Login Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => UserTypeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Use backgroundColor
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30.0), // Rounded border
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.022,
                        horizontal: 30.0), // Padding inside the button
                  ),
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
