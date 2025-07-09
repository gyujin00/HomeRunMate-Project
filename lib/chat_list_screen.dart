import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('내 채팅 목록'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .collection('chatrooms')
            .where('visitCount', isGreaterThan: 0)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No chat rooms available.'));
          }
          final chatRoomDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chatRoomDocs.length,
            itemBuilder: (ctx, index) {
              final chatRoom = chatRoomDocs[index];
              final chatRoomId = chatRoom.id;
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('chatrooms').doc(chatRoomId).get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ListTile(title: Text('Loading...'));
                  }
                  final chatRoomData = snapshot.data?.data() as Map<String, dynamic>?;
                  if (chatRoomData == null) {
                    return ListTile(title: Text('No data available.'));
                  }
                  return ListTile(
                    title: Text(chatRoomData['name'] ?? 'No Name'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(chatRoomId: chatRoomId),
                        ),
                      );
                    },
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
