import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';
import 'sign_in_page.dart';
import 'write_post_screen.dart';
import 'post_detail_screen.dart';

class FreeBoardScreen extends StatefulWidget {
  @override
  _FreeBoardScreenState createState() => _FreeBoardScreenState();
}

class _FreeBoardScreenState extends State<FreeBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('자유게시판'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WritePostScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await AuthService().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
            },
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
              final post = posts[index];
              final postData = post.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(postData['title']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(postData['nickname'] ?? 'Anonymous'),
                    Text(postData['content']),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.thumb_up),
                      onPressed: () async {
                        final currentUser = AuthService().currentUser;
                        final postRef = post.reference;
                        final likes = postData['likes'] ?? 0;

                        // Check if user has already liked the post
                        final userLikedRef = postRef.collection('likes').doc(currentUser?.uid);
                        final userLikedDoc = await userLikedRef.get();

                        if (!userLikedDoc.exists) {
                          // Increment likes count
                          await postRef.update({'likes': likes + 1});
                          // Add user to likes subcollection
                          await userLikedRef.set({'likedAt': Timestamp.now()});
                        }
                      },
                    ),
                    Text('${postData['likes'] ?? 0}'),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PostDetailScreen(postId: post.id),
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
