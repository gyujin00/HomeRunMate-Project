// game_calender_screen.dart
import 'package:flutter/material.dart';

class Game {
  final String team1;
  final String team2;
  final String time;
  final String where;

  Game(this.team1, this.team2, this.time, this.where);
}

DateTime _truncateDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

final Map<DateTime, List<Game>> _events = {
  _truncateDate(DateTime(2024, 6, 1)): [
    Game('LG', '두산', '17:00 PM', '잠실'),
    Game('NC', '롯데', '17:00 PM', '사직'),
    Game('한화', '삼성', '17:00 PM', '대구'),
    Game('KT', 'KIA', '17:00 PM', '광주'),
    Game('SSG', '키움', '17:00 PM', '고척'),
  ],
  _truncateDate(DateTime(2024, 6, 2)): [
    Game('LG', '두산', '17:00 PM', '잠실'),
    Game('SSG', '키움', '17:00 PM', '고척'),
    Game('NC', '롯데', '17:00 PM', '사직'),
    Game('한화', '삼성', '17:00 PM', '대구'),
    Game('KT', 'KIA', '17:00 PM', '광주'),
  ],
  _truncateDate(DateTime(2024, 6, 4)): [
    Game('키움', 'LG', '18:30 PM', '잠실'),
    Game('삼성', 'SSG', '18:30 PM', '문학'),
    Game('두산', 'NC', '18:30 PM', '창원'),
    Game('한화', 'KT', '18:30 PM', '수원'),
    Game('롯데', 'KIA', '18:30 PM', '광주'),
  ],
  _truncateDate(DateTime(2024, 6, 5)): [
    Game('키움', 'LG', '18:30 PM', '잠실'),
    Game('삼성', 'SSG', '18:30 PM', '문학'),
    Game('두산', 'NC', '18:30 PM', '창원'),
    Game('한화', 'KT', '18:30 PM', '수원'),
    Game('롯데', 'KIA', '18:30 PM', '광주'),
  ],
  _truncateDate(DateTime(2024, 6, 6)): [
    Game('삼성', 'SSG', '14:00 PM', '문학'),
    Game('롯데', 'KIA', '14:00 PM', '광주'),
    Game('키움', 'LG', '17:00 PM', '잠실'),
    Game('두산', 'NC', '17:00 PM', '창원'),
    Game('한화', 'KT', '17:00 PM', '수원'),
  ],
  _truncateDate(DateTime(2024, 6, 7)): [
    Game('KIA', '두산', '18:30 PM', '잠실'),
    Game('SSG', '롯데', '18:30 PM', '사직'),
    Game('LG', 'KT', '18:30 PM', '수원'),
    Game('삼성', '키움', '18:30 PM', '고척'),
    Game('NC', '한화', '18:30 PM', '대전'),
  ],
  _truncateDate(DateTime(2024, 6, 8)): [
    Game('KIA', '두산', '17:00 PM', '잠실'),
    Game('SSG', '롯데', '17:00 PM', '사직'),
    Game('LG', 'KT', '17:00 PM', '수원'),
    Game('삼성', '키움', '17:00 PM', '고척'),
    Game('NC', '한화', '17:00 PM', '대전'),
  ],
  _truncateDate(DateTime(2024, 6, 9)): [
    Game('삼성', '키움', '14:00 PM', '고척'),
    Game('KIA', '두산', '17:00 PM', '잠실'),
    Game('SSG', '롯데', '17:00 PM', '사직'),
    Game('LG', 'KT', '17:00 PM', '수원'),
    Game('NC', '한화', '17:00 PM', '대전'),
  ],
  _truncateDate(DateTime(2024, 6, 11)): [
    Game('한화', '두산', '18:30 PM', '잠실'),
    Game('KIA', 'SSG', '18:30 PM', '문학'),
    Game('키움', '롯데', '18:30 PM', '사직'),
    Game('LG', '삼성', '18:30 PM', '대구'),
    Game('KT', 'NC', '18:30 PM', '창원'),
  ],
  _truncateDate(DateTime(2024, 6, 12)): [
    Game('한화', '두산', '18:30 PM', '잠실'),
    Game('KIA', 'SSG', '18:30 PM', '문학'),
    Game('키움', '롯데', '18:30 PM', '사직'),
    Game('LG', '삼성', '18:30 PM', '대구'),
    Game('KT', 'NC', '18:30 PM', '창원'),
  ],
  _truncateDate(DateTime(2024, 6, 13)): [
    Game('한화', '두산', '18:30 PM', '잠실'),
    Game('KIA', 'SSG', '18:30 PM', '문학'),
    Game('키움', '롯데', '18:30 PM', '사직'),
    Game('LG', '삼성', '18:30 PM', '대구'),
    Game('KT', 'NC', '18:30 PM', '창원'),
  ],
  _truncateDate(DateTime(2024, 6, 14)): [
    Game('롯데', 'LG', '18:30 PM', '잠실'),
    Game('삼성', 'NC', '18:30 PM', '창원'),
    Game('KIA', 'KT', '18:30 PM', '수원'),
    Game('두산', '키움', '18:30 PM', '고척'),
    Game('SSG', '한화', '18:30 PM', '대전'),
  ],
  _truncateDate(DateTime(2024, 6, 15)): [
    Game('롯데', 'LG', '17:00 PM', '잠실'),
    Game('삼성', 'NC', '17:00 PM', '창원'),
    Game('KIA', 'KT', '17:00 PM', '수원'),
    Game('두산', '키움', '17:00 PM', '고척'),
    Game('SSG', '한화', '17:00 PM', '대구'),
  ],
  _truncateDate(DateTime(2024, 6, 16)): [
    Game('두산', '키움', '12:00 PM', '고척'),
    Game('롯데', 'LG', '17:00 PM', '잠실'),
    Game('삼성', 'NC', '17:00 PM', '창원'),
    Game('KIA', 'KT', '17:00 PM', '수원'),
    Game('SSG', '한화', '17:00 PM', '대전'),
  ],
  _truncateDate(DateTime(2024, 6, 18)): [
    Game('NC', '두산', '18:30 PM', ''),
    Game('SSG', '삼성', '18:30 PM', ''),
    Game('롯데', 'KT', '18:30 PM', ''),
    Game('LG', 'KIA', '18:30 PM', ''),
    Game('키움', '한화', '18:30 PM', ''),
  ],
  _truncateDate(DateTime(2024, 6, 19)): [
    Game('NC', '두산', '18:30 PM', '잠실'),
    Game('SSG', '삼성', '18:30 PM', '대구'),
    Game('롯데', 'KT', '18:30 PM', '수원'),
    Game('LG', 'KIA', '18:30 PM', '광주'),
    Game('키움', '한화', '18:30 PM', '청주'),
  ],
  _truncateDate(DateTime(2024, 6, 20)): [
    Game('NC', '두산', '18:30 PM', '잠실'),
    Game('SSG', '삼성', '18:30 PM', '대구'),
    Game('롯데', 'KT', '18:30 PM', '수원'),
    Game('LG', 'KIA', '18:30 PM', '광주'),
    Game('키움', '한화', '18:30 PM', '청주'),
  ],
  _truncateDate(DateTime(2024, 6, 21)): [
    Game('KT', 'LG', '18:30 PM', '잠실'),
    Game('NC', 'SSG', '18:30 PM', '문학'),
    Game('두산', '삼성', '18:30 PM', '대구'),
    Game('한화', 'KIA', '18:30 PM', '광주'),
    Game('롯데', '키움', '18:30 PM', '고척'),
  ],
  _truncateDate(DateTime(2024, 6, 22)): [
    Game('KT', 'LG', '17:00 PM', '잠실'),
    Game('NC', 'SSG', '17:00 PM', '문학'),
    Game('두산', '삼성', '17:00 PM', '대구'),
    Game('한화', 'KIA', '17:00 PM', '광주'),
    Game('롯데', '키움', '17:00 PM', '고척'),
  ],
  _truncateDate(DateTime(2024, 6, 23)): [
    Game('롯데', '키움', '12:00 PM', '고척'),
    Game('KT', 'LG', '17:00 PM', '잠실'),
    Game('NC', 'SSG', '17:00 PM', '문학'),
    Game('두산', '삼성', '17:00 PM', '대구'),
    Game('한화', 'KIA', '17:00 PM', '광주'),
  ],
  _truncateDate(DateTime(2024, 6, 25)): [
    Game('삼성', 'LG', '18:30', '잠실'),
    Game('KT', 'SSG', '18:30', '문학'),
    Game('KIA', '롯데', '18:30', '사직'),
    Game('NC', '키움', '18:30', '고척'),
    Game('두산', '한화', '18:30', '대전'),
  ],
  _truncateDate(DateTime(2024, 6, 26)): [
    Game('삼성', 'LG', '18:30', '잠실'),
    Game('KT', 'SSG', '18:30', '문학'),
    Game('KIA', '롯데', '18:30', '사직'),
    Game('NC', '키움', '18:30', '고척'),
    Game('두산', '한화', '18:30', '대전'),
  ],
  _truncateDate(DateTime(2024, 6, 27)): [
    Game('삼성', 'LG', '18:30', '잠실'),
    Game('KT', 'SSG', '18:30', '문학'),
    Game('KIA', '롯데', '18:30', '사직'),
    Game('NC', '키움', '18:30', '고척'),
    Game('두산', '한화', '18:30', '대전'),
  ],
  _truncateDate(DateTime(2024, 6, 28)): [
    Game('SSG', '두산', '18:30', '잠실'),
    Game('한화', '롯데', '18:30', '사직'),
    Game('LG', 'NC', '18:30', '창원'),
    Game('삼성', 'KT', '18:30', '수원'),
    Game('키움', 'KIA', '18:30', '광주'),
  ],
  _truncateDate(DateTime(2024, 6, 29)): [
    Game('SSG', '두산', '17:00 PM', '잠실'),
    Game('한화', '롯데', '17:00 PM', '사직'),
    Game('LG', 'NC', '17:00 PM', '창원'),
    Game('삼성', 'KT', '17:00 PM', '수원'),
    Game('키움', 'KIA', '17:00 PM', '광주'),
  ],
  _truncateDate(DateTime(2024, 6, 30)): [
    Game('SSG', '두산', '17:00 PM', '잠실'),
    Game('한화', '롯데', '17:00 PM', '사직'),
    Game('LG', 'NC', '17:00 PM', '창원'),
    Game('삼성', 'KT', '17:00 PM', '수원'),
    Game('키움', 'KIA', '17:00 PM', '광주'),
  ],
};

class GameCalendarScreen extends StatefulWidget {
  @override
  _GameCalendarScreenState createState() => _GameCalendarScreenState();
}

class _GameCalendarScreenState extends State<GameCalendarScreen> {
  DateTime _selectedDay = DateTime.now();

  List<Game> _getEventsForDay(DateTime day) {
    return _events[_truncateDate(day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('야구 경기 달력'),
      ),
      body: Column(
        children: [
          CalendarDatePicker(
            initialDate: _selectedDay,
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
            onDateChanged: (selectedDate) {
              setState(() {
                _selectedDay = selectedDate;
              });
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: _buildEventList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    final List<Game> selectedEvents = _getEventsForDay(_selectedDay);

    return ListView.builder(
      itemCount: selectedEvents.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${selectedEvents[index].team1} vs ${selectedEvents[index].team2}'),
          subtitle: Text('${selectedEvents[index].time} / ${selectedEvents[index].where}'),
        );
      },
    );
  }
}
