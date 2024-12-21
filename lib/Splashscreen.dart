import 'package:flutter/material.dart';
import 'package:flutter_app_assignment/Phoneauth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'adminPage.dart';
import 'userPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginState(context);
  }

  Future<void> checkLoginState(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final role = prefs.getString('role') ?? '';

    if (isLoggedIn) {
      if (role == 'admin123') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPage(name: 'admin123')),
        );
      } else if (role == 'user123') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserPage(name: 'user123')),
        );
      }
    }
    else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PhoneAuthScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(color: Colors.green,),
      ),
    );
  }
}
