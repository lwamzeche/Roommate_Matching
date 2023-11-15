// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'user_type.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        print('Login successful');
        print(userCredential.user!.email);
        print(userCredential.user!.uid);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => UserTypeScreen(currentUser: userCredential.user!)),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in. Please check your credentials.'))
      );
    }
  }
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
                  controller: _emailController,
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
                  controller: _passwordController,
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
                  // onPressed: () {
                  //   Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (context) => UserTypeScreen()),
                  //   );
                  // },
                  onPressed: () => _login(context),
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
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context) => UserTypeScreen( )),
                    // );
                    _login(context); //trying two logins 
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
