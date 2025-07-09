
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WriteMeetupScreen extends StatefulWidget {
  @override
  _WriteMeetupScreenState createState() => _WriteMeetupScreenState();
}

class _WriteMeetupScreenState extends State<WriteMeetupScreen> {
  final TextEditingController gameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController peopleCountController = TextEditingController();
  String _statusMessage = '';

  Future<void> _saveMeetup() async {
    final game = gameController.text;
    final location = locationController.text;
    final peopleCount = int.tryParse(peopleCountController.text) ?? 0;
    if (game.isNotEmpty && location.isNotEmpty && peopleCount > 0) {
      final newMeetup = {
        'game': game,
        'location': location,
        'peopleCount': peopleCount,
        'timestamp': DateTime.now().toIso8601String(),
      };
      await FirebaseFirestore.instance.collection('meetups').add(newMeetup);
      Navigator.pop(context, true);
    } else {
      setState(() {
        _statusMessage = '모든 필드를 올바르게 입력해주세요.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('새 모임 작성'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: gameController,
              decoration: InputDecoration(
                hintText: '경기',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                hintText: '장소',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: peopleCountController,
              decoration: InputDecoration(
                hintText: '인원수',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveMeetup,
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