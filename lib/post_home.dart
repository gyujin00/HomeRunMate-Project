import 'package:flutter/material.dart';
import 'free_board_screen.dart';
import 'meetup_board_screen.dart';

class PostHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('오늘의 야구소식'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/컴프야2.jpg'), // 두 번째 이미지
            NewsList(),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FreeBoardScreen()),
                      );
                    },
                    child: Text('자유게시판'),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MeetupBoardScreen()),
                      );
                    },
                    child: Text('야구보러 갈 사람?~'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('SSG 최정, 홈런 468호 신기록...이승엽 기록 넘어서다'),
          subtitle: Text('기사 내용'),
        ),
        ListTile(
          title: Text('타이거즈 부동의 4번 타자 선발 제외 왜?...힘들다고...'),
          subtitle: Text('기사 내용'),
        ),
        ListTile(
          title: Text('ABS가 류현진 외면했다, 수비가 류현진 망쳤다...'),
          subtitle: Text('기사 내용'),
        ),
        ListTile(
          title: Text('ML 1671안타+KBO 329안타...SSG 추신수, 고향 부산...'),
          subtitle: Text('기사 내용'),
        ),
      ],
    );
  }
}
