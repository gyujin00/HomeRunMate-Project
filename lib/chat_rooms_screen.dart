
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'chat_screen.dart';

class ChatRoomsScreen extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  void _createChatRoom(BuildContext context) {
    final TextEditingController _roomNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create Chat Room'),
        content: TextField(
          controller: _roomNameController,
          decoration: InputDecoration(hintText: 'Enter room name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_roomNameController.text.trim().isNotEmpty) {
                FirebaseFirestore.instance.collection('chatrooms').add({
                  'name': _roomNameController.text.trim(),
                  'timestamp': Timestamp.now(),
                });
                Navigator.of(context).pop();
              }
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Rooms'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DbHelper.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No posts available.'));
          }
          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (ctx, index) {
              return ListTile(
                title: Text(posts[index]['title']),
                onTap: () async {
                  List<Map<String, dynamic>> chatRooms = await DbHelper.getChatRoomsByPostId(posts[index]['id']);
                  if (chatRooms.isNotEmpty) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(chatRoomId: chatRooms.first['id']),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createChatRoom(context),
        child: Icon(Icons.add),
      ),
    );
  }
}