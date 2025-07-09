import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;

  ChatScreen({required this.chatRoomId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _searchController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  String? loggedInUserNickname;
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(loggedInUser!.uid).get();
        final userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          loggedInUserNickname = userData['nickname'];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _sendMessage() {
    _controller.text = _controller.text.trim();
    if (_controller.text.isNotEmpty && loggedInUserNickname != null) {
      FirebaseFirestore.instance.collection('chatrooms').doc(widget.chatRoomId).collection('messages').add({
        'text': _controller.text,
        'sender': loggedInUserNickname,
        'timestamp': Timestamp.now(),
      });
      _controller.clear();
    }
  }

  void _deleteMessage(String messageId) {
    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(widget.chatRoomId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  void _showDeleteDialog(String messageId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Message'),
        content: Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteMessage(messageId);
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search messages...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chatrooms')
                  .doc(widget.chatRoomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final chatDocs = snapshot.data!.docs;
                final filteredDocs = chatDocs.where((doc) {
                  return doc['text'].toString().toLowerCase().contains(_searchText.toLowerCase());
                }).toList();
                return ListView.builder(
                  reverse: true,
                  itemCount: filteredDocs.length,
                  itemBuilder: (ctx, index) {
                    bool isMe = filteredDocs[index]['sender'] == loggedInUserNickname;
                    return GestureDetector(
                      onTap: () {
                        if (isMe) {
                          _showDeleteDialog(filteredDocs[index].id);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          if (!isMe)
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/images/야구공.png'),
                            ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Text(filteredDocs[index]['sender'], style: TextStyle(fontWeight: FontWeight.bold)),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: isMe ? Colors.yellow[100] : Colors.grey[300],
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    topRight: Radius.circular(14),
                                    bottomLeft: isMe ? Radius.circular(14) : Radius.zero,
                                    bottomRight: isMe ? Radius.zero : Radius.circular(14),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      filteredDocs[index]['text'],
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      (filteredDocs[index]['timestamp'] as Timestamp).toDate().toLocal().toString().substring(11, 16),
                                      style: TextStyle(fontSize: 10, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (isMe)
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/images/야구공.png'),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'Send a message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
