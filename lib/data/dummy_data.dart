import 'package:meetings/models/models.dart';

/// Local dummy data to test the app
class DummyData {
  static List<Meeting> meetings = [
    Meeting(
      title: 'Event A0',
      startDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 30)).year,
          DateTime.now().subtract(Duration(days: 30)).month,
          DateTime.now().subtract(Duration(days: 30)).day),
      endDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 30)).year,
          DateTime.now().subtract(Duration(days: 30)).month,
          DateTime.now().subtract(Duration(days: 30)).day,
          23,
          59,
          59),
    ),
    Meeting(
      title: 'Event B0',
      startDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 30)).year,
          DateTime.now().subtract(Duration(days: 30)).month,
          DateTime.now().subtract(Duration(days: 30)).day),
      endDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 30)).year,
          DateTime.now().subtract(Duration(days: 30)).month,
          DateTime.now().subtract(Duration(days: 30)).day,
          23,
          59,
          59),
    ),
    Meeting(
      title: 'Event C0',
      startDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 30)).year,
          DateTime.now().subtract(Duration(days: 30)).month,
          DateTime.now().subtract(Duration(days: 30)).day),
      endDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 30)).year,
          DateTime.now().subtract(Duration(days: 30)).month,
          DateTime.now().subtract(Duration(days: 30)).day,
          23,
          59,
          59),
    ),
    Meeting(
      title: 'Event A1',
      startDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 27)).year,
          DateTime.now().subtract(Duration(days: 27)).month,
          DateTime.now().subtract(Duration(days: 27)).day),
      endDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 27)).year,
          DateTime.now().subtract(Duration(days: 27)).month,
          DateTime.now().subtract(Duration(days: 27)).day,
          23,
          59,
          59),
    ),
    Meeting(
      title: 'Event A2',
      startDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 20)).year,
          DateTime.now().subtract(Duration(days: 20)).month,
          DateTime.now().subtract(Duration(days: 20)).day),
      endDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 20)).year,
          DateTime.now().subtract(Duration(days: 20)).month,
          DateTime.now().subtract(Duration(days: 20)).day,
          23,
          59,
          59),
    ),
    Meeting(
      title: 'Event B2',
      startDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 20)).year,
          DateTime.now().subtract(Duration(days: 20)).month,
          DateTime.now().subtract(Duration(days: 20)).day),
      endDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 20)).year,
          DateTime.now().subtract(Duration(days: 20)).month,
          DateTime.now().subtract(Duration(days: 20)).day,
          23,
          59,
          59),
    ),
    Meeting(
      title: 'Event C2',
      startDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 20)).year,
          DateTime.now().subtract(Duration(days: 20)).month,
          DateTime.now().subtract(Duration(days: 20)).day),
      endDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 20)).year,
          DateTime.now().subtract(Duration(days: 20)).month,
          DateTime.now().subtract(Duration(days: 20)).day,
          23,
          59,
          59),
    ),
    Meeting(
      title: 'Event D2',
      startDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 20)).year,
          DateTime.now().subtract(Duration(days: 20)).month,
          DateTime.now().subtract(Duration(days: 20)).day),
      endDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 20)).year,
          DateTime.now().subtract(Duration(days: 20)).month,
          DateTime.now().subtract(Duration(days: 20)).day,
          23,
          59,
          59),
    ),
    Meeting(
      title: 'Event A3',
      startDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 16)).year,
          DateTime.now().subtract(Duration(days: 16)).month,
          DateTime.now().subtract(Duration(days: 16)).day),
      endDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 16)).year,
          DateTime.now().subtract(Duration(days: 16)).month,
          DateTime.now().subtract(Duration(days: 16)).day,
          23,
          59,
          59),
    ),
    Meeting(
      title: 'Event B3',
      startDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 16)).year,
          DateTime.now().subtract(Duration(days: 16)).month,
          DateTime.now().subtract(Duration(days: 16)).day),
      endDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 16)).year,
          DateTime.now().subtract(Duration(days: 16)).month,
          DateTime.now().subtract(Duration(days: 16)).day,
          23,
          59,
          59),
    ),
    Meeting(
      title: 'Event A4',
      startDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 10)).year,
          DateTime.now().subtract(Duration(days: 10)).month,
          DateTime.now().subtract(Duration(days: 10)).day),
      endDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 10)).year,
          DateTime.now().subtract(Duration(days: 10)).month,
          DateTime.now().subtract(Duration(days: 10)).day,
          23,
          59,
          59),
    ),
    Meeting(
      title: 'Event B4',
      startDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 10)).year,
          DateTime.now().subtract(Duration(days: 10)).month,
          DateTime.now().subtract(Duration(days: 10)).day),
      endDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 10)).year,
          DateTime.now().subtract(Duration(days: 10)).month,
          DateTime.now().subtract(Duration(days: 10)).day,
          23,
          59,
          59),
    ),
    Meeting(
      title: 'Event C4',
      startDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 10)).year,
          DateTime.now().subtract(Duration(days: 10)).month,
          DateTime.now().subtract(Duration(days: 10)).day),
      endDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 10)).year,
          DateTime.now().subtract(Duration(days: 10)).month,
          DateTime.now().subtract(Duration(days: 10)).day,
          23,
          59,
          59),
    ),
    Meeting(
      title: 'Event A5',
      startDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 4)).year,
          DateTime.now().subtract(Duration(days: 4)).month,
          DateTime.now().subtract(Duration(days: 4)).day),
      endDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 4)).year,
          DateTime.now().subtract(Duration(days: 4)).month,
          DateTime.now().subtract(Duration(days: 4)).day,
          23,
          59,
          59),
    ),
    Meeting(
      title: 'Event B5',
      startDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 4)).year,
          DateTime.now().subtract(Duration(days: 4)).month,
          DateTime.now().subtract(Duration(days: 4)).day),
      endDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 4)).year,
          DateTime.now().subtract(Duration(days: 4)).month,
          DateTime.now().subtract(Duration(days: 4)).day,
          23,
          59,
          59),
    ),
    Meeting(
      title: 'Event C5',
      startDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 4)).year,
          DateTime.now().subtract(Duration(days: 4)).month,
          DateTime.now().subtract(Duration(days: 4)).day),
      endDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 4)).year,
          DateTime.now().subtract(Duration(days: 4)).month,
          DateTime.now().subtract(Duration(days: 4)).day,
          23,
          59,
          59),
    ),
    Meeting(
      title: 'Event A0',
      startDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 4)).year,
          DateTime.now().subtract(Duration(days: 4)).month,
          DateTime.now().subtract(Duration(days: 4)).day),
      endDatetime: DateTime.utc(
          DateTime.now().subtract(Duration(days: 4)).year,
          DateTime.now().subtract(Duration(days: 4)).month,
          DateTime.now().subtract(Duration(days: 4)).day,
          23,
          59,
          59),
    ),
    Meeting(
      title: 'Event A7',
      startDatetime: DateTime.utc(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      endDatetime: DateTime.utc(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 1),
    ),
    Meeting(
      title: 'Event B7',
      startDatetime: DateTime.utc(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      endDatetime: DateTime.utc(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 23, 59, 59),
    ),
    Meeting(
      title: 'Event C7',
      startDatetime: DateTime.utc(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      endDatetime: DateTime.utc(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 23, 59, 59),
    ),
    Meeting(
      title: 'Event A6',
      startDatetime: DateTime.utc(
          DateTime.now().add(Duration(days: 4)).year,
          DateTime.now().add(Duration(days: 4)).month,
          DateTime.now().add(Duration(days: 4)).day),
      endDatetime: DateTime.utc(
          DateTime.now().add(Duration(days: 4)).year,
          DateTime.now().add(Duration(days: 4)).month,
          DateTime.now().add(Duration(days: 4)).day,
          23,
          59,
          59),
    ),
    Meeting(
      title: 'Event B6',
      startDatetime: DateTime.utc(
          DateTime.now().add(Duration(days: 4)).year,
          DateTime.now().add(Duration(days: 4)).month,
          DateTime.now().add(Duration(days: 4)).day),
      endDatetime: DateTime.utc(
          DateTime.now().add(Duration(days: 4)).year,
          DateTime.now().add(Duration(days: 4)).month,
          DateTime.now().add(Duration(days: 4)).day,
          23,
          59,
          59),
    ),
    Meeting(
      title: 'Event C6',
      startDatetime: DateTime.utc(
          DateTime.now().add(Duration(days: 4)).year,
          DateTime.now().add(Duration(days: 4)).month,
          DateTime.now().add(Duration(days: 4)).day),
      endDatetime: DateTime.utc(
          DateTime.now().add(Duration(days: 4)).year,
          DateTime.now().add(Duration(days: 4)).month,
          DateTime.now().add(Duration(days: 4)).day,
          23,
          59,
          59),
    ),
    Meeting(
      title: 'Event A0',
      startDatetime: DateTime.utc(
          DateTime.now().add(Duration(days: 4)).year,
          DateTime.now().add(Duration(days: 4)).month,
          DateTime.now().add(Duration(days: 4)).day),
      endDatetime: DateTime.utc(
          DateTime.now().add(Duration(days: 4)).year,
          DateTime.now().add(Duration(days: 4)).month,
          DateTime.now().add(Duration(days: 4)).day,
          23,
          59,
          59),
    ),
  ];
}
