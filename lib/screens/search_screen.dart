import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meetings/bloc/meeting_bloc.dart';
import 'package:meetings/data/strings.dart';
import 'package:meetings/models/models.dart';
import 'package:meetings/widget/meetings/meetings_list.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchQueryController = new TextEditingController();
  Timer _debounce;

  @override
  void initState() {
    super.initState();
    _searchQueryController.addListener(_textInputListener);
  }

  @override
  void dispose() {
    _searchQueryController.removeListener(_textInputListener);
    _searchQueryController.dispose();
    _debounce.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MeetingsBloc _meetingsBloc = Provider.of<MeetingsBloc>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _buildSearchInput(),
      ),
      body: StreamBuilder<bool>(
        stream: _meetingsBloc.loadingOut,
        builder: (context, snapshot) {
          bool loading = snapshot?.data ?? false;
          return loading
              ? Center(child: CircularProgressIndicator())
              : StreamBuilder<List<Meeting>>(
                  stream: _meetingsBloc.searchResultsOut,
                  initialData: [],
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Meeting>> snapshot) {
                    return snapshot.hasError
                        ? Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.error),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3.0)),
                                Text(Strings.serverUnavailable),
                              ],
                            ),
                          )
                        : snapshot.hasData
                            ? snapshot.data.isEmpty
                                ? _searchQueryController.text.isEmpty
                                    ? Center(
                                        child: Text(Strings.searchForAMeeting))
                                    : Center(
                                        child: Text(Strings.noSearchResults))
                                : MeetingList(meetings: snapshot.data)
                            : Center(child: CircularProgressIndicator());
                  },
                );
        },
      ),
    );
  }

  Widget _buildSearchInput() {
    return Padding(
      padding: EdgeInsets.only(top: 3.0),
      child: TextField(
        autofocus: true,
        controller: _searchQueryController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Title, notes...',
          hintStyle: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  void _textInputListener() {
    if (_debounce?.isActive ?? false) {
      _debounce.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      Provider.of<MeetingsBloc>(context, listen: false)
          .searchTextIn
          .add(_searchQueryController.text);
    });
  }
}
