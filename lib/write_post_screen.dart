import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

class WritePostScreen extends StatefulWidget {
  @override
  _WritePostScreenState createState() => _WritePostScreenState();
}

class _WritePostScreenState extends State<WritePostScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  String _statusMessage = '';

  Future<void> _savePost() async {
    final title = titleController.text;
    final content = contentController.text;
    if (title.isNotEmpty && content.isNotEmpty) {
      final user = AuthService().currentUser;
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
      final userData = userDoc.data() as Map<String, dynamic>;
      final nickname = userData['nickname'] ?? 'Anonymous';

      final newPost = {
        'title': title,
        'content': content,
        'nickname': nickname,
        'timestamp': DateTime.now().toIso8601String(),
        'views': 0,
        'comments': 0,
        'likes': 0,
      };
      await FirebaseFirestore.instance.collection('posts').add(newPost);
      Navigator.pop(context, true);
    } else {
      setState(() {
        _statusMessage = '제목과 내용을 입력해주세요.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('새 글 작성'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: '제목',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                hintText: '내용',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _savePost,
              child: Text('저장'),
            ),
            SizedBox(height: 20),
            Text(_statusMessage),
          ],
        ),
      ),
    );
  }
}
