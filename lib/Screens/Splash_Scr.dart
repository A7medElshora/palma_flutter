import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // تهيئة التحكم في الرسوم المتحركة
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    // تهيئة الرسوم المتحركة للتلاشي
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    // تهيئة الرسوم المتحركة للتكبير
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // تهيئة الرسوم المتحركة للتحرك من الأسفل إلى الأعلى
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // بدء الرسوم المتحركة
    _controller.forward();

    // الانتقال إلى الشاشة الرئيسية بعد انتهاء الرسوم المتحركة
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3C6255), // لون الخلفية
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // عرض الرسوم المتحركة
           
            SizedBox(height: 20),
            // اسم التطبيق مع تأثيرات نصية
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.translate(
                      offset: _slideAnimation.value * 50, // تحريك النص من الأسفل إلى الأعلى
                      child: Text(
                        "Fentie",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            // نص إضافي مع تأثيرات
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.translate(
                      offset: _slideAnimation.value * 50, // تحريك النص من الأسفل إلى الأعلى
                      child: Text(
                        "Your Plant Care Companion",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.8),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Add any initialization logic here
//     // You may navigate to another screen after a delay using Navigator
//     _navigateToNextScreen();
//   }

//   void _navigateToNextScreen() async {
//     // Example: Navigate to the home screen after 5 seconds
//     await Future.delayed(Duration(seconds: 3));
//     Navigator.pushReplacementNamed(context, '/home'); // Replace '/home' with your desired route
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF56B098), // Background color #3C6255
//       body: Center(
//         child:
//           // Image(image: AssetImage("assets/images/splash.png"))
//         Lottie.asset('assets/images/hi.json'), // Load Lottie animation from asset
//       ),
//     );
//   }
// }
