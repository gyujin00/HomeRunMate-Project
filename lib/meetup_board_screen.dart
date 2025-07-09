
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_screen.dart';

class MeetupBoardScreen extends StatefulWidget {
  @override
  _MeetupBoardScreenState createState() => _MeetupBoardScreenState();
}

class _MeetupBoardScreenState extends State<MeetupBoardScreen> {
  final TextEditingController gameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController peopleCountController = TextEditingController();
  List<Map<String, dynamic>> meetups = [];
  String _statusMessage = '';

  Future<void> _createMeetup() async {
    final game = gameController.text;
    final location = locationController.text;
    final peopleCount = int.tryParse(peopleCountController.text) ?? 0;

    if (game.isNotEmpty && location.isNotEmpty && peopleCount > 0) {
      await FirebaseFirestore.instance.collection('meetups').add({
        'game': game,
        'location': location,
        'peopleCount': peopleCount,
        'timestamp': DateTime.now().toIso8601String(),
      });
      Navigator.pop(context, true);
      _fetchMeetups();
    } else {
      setState(() {
        _statusMessage = '모든 필드를 올바르게 입력해주세요.';
      });
    }
  }

  Future<void> _fetchMeetups() async {
    List<Map<String, dynamic>> fetchedMeetups = await FirebaseFirestore.instance.collection('meetups').get().then((snapshot) => snapshot.docs.map((doc) => {
      'id': doc.id,
      'game': doc['game'],
      'location': doc['location'],
      'peopleCount': doc['peopleCount'],
      'timestamp': doc['timestamp'],
    }).toList());
    setState(() {
      meetups = fetchedMeetups;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchMeetups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('야구보러 갈 사람?~'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: meetups.length,
              itemBuilder: (context, index) {
                final meetup = meetups[index];
                return ListTile(
                  title: Text(meetup['game']),
                  subtitle: Text('장소: ${meetup['location']}, 인원수: ${meetup['peopleCount']}명'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(chatRoomId: meetup['id']),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('새 모임 작성'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: gameController,
                                decoration: InputDecoration(hintText: '경기'),
                              ),
                              TextField(
                                controller: locationController,
                                decoration: InputDecoration(hintText: '장소'),
                              ),
                              TextField(
                                controller: peopleCountController,
                                decoration: InputDecoration(hintText: '인원수'),
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('취소'),
                            ),
                            TextButton(
                              onPressed: _createMeetup,
                              child: Text('추가'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text('새 모임 작성'),
                  ),
                ),
              ],
            ),
          ),
          Text(_statusMessage, style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}