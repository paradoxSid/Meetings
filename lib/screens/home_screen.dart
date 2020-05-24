import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meetings/bloc/login_bloc.dart';
import 'package:meetings/bloc/meeting_bloc.dart';
import 'package:meetings/data/strings.dart';
import 'package:meetings/models/models.dart';
import 'package:meetings/screens/calendar.dart';
import 'package:meetings/service/connectivity_service.dart';
import 'package:meetings/utils/message_helper.dart';
import 'package:meetings/utils/string_helper.dart';
import 'package:meetings/widget/no_internet_connection.dart';
import 'package:meetings/widget/text_field.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _connectivityService = ConnectivityService();
  // String result of the connection, gets updated by the subscription
  String _connectionStatus = 'Unknown';

  bool get online =>
      _connectionStatus == 'ConnectivityResult.none' ? false : true;

  bool gridEnabled = true;

  var isExpanded = false;
  var isLoading = false;
  var newUser = false;

  // Login Fields Controllers
  TextEditingController _loginPhoneController = new TextEditingController();
  TextEditingController _otpController = new TextEditingController();

  // Register Fields Controllers
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _phoneNumberController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    _initConnectivity();
    _connectivityService.connectivityStream.listen((ConnectivityResult result) {
      setState(() => _connectionStatus = result.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final LoginBloc loginBloc = Provider.of<LoginBloc>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Theme.of(context).primaryColorLight,
        body: online ? _buildBody(loginBloc) : NoInternetConnection(),
      ),
    );
  }

  Widget _buildBody(LoginBloc loginBloc) {
    return Column(
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
                child: Icon(Icons.home),
                onPressed: () {},
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(40)),
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
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 5, bottom: 15),
              child: Text(
                newUser ? Strings.register : Strings.login,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              textColor: Theme.of(context).accentColor,
              onPressed: () => setState(() => newUser = !newUser),
              child: Text(newUser ? Strings.oldUser : Strings.newUser),
            ),
          ],
        ),
        Expanded(
          child: StreamBuilder(
            stream: loginBloc.latestUserOut,
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if (snapshot.hasData &&
                  snapshot.data.authToken != null &&
                  snapshot.data.authToken != '') {
                final MeetingsBloc meetingsBloc =
                    Provider.of<MeetingsBloc>(context);
                meetingsBloc.resetMeetingsBlocIn.add(snapshot.data.authToken);

                initializeDateFormatting('en', null).then(
                  (_) => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          Calendar(online: online),
                    ),
                    ModalRoute.withName(''),
                  ),
                );
                return Center(child: CircularProgressIndicator());
              } else
                return snapshot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        child: newUser
                            ? _buildRegisterInputs(loginBloc, context)
                            : _buildLoginInputs(loginBloc, context),
                      );
            },
          ),
        ),
      ],
    );
  }

  // Checks of connection
  Future<Null> _initConnectivity() async {
    String connectionStatus;
    try {
      connectionStatus =
          (await _connectivityService.checkConnectivity()).toString();
    } on PlatformException catch (e) {
      print('There occured an error: ' + e.toString());
      connectionStatus = 'Failed to get connectivity';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      _connectionStatus = connectionStatus;
    });
  }

  // Input fields required for login
  Widget _buildLoginInputs(LoginBloc loginBloc, context) {
    void sendOtp() {
      setState(() => isLoading = true);

      loginBloc.handleSendOTP(_loginPhoneController.text).then((res) {
        if (res)
          setState(() {
            isLoading = false;
            isExpanded = true;
          });
        else {
          setState(() => isLoading = false);
          MessageHelper.showErrorSnackbar(context, 'Something wrong happened');
        }
      });
    }

    void handleLoginButton() {
      if (isLoading) return;
      if (!StringHelper.validPhoneNumber(_loginPhoneController)) {
        MessageHelper.showErrorSnackbar(context, 'Invalid Phone');
        return;
      }

      setState(() => isLoading = true);

      if (isExpanded) {
        loginBloc
            .handleLoginUser(_otpController.text, _loginPhoneController.text)
            .catchError((e) {
          setState(() => isLoading = false);
          MessageHelper.showErrorSnackbar(context, e.message.trim());
        });
      } else
        sendOtp();
    }

    return Material(
      elevation: 2,
      borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
        child: Wrap(
          children: <Widget>[
            MyTextField(
              title: 'Phone Number',
              child: TextField(
                controller: _loginPhoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(20),
                  hintText: 'Phone Number',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
            AnimatedSize(
              duration: Duration(milliseconds: 500),
              vsync: this,
              child: ConstrainedBox(
                constraints: isExpanded
                    ? BoxConstraints()
                    : BoxConstraints(maxHeight: 0.0),
                child: Wrap(
                  children: <Widget>[
                    MyTextField(
                      title: 'OTP',
                      child: TextField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          hintText: 'OTP',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: FlatButton(
                        onPressed: sendOtp,
                        textColor: Theme.of(context).primaryColorLight,
                        child: isLoading
                            ? Container(
                                height: 20.0,
                                width: 20.0,
                                margin: const EdgeInsets.all(8),
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColorLight)),
                              )
                            : Text(Strings.resendOtp),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                onPressed: handleLoginButton,
                child: isLoading
                    ? Container(
                        height: 20.0,
                        width: 20.0,
                        margin: const EdgeInsets.all(8),
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white)),
                      )
                    : Text(isExpanded ? Strings.login : Strings.sendOtp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Input fields required for registration
  Widget _buildRegisterInputs(LoginBloc loginBloc, context) {
    void handleRegisterButton() {
      if (isLoading) return;

      if (!StringHelper.validEmail(_emailController)) {
        MessageHelper.showErrorSnackbar(context, 'Invalid Email');
        return;
      }
      if (!StringHelper.validName(_firstNameController)) {
        MessageHelper.showErrorSnackbar(context, 'Invalid First Name');
        return;
      }
      if (!StringHelper.validName(_lastNameController)) {
        MessageHelper.showErrorSnackbar(context, 'Invalid Last Name');
        return;
      }
      if (!StringHelper.validAddress(_addressController)) {
        MessageHelper.showErrorSnackbar(context, 'Invalid Address');
        return;
      }
      if (!StringHelper.validPhoneNumber(_phoneNumberController)) {
        MessageHelper.showErrorSnackbar(context, 'Invalid Phone Number');
        return;
      }

      setState(() => isLoading = true);

      var newUser = {
        'email': _emailController.text.trim(),
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'address': _addressController.text.trim(),
        'phone_number': _phoneNumberController.text.trim(),
      };
      loginBloc.handleRegisterUser(newUser).catchError((e) {
        setState(() => isLoading = false);
        MessageHelper.showErrorSnackbar(context, e.message.trim());
      });
    }

    return Material(
      elevation: 2,
      borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
        children: <Widget>[
          MyTextField(
            title: 'Email',
            child: TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          MyTextField(
            title: 'First Name',
            child: TextField(
              controller: _firstNameController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                hintText: 'First Name',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          MyTextField(
            title: 'Last Name',
            child: TextField(
              controller: _lastNameController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                hintText: 'Last Name',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          MyTextField(
            title: 'Address',
            child: TextField(
              controller: _addressController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                hintText: 'Address',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          MyTextField(
            title: 'Phone Number',
            child: TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                hintText: 'Phone Number',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              onPressed: handleRegisterButton,
              child: isLoading
                  ? Container(
                      height: 20.0,
                      width: 20.0,
                      margin: const EdgeInsets.all(8),
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white)),
                    )
                  : Text(Strings.register),
            ),
          ),
        ],
      ),
    );
  }
}
