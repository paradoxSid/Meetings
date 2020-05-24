import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:meetings/bloc/login_bloc.dart';
import 'package:meetings/data/strings.dart';
import 'package:meetings/utils/message_helper.dart';
import 'package:meetings/utils/string_helper.dart';
import 'package:meetings/widget/text_field.dart';
import 'package:provider/provider.dart';

// Profile Edit screen
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var fromStorage = true;
  var isLoading = false;
  // Fields Controllers
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _phoneNumberController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final LoginBloc loginBloc = Provider.of<LoginBloc>(context);
    if (fromStorage) {
      _firstNameController.text = loginBloc.isLoggedUser?.firstName;
      _lastNameController.text = loginBloc.isLoggedUser?.lastName;
      _addressController.text = loginBloc.isLoggedUser?.address;
      _phoneNumberController.text = loginBloc.isLoggedUser?.phoneNumber;
      _emailController.text = loginBloc.isLoggedUser?.email;
      setState(() => fromStorage = false);
    }

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorLight,
        floatingActionButton:
            Builder(builder: (context) => _buildSaveButton(loginBloc, context)),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Column(
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
                      child: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(40)),
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
              Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 5, bottom: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${loginBloc.isLoggedUser.firstName} ${loginBloc.isLoggedUser.lastName}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          loginBloc.isLoggedUser.email,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    fromStorage
                        ? Container(
                            height: 20.0,
                            width: 20.0,
                            margin: const EdgeInsets.all(8),
                            child: CircularProgressIndicator(strokeWidth: 2.0),
                          )
                        : IconButton(
                            color: Colors.white,
                            icon: Icon(Icons.refresh),
                            onPressed: () {
                              setState(() => fromStorage = true);
                            },
                          ),
                    IconButton(
                      color: Theme.of(context).accentColor,
                      icon: Icon(Icons.exit_to_app),
                      onPressed: () => loginBloc.logoutUser().then((res) {
                        if (res) Phoenix.rebirth(context);
                      }),
                    ),
                  ],
                ),
              ),
              Expanded(child: _buildProfileInputs()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(LoginBloc loginBloc, context) {
    return FloatingActionButton.extended(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      label: isLoading
          ? Container(
              height: 20.0,
              width: 20.0,
              margin: const EdgeInsets.all(8),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(Strings.save),
      icon: isLoading ? null : Icon(Icons.save),
      onPressed: () {
        if (isLoading) return;
        if (!StringHelper.validName(_firstNameController)) {
          MessageHelper.showErrorSnackbar(context, Strings.invalidFirstName);
          return;
        }
        if (!StringHelper.validName(_lastNameController)) {
          MessageHelper.showErrorSnackbar(context, Strings.invalidLastName);
          return;
        }
        if (!StringHelper.validAddress(_addressController)) {
          MessageHelper.showErrorSnackbar(context, Strings.invalidAddress);
          return;
        }
        if (!StringHelper.validPhoneNumber(_phoneNumberController)) {
          MessageHelper.showErrorSnackbar(context, Strings.invalidPhoneNum);
          return;
        }
        if (!StringHelper.validEmail(_emailController)) {
          MessageHelper.showErrorSnackbar(context, Strings.invalidEmail);
          return;
        }
        setState(() => isLoading = true);
        var data = {
          'auth_token': loginBloc.isLoggedUser.authToken,
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'address': _addressController.text,
          'phone_number': _phoneNumberController.text,
          'email': _emailController.text,
        };
        loginBloc
            .handleProfileUpdate(data)
            .then((onValue) => setState(() {
                  fromStorage = true;
                  isLoading = false;
                  MessageHelper.showSuccessSnackbar(context, Strings.saved);
                }))
            .catchError((err) => setState(() {
                  isLoading = false;
                  print(err);
                }));
      },
    );
  }

  Widget _buildProfileInputs() {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
        children: <Widget>[
          MyTextField(
            title: Strings.firstName,
            child: TextField(
              controller: _firstNameController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                hintText: Strings.firstName,
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          MyTextField(
            title: Strings.lastName,
            child: TextField(
              controller: _lastNameController,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                hintText: Strings.lastName,
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          MyTextField(
            title: Strings.address,
            child: TextField(
              controller: _addressController,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                hintText: Strings.address,
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          MyTextField(
            title: Strings.phoneNum,
            child: TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                hintText: Strings.phoneNum,
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          MyTextField(
            title: Strings.email,
            child: TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                hintText: Strings.email,
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
