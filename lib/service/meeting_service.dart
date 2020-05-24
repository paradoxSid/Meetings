import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:meetings/models/models.dart';
import 'package:meetings/service/authentication_service.dart';
import 'package:meetings/service/imeeting_service.dart';

class MeetingService implements IMeetingService {
  final String apiUrl = 'https://calendlio.sarayulabs.com/api/';

  // Fetch all the meetings, the order of the api is kept
  @override
  Future<List<Meeting>> fetchMeetings(http.Client client, String token) async {
    String fetchUrl = apiUrl + 'bookings';

    // print('fetched link: ' + fetchUrl);
    final response = await client
        .get(fetchUrl, headers: {'Authorization': 'Token ' + token});

    if (response.statusCode == 200) {
      // Use the compute function to run parsePhotos in a separate isolate
      return compute(parseMeetings, response.body);
    } else {
      throw Exception('Failed to load Meetings: Check if the api' +
          fetchUrl +
          ' is still online. If not the case check if the mapping is still correct. Response code: ${response.statusCode}.');
    }
  }

  @override
  Future<Meeting> fetchMeetingById(
      http.Client client, String id, String token) async {
    String fetchUrl = apiUrl + 'bookings/$id';

    // print('fetched link: ' + fetchUrl);
    final response = await client
        .get(fetchUrl, headers: {'Authorization': 'Token ' + token});

    if (response.statusCode == 200) {
      // Use the compute function to run parsePhotos in a separate isolate
      return compute(parseMeeting, response.body);
    } else {
      throw Exception('Failed to load Meeting: Check if the api' +
          fetchUrl +
          ' is still online. If not the case check if the mapping is still correct. Response code: ${response.statusCode}.');
    }
  }

  @override
  Future<Meeting> createMeeting(
      http.Client client, Meeting meeting, String token) async {
    String fetchUrl = apiUrl + 'bookings';
    var description = {
      'title': meeting.title,
      'notes': meeting.notes,
    };
    // print('fetched link: ' + fetchUrl);
    final response = await client.post(
      fetchUrl,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Token ' + token,
      },
      body: {
        'description': jsonEncode(description),
        'start_datetime': meeting.startDatetime.toIso8601String(),
        'end_datetime': meeting.endDatetime.toIso8601String(),
      },
    );

    if (response.statusCode == 201) {
      // Use the compute function to run parsePhotos in a separate isolate
      return compute(parseMeeting, response.body);
    } else {
      throw Exception(parseErrors(response.body));
    }
  }

  @override
  Future<bool> deleteMeeting(
      http.Client client, String id, String token) async {
    String url = apiUrl + 'bookings' + '/$id';

    // print('fetched link: ' + url);
    final response = await client.delete(
      url,
      headers: {'Authorization': 'Token ' + token},
    );

    if (response.statusCode == 204) {
      // Use the compute function to run parsePhotos in a separate isolate
      return true;
    } else {
      throw Exception(parseErrors(response.body));
    }
  }

  @override
  Future<Meeting> editMeeting(
      http.Client client, String token, Meeting edited) async {
    String url = apiUrl + 'bookings' + '/${edited.id}';

    var description = {
      'title': edited.title,
      'notes': edited.notes,
    };

    // print('fetched link: ' + url);
    final response = await client.patch(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Token ' + token,
      },
      body: {
        'description': jsonEncode(description),
        'start_datetime': edited.startDatetime.toIso8601String(),
        'end_datetime': edited.endDatetime.toIso8601String(),
      },
    );

    if (response.statusCode == 200) {
      // Use the compute function to run parsePhotos in a separate isolate
      return compute(parseMeeting, response.body);
    } else {
      throw Exception(parseErrors(response.body));
    }
  }
}

// THIS SHOULD BE A TOP LEVEL FUNCTION OTHEREWISE COMPUTE WILL GIVE ERRORS
/// Convert the list of meetings from API to list of meetings
List<Meeting> parseMeetings(String responseBody) {
  // cut the useless data from the response body
  final checkIfMeetings = json.decode(responseBody)['count'];
  var rightJson;
  if (checkIfMeetings != 0) {
    rightJson = json.decode(responseBody)['results'];
  } else {
    rightJson = null;
  }
  if (rightJson != null) {
    final parsed = rightJson.cast<Map<String, dynamic>>();

    return parsed.map<Meeting>((json) => new Meeting.fromJson(json)).toList();
  } else {
    return List();
  }
}

/// Convert meeting from API to meeting
Meeting parseMeeting(String responseBody) {
  // cut the useless data from the response body
  var rightJson = json.decode(responseBody);

  if (rightJson != null) {
    Meeting meeting = Meeting.fromJson(rightJson);
    return meeting;
  } else {
    return null;
  }
}
