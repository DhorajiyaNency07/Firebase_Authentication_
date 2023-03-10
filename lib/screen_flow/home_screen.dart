/// pick image and get image on firestore
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  User? user;
  final ImagePicker picker = ImagePicker();
  XFile? image;

  @override
  void initState() {
    // TODO: implement initState
    user = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image == null
                ? const SizedBox()
                : Container(
                    height: 100,
                    width: 100,
                    color: Colors.pink,
                    child: Image.file(
                      File(image!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
            ElevatedButton(
              onPressed: () {
                pickImage();
              },
              child: const Text(
                'Pick Image',
                style: TextStyle(fontSize: 21),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                uploadImage();
              },
              child: const Text(
                'Send Image',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                sendFile();
              },
              child: const Text(
                'Send String',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                final storageRef = storage.ref();
                final mountainsRef = storageRef.child('images/one.png');
                String data = await mountainsRef.getDownloadURL();
                debugPrint('Link---------------------->$data');
              },
              child: const Text(
                'get image',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  sendFile() async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final mountainsRef = storageRef.child("mountains.jpg");
      // final mountainImagesRef = storageRef.child("images/mountains.jpg");
      await mountainsRef.putFile(File(image!.path));
    } catch (e) {
      debugPrint("Error ------------>>> $e ");
    }
  }

uploadImage() async {
  try {
    File file = File(image!.path);
    storage.ref().child('images/one.png').putFile(file);
  } catch (e) {
    debugPrint(e.toString());
  }
}


uploadString() async {
  String dataUrl = 'data:text/plain;base64,SGVsbG8sIFdvcmxkIQ==';

  try {
    storage.ref().child('dataUrl').putString(dataUrl, format: PutStringFormat.dataUrl);
  } on FirebaseException catch (e) {
    debugPrint(e.toString());
  }
}
}
