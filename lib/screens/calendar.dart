import 'package:flutter/material.dart';
import 'package:meetings/bloc/meeting_bloc.dart';
import 'package:meetings/models/models.dart';
import 'package:meetings/screens/meeting_details.dart';
import 'package:meetings/screens/profile.dart';
import 'package:meetings/screens/search_screen.dart';
import 'package:meetings/widget/api_not_available.dart';
import 'package:meetings/widget/meetings/meetings_list.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart' show DateFormat;

class Calendar extends StatefulWidget {
  Calendar({Key key, this.online, this.title}) : super(key: key);

  final String title;
  final online;

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with TickerProviderStateMixin {
  CalendarController _calendarController;
  DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();

    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, MeetingsBloc meetingsBloc) {
    setState(() {
      _selectedDay = day;
      meetingsBloc.fetchMeetingsIn.add(day);
    });
  }

  @override
  Widget build(BuildContext context) {
    MeetingsBloc meetingsBloc = Provider.of<MeetingsBloc>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      floatingActionButton: _buildAddButton(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 60,
            margin: const EdgeInsets.only(top: 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  shape: CircleBorder(),
                  color: Colors.white10,
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child: Icon(Icons.search),
                  onPressed: () => widget.online
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchScreen(),
                          ),
                        )
                      : print('Not online, searching is unavailable'),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (build) => Profile())),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(40)),
                      color: Colors.white10,
                    ),
                    padding: const EdgeInsets.fromLTRB(3, 3, 25, 3),
                    child: Material(
                      shape: CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset('assets/images/avatar.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildTableCalendar(meetingsBloc),
          Expanded(child: _buildEventList(meetingsBloc)),
        ],
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar(MeetingsBloc meetingsBloc) {
    return TableCalendar(
      calendarController: _calendarController,
      startingDayOfWeek: StartingDayOfWeek.monday,
      initialCalendarFormat: CalendarFormat.week,
      availableCalendarFormats: {
        CalendarFormat.month: 'Months',
        CalendarFormat.week: 'Week',
      },
      calendarStyle: CalendarStyle(
        selectedColor: Colors.transparent.withAlpha(75),
        todayColor: Colors.transparent,
        markersColor: Theme.of(context).accentColor,
        outsideDaysVisible: true,
        weekdayStyle: TextStyle(color: Colors.white),
        weekendStyle: TextStyle(color: Colors.white),
        outsideWeekendStyle: CalendarStyle().outsideStyle,
        markersMaxAmount: 1,
      ),
      headerStyle: HeaderStyle(
        headerPadding: const EdgeInsets.only(left: 25, bottom: 15),
        leftChevronMargin: const EdgeInsets.all(0),
        rightChevronMargin: const EdgeInsets.all(0),
        leftChevronPadding: const EdgeInsets.all(0),
        rightChevronPadding: const EdgeInsets.all(0),
        leftChevronIcon: Icon(Icons.chevron_left, size: 0),
        rightChevronIcon: Icon(Icons.chevron_right, size: 0),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        formatButtonVisible: false,
      ),
      onHeaderTapped: (_) => _calendarController.setSelectedDay(
        DateTime.now(),
        isProgrammatic: true,
        runCallback: true,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        dowTextBuilder: (date, locale) => DateFormat.E(locale).format(date)[0],
        weekdayStyle: TextStyle(color: Colors.white),
        weekendStyle: TextStyle(color: Colors.white),
      ),
      onDaySelected: (_, __) => _onDaySelected(_, __, meetingsBloc),
      initialSelectedDay: _selectedDay,
    );
  }

  // Add new meeting button
  Widget _buildAddButton() {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Icon(
        Icons.add,
        size: 32.0,
      ),
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (build) => MeetingDetails(dateTime: _selectedDay))),
    );
  }

  // List seleted days meetings
  Widget _buildEventList(MeetingsBloc meetingsBloc) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: StreamBuilder<List<Meeting>>(
        stream: meetingsBloc.meetingsOut,
        builder: (BuildContext context,
                AsyncSnapshot<List<Meeting>> snapshot) =>
            snapshot.hasError
                ? const ApiNotAvailable()
                : snapshot.hasData
                    ? MeetingList(
                        meetings: snapshot.data, dateTime: _selectedDay)
                    : Center(
                        child: Container(
                        height: 20.0,
                        width: 20.0,
                        margin: const EdgeInsets.all(8),
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )),
      ),
    );
  }
}
