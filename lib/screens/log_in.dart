import 'package:classcritique/screens/loggedIn.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class login extends StatefulWidget {
  const login({Key? key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  String email = "";
  String password = "";

  final _formKey = GlobalKey<FormState>();

  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  Future<void> userLogin() async {
    try {
      // Show a yellow snackbar while verifying details
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(width: 10),
            Text(
              'Please wait...',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.yellow,
        duration: Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ));

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Close the "Please wait..." snackbar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      // Show a green snackbar after successful login
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              'Welcome back!',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ));

      // Navigate to the LoggedIn page after successful login
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LoggedIn(user: FirebaseAuth.instance.currentUser!),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Close the "Please wait..." snackbar on error
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (e.code == 'user-not-found') {
        showCustomErrorSnackBar("No User Found for that Email");
      } else if (e.code == 'wrong-password') {
        showCustomErrorSnackBar("Wrong Password Provided by User");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Image.asset(
                    'assets/undrawauthenticationresvpt-1.png',
                    width: MediaQuery.of(context).size.width * 1.5,
                    height: MediaQuery.of(context).size.height * 0.4,
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 7.0, top: 0.0),
                  child: Center(
                    child: Text(
                      "log into your account and have your voice heard!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 3.0),
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 220, 218, 218),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: userEmailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        showCustomErrorSnackBar('Please Enter E-Mail');
                        return null;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.email,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      hintText: 'enter your email',
                      hintStyle: TextStyle(color: Colors.white60),
                    ),
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 3.0),
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 220, 218, 218),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: userPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        showCustomErrorSnackBar('Please Enter Password');
                        return null;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.password,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      hintText: 'enter your password',
                      hintStyle: TextStyle(color: Colors.white60),
                    ),
                    style: TextStyle(
                      color: Color.fromARGB(255, 13, 13, 13),
                      fontFamily: 'Poppins',
                    ),
                    obscureText: true,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.only(right: 24.0),
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "",
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        email = userEmailController.text;
                        password = userPasswordController.text;
                      });
                      userLogin();
                    }
                  },
                  child: Center(
                    child: Container(
                      width: 300,
                      height: 60,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          "log in",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: .0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "you a new user?",
                      style: TextStyle(
                        color: Color.fromARGB(255, 29, 28, 28),
                        fontSize: 20.0,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoggedIn(
                                user: FirebaseAuth.instance.currentUser!),
                          ),
                        );
                      },
                      child: Text(
                        " signup",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showCustomErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error,
              color: Color.fromARGB(255, 4, 4, 4),
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
}
