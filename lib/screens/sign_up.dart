import 'package:classcritique/screens/sem_registration.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class signup extends StatefulWidget {
  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true; // Track password visibility
  bool _creatingAccount = false;

  void showCustomErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Image.asset(
                    'assets/undraw-Sign-up-n6im.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 0),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Center(
                    child: Text(
                      'create your account and have your voice heard!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      buildEmailFormField(),
                      SizedBox(height: 10),
                      buildPasswordFormField(),
                      SizedBox(height: 10),
                      buildConfirmPasswordFormField(),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: ElevatedButton(
                    onPressed: _creatingAccount
                        ? null
                        : () async {
                            setState(() {
                              _creatingAccount = true;
                            });
                            final email = emailController.text.trim();
                            final password = passwordController.text;
                            final confirmPassword =
                                confirmPasswordController.text;

                            // Add validation checks
                            if (email.isEmpty || !email.contains('@')) {
                              showCustomErrorSnackBar('Invalid email address');
                              setState(() {
                                _creatingAccount = false;
                              });
                              return; // Exit if email is invalid
                            }

                            if (password.length < 6) {
                              showCustomErrorSnackBar('Password is too short');
                              setState(() {
                                _creatingAccount = false;
                              });
                              return; // Exit if password is too short
                            }

                            if (password != confirmPassword) {
                              showCustomErrorSnackBar('Passwords do not match');
                              setState(() {
                                _creatingAccount = false;
                              });
                              return; // Exit if passwords don't match
                            }

                            try {
                              // Show a yellow snackbar as a loading indicator
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'creating account...',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: Colors.yellow,
                                ),
                              );

                              // Create a user with Firebase Authentication
                              UserCredential userCredential = await FirebaseAuth
                                  .instance
                                  .createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );

                              // Registration successful
                              print('User registered successfully!');
                              showSuccessSnackBar(
                                  'Account created successfully!');

                              // Send email to Firestore "users" collection
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userCredential.user?.uid)
                                  .set({
                                'email': email,
                                'user_id': userCredential.user?.uid,
                                // Add other user data fields if needed
                                'levels_id': null
                              });

                              // Close the loading snackbar
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();

                              // Navigate to the "registered" page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => registered(),
                                ),
                              );
                            } catch (e) {
                              // Handle registration errors
                              print('Registration error: $e');
                              showCustomErrorSnackBar('email already exists');
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar(); // Close loading snackbar
                            } finally {
                              setState(() {
                                _creatingAccount = false;
                              });
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(16),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'create account',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: GestureDetector(
              onTap: () {
                // Add your functionality here
              },
              child: Image.asset(
                'assets/return-button-png-34573.png',
                width: 60,
                height: 60,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmailFormField() {
    return Card(
      color: Color.fromRGBO(214, 214, 214, 0.5),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(Icons.email),
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                key: ValueKey('email'),
                obscureText: false,
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Add Your Email         *',
                  border: InputBorder.none,
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.normal,
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPasswordFormField() {
    return Card(
      color: Color.fromRGBO(214, 214, 214, 0.5),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(Icons.password),
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                key: ValueKey('password'),
                obscureText: _obscurePassword,
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Create Password',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.normal,
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildConfirmPasswordFormField() {
    return Card(
      color: Color.fromRGBO(214, 214, 214, 0.5),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(Icons.password),
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                key: ValueKey('confirm email'),
                obscureText: true,
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  border: InputBorder.none,
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.normal,
                ),
                textInputAction: TextInputAction.done,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _signup() async {
    //
  }
}
