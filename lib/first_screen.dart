import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  void _navigateTo(String page, BuildContext context) {
    // 페이지 이동 로직 구현
    print('Navigating to $page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset('assets/images/홈 화면.png'), // 수정된 부분
          ],
        ),
      ),
      bottomNavigationBar: null, // 네비게이션 바 제거
    );
  }
}
