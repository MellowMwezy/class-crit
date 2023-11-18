import 'package:classcritique/screens/authentication_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX package

void main() async {
  // Initialize Firebase before running the app.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp()); // Use the MyApp widget as the entry point.
}

// Add a simple binding class to initialize GetX
class AppBinding extends Bindings {
  @override
  void dependencies() {
    // You can add more dependencies here if needed
  }
}

class DefaultFirebaseOptions {
  static var platform;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Use GetMaterialApp instead of MaterialApp
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      initialBinding: AppBinding(), // Initialize GetX bindings
      home: SplashScreen(), // Set SplashScreen as the initial screen.
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Add any initialization or loading tasks here if needed.

    // Simulate a delay (e.g., 2 seconds) before navigating to the main content.
    Future.delayed(Duration(seconds: 2), () {
      Get.off(
        () =>
            Home(), // Use Get.off() instead of Navigator.of(context).pushReplacement
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // You can customize your splash screen's design here.
    return Center(
      child:
          CircularProgressIndicator(), // You can replace this with your splash screen content.
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return authenticate();
  }
}

// Create UserController separately
class UserController extends GetxController {
  // Your controller logic goes here
}
