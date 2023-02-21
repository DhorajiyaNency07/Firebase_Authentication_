import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storege_google/auth_screen/email_pass_sign_in_screen.dart';
import 'package:firebase_storege_google/screen_flow/home_screen.dart';
import 'package:flutter/material.dart';

class EmailPasswordLoginScreen extends StatefulWidget {
  const EmailPasswordLoginScreen({Key? key}) : super(key: key);

  @override
  State<EmailPasswordLoginScreen> createState() =>
      _EmailPasswordLoginScreenState();
}

class _EmailPasswordLoginScreenState extends State<EmailPasswordLoginScreen> {
  // FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email password login screen'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Enter Email",
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.black87),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: passwordController,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: "Enter password",
                  labelText: "password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.black87),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  userLogin();
                },
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(const Size(220, 50)),
                ),
                child: const Text(
                  "Login In",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmailPasswordSignInScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Create a new account",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      user = FirebaseAuth.instance.currentUser;
      debugPrint("User data --------->> $user");

      if (user!.emailVerified) {
        debugPrint("User Is Login ------------------>>> ");
        DocumentSnapshot data = await users.doc(user!.uid).get();
        debugPrint(
            "User Is Login ------------------>>> ${jsonEncode(data.data())}");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        debugPrint('The email provided is wrong.');
      } else if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      } else if (e.code == 'unknown') {
        debugPrint('Please provide email and password');
      }
    } catch (e) {
      debugPrint("Error ----->> $e");
    }
  }

  navigator() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
        (route) => false);
  }
}





// userLogin() async {
//   try {
//     await FirebaseAuth.instance.signInWithEmailAndPassword(
//       email: emailController.text,
//       password: passwordController.text,
//     );
//
//     user = FirebaseAuth.instance.currentUser;
//     debugPrint("User data --------->> $user");
//
//     if (user!.emailVerified) {
//       debugPrint("currentUser ----------------> ${user!.emailVerified}");
//       navigator();
//     } else {
//       debugPrint('verify your email');
//     }
//   } on FirebaseAuthException catch (e) {
//     if (e.code == 'user-not-found') {
//       debugPrint('No user found for that email.');
//     } else if (e.code == 'wrong-password') {
//       debugPrint('Your password do not match please try again.');
//     } else if (e.code == 'weak password') {
//       debugPrint('password is weak');
//     }
//   } catch (e) {
//     debugPrint("Error ----->> $e");
//   }
// }
// ///////
