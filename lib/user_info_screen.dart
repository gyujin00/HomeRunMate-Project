import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'auth_service.dart';
import 'sign_in_page.dart';

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final user = AuthService().currentUser;
  File? _image;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final userData = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
    setState(() {
      _profileImageUrl = userData['profileImageUrl'];
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    final storageRef = FirebaseStorage.instance.ref().child('profile_images').child('${user?.uid}.jpg');
    final uploadTask = storageRef.putFile(_image!);
    final snapshot = await uploadTask.whenComplete(() => {});

    final downloadUrl = await snapshot.ref.getDownloadURL();
    await FirebaseFirestore.instance.collection('users').doc(user?.uid).update({'profileImageUrl': downloadUrl});

    setState(() {
      _profileImageUrl = downloadUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('사용자 정보'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImageUrl != null ? NetworkImage(_profileImageUrl!) : null,
                      child: _profileImageUrl == null ? Icon(Icons.add_a_photo, size: 50) : null,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('이메일: ${user?.email}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('닉네임: ${userData['nickname']}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('생년월일: ${userData['dob']}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await AuthService().signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  },
                  child: Text('로그아웃'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
