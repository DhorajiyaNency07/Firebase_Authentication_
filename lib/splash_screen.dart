import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storege_google/auth_screen/email_pass_log_in_screen.dart';
import 'package:firebase_storege_google/screen_flow/fire_storege_screen.dart';
import 'package:firebase_storege_google/screen_flow/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user;

  @override
  void initState() {
    // TODO: implement initState

    if (FirebaseAuth.instance.currentUser != null) {
      debugPrint(
          "current user ------------>>> $FirebaseAuth.instance.currentUser!");
      user = FirebaseAuth.instance.currentUser;
    }

    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (user != null && user!.emailVerified) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              // builder: (context) => const FireStoreScreen(),
              builder: (context) => const EmailPasswordLoginScreen(),
            ),
            (route) => false,
          );
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            FlutterLogo(
              size: 100,
              style: FlutterLogoStyle.markOnly,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Firebase',
              style: TextStyle(
                color: Colors.black,
                fontSize: 45,
              ),
            )
          ],
        ),
      ),
    );
  }
}
