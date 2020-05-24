import 'dart:convert';

import 'package:flutter/material.dart';

/// Stores information for a meeting
class Meeting {
  String id;
  String title;
  String notes;
  DateTime startDatetime;
  DateTime endDatetime;

  Meeting({
    this.id,
    @required this.startDatetime,
    @required this.endDatetime,
    // All below will be stored in description as an json string
    @required this.title,
    this.notes,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> dis = jsonDecode(json['description']);

    return Meeting(
      id: json['id'] as String,
      startDatetime: DateTime.parse(json['start_datetime']),
      endDatetime: DateTime.parse(json['end_datetime']),
      title: dis['title'],
      notes: dis['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'start_datetime': startDatetime.toIso8601String(),
        'end_datetime': endDatetime.toIso8601String(),
        'description': {
          'title': title,
          'notes': notes,
        }
      };
}
