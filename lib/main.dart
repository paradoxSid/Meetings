import 'dart:async';

import 'package:flutter/material.dart';
import 'package:debug_mode/debug_mode.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:meetings/bloc/login_bloc.dart';
import 'package:meetings/bloc/meeting_bloc.dart';
import 'package:meetings/screens/home_screen.dart';
import 'package:meetings/theme/theme_builder.dart';
import 'package:provider/provider.dart';

Future<Null> main() async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (DebugMode.isInDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone to report to Sentry
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  runZoned<Future<Null>>(() async {
    final meetingsApp = Phoenix(child: Meetings());

    runApp(meetingsApp);
  }, onError: (error, stackTrace) async {
    print(error);
  });
}

class Meetings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => LoginBloc()),
        Provider(create: (_) => MeetingsBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Meetings',
        theme: ThemeBuilder.buildLightTheme(),
        home: HomeScreen(),
      ),
    );
  }
}
