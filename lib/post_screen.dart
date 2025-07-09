import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'write_post_screen.dart';
import 'chat_screen.dart';
import 'auth_service.dart';
import 'sign_in_page.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Future<void> _navigateToWritePostScreen() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => WritePostScreen()),
    );
    if (result == true) {
      setState(() {});
    }
  }

  Future<void> _signOut() async {
    await AuthService().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시판'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _navigateToWritePostScreen,
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _signOut,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No posts available.'));
          }
          final posts = snapshot.data!.docs;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (ctx, index) {
              return ListTile(
                title: Text(posts[index]['title']),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(chatRoomId: posts[index].id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
