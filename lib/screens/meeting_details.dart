import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:meetings/bloc/login_bloc.dart';
import 'package:meetings/bloc/meeting_bloc.dart';
import 'package:meetings/data/strings.dart';
import 'package:meetings/models/models.dart';
import 'package:meetings/utils/message_helper.dart';

import 'package:meetings/utils/string_helper.dart';
import 'package:provider/provider.dart';

class MeetingDetails extends StatefulWidget {
  final Meeting meeting;
  final DateTime dateTime;

  const MeetingDetails({Key key, this.meeting, @required this.dateTime})
      : super(key: key);

  @override
  _MeetingDetailsState createState() => _MeetingDetailsState();
}

class _MeetingDetailsState extends State<MeetingDetails>
    with TickerProviderStateMixin {
  // Fields Controllers
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _noteController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();

  // Selected Date and time
  DateTime _selectedDate;
  DateTime _selectedFromTime;
  DateTime _selectedToTime;

  var fromStorage = true;
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (widget.meeting != null && fromStorage) {
      _titleController.text = widget.meeting.title;
      _noteController.text = widget.meeting.notes;

      _selectedDate = widget.meeting.startDatetime;
      _selectedFromTime = widget.meeting.startDatetime;
      _selectedToTime = widget.meeting.endDatetime;

      _dateController.text = StringHelper.formatDateTime(
        _selectedDate,
        _selectedFromTime,
        _selectedToTime,
        context,
      );
      setState(() => fromStorage = false);
    }

    MeetingsBloc meetingsBloc = Provider.of<MeetingsBloc>(context);
    LoginBloc loginBloc = Provider.of<LoginBloc>(context);

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorLight,
        floatingActionButton: Builder(
            builder: (context) =>
                _buildSaveButton(loginBloc, meetingsBloc, context)),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(40)),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, bottom: 15, top: 5),
                    child: Text(
                      widget.meeting == null
                          ? Strings.addMeeting
                          : Strings.editMeeting,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Builder(builder: (context) {
                    return widget.meeting != null
                        ? Padding(
                            padding: const EdgeInsets.only(right: 25),
                            child: IconButton(
                              color: Colors.white,
                              icon: isLoading
                                  ? Container(
                                      height: 20.0,
                                      width: 20.0,
                                      margin: const EdgeInsets.all(8),
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  : Icon(Icons.delete_outline),
                              onPressed: () {
                                if (isLoading) return;
                                setState(() => isLoading = true);
                                meetingsBloc
                                    .deleteMeeting(
                                        widget.meeting.id,
                                        widget.dateTime,
                                        loginBloc.isLoggedUser.authToken)
                                    .then((onValue) {
                                  setState(() => isLoading = false);
                                  Navigator.pop(context);
                                }).catchError((err) {
                                  setState(() => isLoading = false);
                                  MessageHelper.showErrorSnackbar(
                                      context, err.message);
                                });
                              },
                            ),
                          )
                        : Container();
                  })
                ],
              ),
              Expanded(child: _buildMettingInput()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(
      LoginBloc loginBloc, MeetingsBloc meetingsBloc, context) {
    return FloatingActionButton.extended(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      label: isLoading
          ? Container(
              height: 20.0,
              width: 20.0,
              margin: const EdgeInsets.all(8),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(Strings.save),
      icon: isLoading
          ? null
          : Icon(
              Icons.save,
              size: 32.0,
            ),
      onPressed: () {
        if (isLoading) return;
        if (!validTitle()) {
          MessageHelper.showErrorSnackbar(context, 'Title cannot be empty');
          return;
        }
        if (!validDates()) {
          MessageHelper.showErrorSnackbar(context, 'Dates cannot be empty');
          return;
        }
        setState(() => isLoading = true);
        Meeting newMeeting = Meeting(
          startDatetime: _selectedFromTime,
          endDatetime: _selectedToTime,
          title: _titleController.text,
          notes: _noteController.text,
        );
        if (widget.meeting == null)
          meetingsBloc
              .createNewMeeting(
                  newMeeting, widget.dateTime, loginBloc.isLoggedUser.authToken)
              .then((onValue) {
            setState(() => isLoading = false);
            MessageHelper.showSuccessSnackbar(context, 'Saved!');
          }).catchError((err) {
            setState(() => isLoading = false);
            MessageHelper.showErrorSnackbar(context, err.message);
          });
        else {
          newMeeting.id = widget.meeting.id;
          meetingsBloc
              .editMeeting(
                  newMeeting, widget.dateTime, loginBloc.isLoggedUser.authToken)
              .then((onValue) {
            setState(() => isLoading = false);
            MessageHelper.showSuccessSnackbar(context, 'Saved!');
          }).catchError((err) {
            setState(() => isLoading = false);
            MessageHelper.showErrorSnackbar(context, err.message);
          });
        }
      },
    );
  }

  Widget _buildMettingInput() {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
        children: <Widget>[
          Text(
            Strings.title,
            style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).primaryColorLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFEDEBED),
            ),
            child: TextField(
              controller: _titleController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                hintText: 'Write the title',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          Text(
            Strings.dateAndTime,
            style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).primaryColorLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFEDEBED),
            ),
            child: TextField(
              controller: _dateController,
              enableInteractiveSelection: false,
              readOnly: true,
              onTap: () {
                DatePicker.showDatePicker(
                  context,
                  theme: DatePickerTheme(containerHeight: 210.0),
                  showTitleActions: true,
                  minTime: DateTime(2000, 1, 1),
                  maxTime: DateTime(2022, 12, 31),
                  onConfirm: (date) => setState(() => _selectedDate = date),
                  currentTime: widget.dateTime,
                  locale: LocaleType.en,
                ).then((dateSelected) {
                  if (dateSelected != null)
                    DatePicker.showTimePicker(
                      context,
                      theme: DatePickerTheme(containerHeight: 210.0),
                      showTitleActions: true,
                      onConfirm: (time) => setState(
                        () => _selectedFromTime = DateTime.utc(
                          _selectedDate.year,
                          _selectedDate.month,
                          _selectedDate.day,
                          time.hour,
                          time.minute,
                        ),
                      ),
                      currentTime: dateSelected,
                      locale: LocaleType.en,
                    ).then((fromTime) {
                      if (fromTime != null)
                        DatePicker.showTimePicker(
                          context,
                          theme: DatePickerTheme(containerHeight: 210.0),
                          showTitleActions: true,
                          onConfirm: (time) => setState(() {
                            _selectedToTime = DateTime.utc(
                              _selectedDate.year,
                              _selectedDate.month,
                              _selectedDate.day,
                              time.hour,
                              time.minute,
                            );
                            _dateController.text = StringHelper.formatDateTime(
                              _selectedDate,
                              _selectedFromTime,
                              _selectedToTime,
                              context,
                            );
                          }),
                          currentTime: fromTime,
                          locale: LocaleType.en,
                        );
                    });
                });
              },
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.date_range,
                  color: Theme.of(context).primaryColorLight,
                ),
                contentPadding: const EdgeInsets.all(20),
                hintText: 'Select date here',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          Text(
            Strings.notes,
            style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).primaryColorLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFEDEBED),
            ),
            child: TextField(
              controller: _noteController,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              minLines: 5,
              maxLines: null,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                hintText: 'Write your important note here',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Validator for title
  bool validTitle() {
    _titleController.text = _titleController.text.trim();
    return _titleController.text.length > 0;
  }

  /// Validator for Phone number
  bool validDates() => !(_selectedFromTime == null || _selectedToTime == null);
}
