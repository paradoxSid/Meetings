import 'dart:async';

import 'package:meetings/bloc/bloc_base.dart';
import 'package:meetings/models/models.dart';
import 'package:meetings/service/meeting_service.dart';
import 'package:rxdart/rxdart.dart';

import 'package:http/http.dart' as http;

class MeetingsBloc extends BlocBase {
  // Meetings
  /// The [BehaviorSubject] is a [StreamController]
  /// The controller has all the meetings of a date
  BehaviorSubject<List<Meeting>> _meetingsController = new BehaviorSubject();

  /// The [Sink] is the input for the [_meetingsController]
  Sink<List<Meeting>> get meetingsIn => _meetingsController.sink;

  /// The [Stream] is the output for the [_meetingsController]
  Stream<List<Meeting>> get meetingsOut => _meetingsController.stream;

  /// [PublishSubject] is the same as a [StreamController] but from the rxDart library
  PublishSubject<DateTime> _fetchMeetingsController = new PublishSubject();

  /// The [Sink] is the input to get meetings of a date.
  /// This will result in adding Meeting to [_meetingsController]
  Sink<DateTime> get fetchMeetingsIn => _fetchMeetingsController.sink;

  // Meetings Search
  /// The [BehaviorSubject] is a [StreamController]
  /// The controller has all the meetings matchting a search query
  BehaviorSubject<List<Meeting>> _searchResultController =
      new BehaviorSubject();

  /// The [Sink] is the input for the [_searchResultController]
  Sink<List<Meeting>> get searchResultsIn => _searchResultController.sink;

  /// The [Stream] is the output for the [_searchResultController]
  Stream<List<Meeting>> get searchResultsOut => _searchResultController.stream;

  /// [PublishSubject] is the same as a [StreamController] but from the rxDart library
  PublishSubject<String> _searchTextController = new PublishSubject();

  /// The [Sink] is the input to get meetings matching search query.
  /// This will result in adding Meetings to [_searchResultController]
  Sink<String> get searchTextIn => _searchTextController.sink;

  /// The [BehaviorSubject] is a [StreamController]
  /// The controller has the flag if the search is running
  BehaviorSubject<bool> _loadingController = new BehaviorSubject();

  /// The [Sink] is the output for the [_loadingController]
  Stream<bool> get loadingOut => _loadingController.stream;

  /// The [BehaviorSubject] is a [StreamController]
  /// The controller has the possibility to reset the meetings streams
  BehaviorSubject<String> _resetMeetingsBlocController = new BehaviorSubject();

  /// The [Sink] is the input for the [_resetMeetingsBlocController]
  Sink<String> get resetMeetingsBlocIn => _resetMeetingsBlocController.sink;

  /// Is list of all the meetings from the api
  List<Meeting> _latestMeetings;

  final MeetingService _meetingService = new MeetingService();

  /// Keeps track if there is already a handle request in progress to protect from to many requests
  bool loading = false;

  MeetingsBloc() {
    _fetchMeetingsController.stream.listen(_handleMeetings);
    _resetMeetingsBlocController.stream.listen(_handleResetMeetingsBlocs);

    _searchTextController.stream.listen(_handleSearchQuery);
  }

  void dispose() {
    _meetingsController.close();
    _fetchMeetingsController.close();
    _resetMeetingsBlocController.close();

    _searchTextController.close();
    _searchResultController.close();
    _loadingController.close();
  }

  void _handleMeetings(DateTime dateTime) async {
    if (_latestMeetings == null && !loading) {
      _meetingsController.addError('exception');
      return;
    }
    try {
      var selectedMeetings = _latestMeetings
          .where((meet) => (meet.startDatetime.day == dateTime.day &&
              meet.startDatetime.month == dateTime.month &&
              meet.startDatetime.year == dateTime.year))
          .toList();

      meetingsIn.add(selectedMeetings);
    } catch (exception) {
      print(exception);
      _meetingsController.addError(exception);
    }
  }

  /// Gets all the meetings from api
  Future<void> getMeetings(String token) async {
    List<Meeting> fetchedMeetings;
    loading = true;
    try {
      fetchedMeetings =
          await _meetingService.fetchMeetings(http.Client(), token);

      fetchedMeetings
          .sort((a, b) => a.startDatetime.compareTo(b.startDatetime));

      _latestMeetings = fetchedMeetings;

      fetchMeetingsIn.add(DateTime.now());
      // If page system then addall will be used
      // fetchedMeetings.addAllfetchedMeetings;
    } catch (exception) {
      print(exception);
    }
    loading = false;
  }

  /// Creates new meeting
  Future<void> createNewMeeting(
      Meeting meeting, DateTime dateTime, String token) async {
    loading = true;

    var newMeeting =
        await _meetingService.createMeeting(http.Client(), meeting, token);
    var index = _latestMeetings.indexWhere(
        (meet) => meet.startDatetime.isBefore(newMeeting.startDatetime));
    if (index == -1)
      _latestMeetings.insert(0, newMeeting);
    else
      _latestMeetings.insert(
        _latestMeetings.indexWhere(
            (meet) => meet.startDatetime.isBefore(newMeeting.startDatetime)),
        newMeeting,
      );
    fetchMeetingsIn.add(dateTime);

    loading = false;
  }

  /// Deletes a meeting for a user
  Future<bool> deleteMeeting(String id, DateTime dateTime, String token) async {
    loading = true;

    if (await _meetingService.deleteMeeting(http.Client(), id, token)) {
      _latestMeetings.removeWhere((meet) => meet.id == id);
      fetchMeetingsIn.add(dateTime);
      return true;
    }

    loading = false;

    return false;
  }

  /// Edits a meeting for a user
  Future<void> editMeeting(
      Meeting meeting, DateTime dateTime, String token) async {
    loading = true;

    var newMeeting =
        await _meetingService.editMeeting(http.Client(), token, meeting);

    var index = _latestMeetings.indexWhere((meet) => meet.id == meeting.id);
    _latestMeetings
      ..removeAt(index)
      ..insert(index, newMeeting);

    fetchMeetingsIn.add(dateTime);

    loading = false;
  }

  void _handleSearchQuery(String searchQuery) async {
    searchQuery = searchQuery ?? '';
    searchQuery = searchQuery
      ..trim()
      ..toLowerCase();
    if (searchQuery.isNotEmpty) {
      _loadingController.sink.add(true);
      try {
        List<Meeting> _searchResults = _latestMeetings.where((meet) {
          String title = meet.title?.toLowerCase() ?? '';
          String notes = meet.notes?.toLowerCase() ?? '';

          return (title.contains(searchQuery) || notes.contains(searchQuery));
        }).toList();

        searchResultsIn.add(_searchResults);
      } catch (exception) {
        print(exception);
        _searchResultController.addError(exception);
      }
      _loadingController.sink.add(false);
    } else
      searchResultsIn.add([]);
  }

  void _handleResetMeetingsBlocs(String token) {
    getMeetings(token);
  }
}
