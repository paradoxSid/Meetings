import 'package:flutter/material.dart';
import 'package:meetings/bloc/login_bloc.dart';
import 'package:meetings/bloc/meeting_bloc.dart';
import 'package:meetings/data/strings.dart';
import 'package:provider/provider.dart';

class ApiNotAvailable extends StatelessWidget {
  const ApiNotAvailable({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MeetingsBloc meetingsBloc = Provider.of<MeetingsBloc>(context);
    final LoginBloc loginBloc = Provider.of<LoginBloc>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              Strings.oops,
              style: Theme.of(context).textTheme.title.copyWith(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                iconSize: 20.0,
                padding: EdgeInsets.all(1.0),
                icon: Icon(Icons.help),
                onPressed: () => _showHelpDialog(context),
              ),
              Text(Strings.serverUnavailable),
            ],
          ),
          FlatButton(
            color: Theme.of(context).accentColor,
            onPressed: () {
              Scaffold.of(context).showSnackBar(
                new SnackBar(
                  content: new Text(
                    Strings.retry,
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Theme.of(context).primaryColorLight,
                ),
              );
              meetingsBloc.resetMeetingsBlocIn
                  .add(loginBloc.isLoggedUser.authToken);
            },
            child: Text(
              Strings.retryButton,
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColorLight,
            title: Text(Strings.serverName),
            content: Text(
                'The Calendlio server is offline, there is nothing we can do at the moment'),
          );
        });
  }
}
