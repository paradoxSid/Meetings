import 'package:flutter/material.dart';
import 'package:meetings/data/strings.dart';
import 'package:meetings/models/models.dart';
import 'package:meetings/utils/string_helper.dart';
import 'package:meetings/widget/meetings/meeting_card.dart';

// Widget to list all the meeting in a listview
class MeetingList extends StatefulWidget {
  final List<Meeting> meetings;
  final DateTime dateTime;

  MeetingList({this.meetings, this.dateTime});

  @override
  _MeetingListState createState() => _MeetingListState();
}

class _MeetingListState extends State<MeetingList>
    with AutomaticKeepAliveClientMixin<MeetingList> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.meetings.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
            itemCount: widget.meetings.length,
            itemBuilder: (BuildContext context, int index) => Wrap(
              children: <Widget>[
                (index == 0 ||
                        !StringHelper.isSameDate(
                          widget.meetings[index - 1].startDatetime,
                          widget.meetings[index].startDatetime,
                        ))
                    ? Text(
                        StringHelper.formatDate(
                            widget.meetings[index].startDatetime, context),
                        style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).primaryColorLight,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Container(),
                MeetingCard(meeting: widget.meetings[index]),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                widget.dateTime != null
                    ? Text(
                        StringHelper.formatDate(widget.dateTime, context),
                        style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).primaryColorLight,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Container(),
                Expanded(child: Center(child: Text(Strings.emptyLibrary))),
              ],
            ),
          );
  }
}
