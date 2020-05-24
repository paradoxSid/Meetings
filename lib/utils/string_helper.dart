import 'package:flutter/material.dart';

class StringHelper {
  /// To format time am/pm
  static String formatTime(DateTime dateTime, context) {
    return TimeOfDay(
      hour: dateTime.hour,
      minute: dateTime.minute,
    ).format(context);
  }

  /// To format date 
  static String formatDate(DateTime dateTime, context) {
    var months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    var days = [
      'Monday',
      'Tuesday',
      'Wednusday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    if (dateTime.year == DateTime.now().year &&
        dateTime.month == DateTime.now().month &&
        dateTime.day == DateTime.now().day)
      return 'Today';
    else if (dateTime.year == DateTime.now().year &&
        dateTime.month == DateTime.now().month &&
        dateTime.day - DateTime.now().day == -1)
      return 'Yesterday';
    else if (dateTime.year == DateTime.now().year &&
        dateTime.month == DateTime.now().month &&
        dateTime.day - DateTime.now().day == 1)
      return 'Tomorrow';
    else
      return '${days[dateTime.weekday - 1]}, ${dateTime.day} ${months[dateTime.month - 1].substring(0, 3)}';
  }

  /// Checker of same dates
  static bool isSameDate(DateTime a, DateTime b) =>
      (a.day == b.day && a.month == b.month && a.year == b.year);

  static String formatDateTime(
      DateTime dateTime, DateTime fromTime, DateTime toTime, context) {
    var months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${dateTime.day} ${months[dateTime.month - 1].substring(0, 3)} ' +
        '| ${formatTime(fromTime, context)} - ${formatTime(toTime, context)}';
  }

  /// Validator for email
  static bool validEmail(TextEditingController email) {
    email.text = email.text.trim();
    Pattern pattern =
        r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$';
    RegExp regex = new RegExp(pattern);
    if (regex.hasMatch(email.text)) return true;
    return false;
  }

  /// Validator for first and last name
  static bool validName(TextEditingController name) {
    name.text = name.text.trim();
    Pattern pattern = r'^([A-Z])([a-z]{2,})$';
    RegExp regex = new RegExp(pattern);
    if (regex.hasMatch(name.text)) return true;
    return false;
  }

  /// Validator for address
  static bool validAddress(TextEditingController address) {
    address.text = address.text.trim();
    if (address.text.length > 3) return true;
    return false;
  }

  /// Validator for Phone number
  static bool validPhoneNumber(TextEditingController phone) {
    phone.text = phone.text.trim();
    Pattern pattern = r'^(?:[+]91)?[1-9][0-9]{9}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(phone.text)) return false;

    if (phone.text.length == 10) {
      phone.text = '+91' + phone.text;
      return true;
    }
    if (phone.text.length == 13 && phone.text[0] == '+') return true;

    return false;
  }
}
