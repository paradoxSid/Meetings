import 'package:flutter/material.dart';
import 'package:meetings/data/strings.dart';
import 'package:meetings/models/models.dart';
import 'package:meetings/screens/meeting_details.dart';
import 'package:meetings/utils/string_helper.dart';

class MeetingCard extends StatelessWidget {
  final Meeting meeting;

  MeetingCard({this.meeting});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: new Key(meeting.id.toString()),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            maintainState: true,
            builder: (context) => MeetingDetails(
                meeting: meeting, dateTime: meeting.startDatetime),
          ),
        );
      },
      child: _buildCard(context: context),
    );
  }

  Widget _buildCard({BuildContext context}) {
    return ListTile(
      leading: Container(
        width: 30,
        child: Center(
          child: CircleAvatar(
            radius: 15,
            backgroundColor: Theme.of(context).accentColor.withAlpha(200),
            foregroundColor: Colors.white,
            child: Icon(
              meeting.endDatetime.isBefore((DateTime.now()))
                  ? Icons.done
                  : Icons.brightness_1,
              size: 20,
            ),
          ),
        ),
      ),
      title: Text(
        meeting.title,
        style: TextStyle(
          color: Theme.of(context).primaryColorLight,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        '${StringHelper.formatTime(meeting.startDatetime, context)}-${StringHelper.formatTime(meeting.endDatetime, context)}',
        style: TextStyle(color: Colors.black38),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor.withAlpha(200),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Text(
          meeting.endDatetime.isBefore((DateTime.now()))
              ? Strings.done
              : meeting.startDatetime.isAfter(DateTime.now())
                  ? Strings.notStart
                  : Strings.inProgress,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
