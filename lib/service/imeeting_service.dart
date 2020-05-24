import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:meetings/models/models.dart';

abstract class IMeetingService {
  /// Fetch list of meetings from api
  Future<List<Meeting>> fetchMeetings(http.Client client, String token);

  /// Creates a new meeting with api
  Future<Meeting> createMeeting(
      http.Client client, Meeting meeting, String token);

  /// Fetch one meeting by a given id from api
  Future<Meeting> fetchMeetingById(http.Client client, String id, String token);

  /// Edits one meeting by a given id from api
  Future<Meeting> editMeeting(http.Client client, String token, Meeting edited);

  /// Deletes one meeting by a given id from api
  Future<bool> deleteMeeting(http.Client client, String id, String token);
}
