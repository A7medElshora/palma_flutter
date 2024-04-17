import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add any initialization logic here
    // You may navigate to another screen after a delay using Navigator
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    // Example: Navigate to the home screen after 5 seconds
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacementNamed(context, '/home'); // Replace '/home' with your desired route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF56B098), // Background color #3C6255
      body: Center(
        child:
          // Image(image: AssetImage("assets/images/splash.png"))
        Lottie.asset('assets/images/hi.json'), // Load Lottie animation from asset
      ),
    );
  }
}
