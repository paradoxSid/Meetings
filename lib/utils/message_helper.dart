import 'package:flutter/material.dart';

/// Manages a way to show user a message
class MessageHelper {

  /// Error snackbar with color [primaryColorLight]
  static void showErrorSnackbar(context, String err) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        content: Text(err.trim()),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Success snackbar with color [green]
  static void showSuccessSnackbar(context, String msg) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(msg.trim()),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
