import 'package:meetings/bloc/bloc_base.dart';
import 'package:meetings/models/models.dart';
import 'package:meetings/service/authentication_service.dart';
import 'package:meetings/service/storage/stored_user_service.dart';
import 'package:rxdart/rxdart.dart';

import 'package:http/http.dart' as http;

class LoginBloc extends BlocBase {
  User _loggedUser;

  User get isLoggedUser => _loggedUser;

  // User
  /// The [BehaviorSubject] is a [StreamController]
  /// The controller has the logged in user
  BehaviorSubject<User> _userController = new BehaviorSubject();

  /// The [Sink] is the input for the [_userController]
  Sink<User> get latestUserIn => _userController.sink;

  /// The [Stream] is the output for the [_userController]
  Stream<User> get latestUserOut => _userController.stream;

  // Service to interact authentication with the api
  final AuthenticationService _authenticationService =
      new AuthenticationService();

  // Service to interact authentication with the storage
  final StoredUserService _userService = new StoredUserService();

  LoginBloc() {
    _getLoggedInUser();
  }

  /// Get Logged in user from storage
  Future _getLoggedInUser() async {
    _loggedUser = await _userService.readFile();
    latestUserIn.add(_loggedUser);
  }

  /// Save a user to storage
  Future _saveLoggedInUser(User user) async {
    await _userService.writeToFile(user);
    _getLoggedInUser();
  }

  /// Handle login request to api
  handleLoginUser(String otp, String phone) async {
    User _user =
        await _authenticationService.loginUser(http.Client(), otp, phone);
    return _saveLoggedInUser(_user);
  }

  /// Handle Register user to api
  Future handleRegisterUser(var user) async {
    User _user = await _authenticationService.registerUser(http.Client(), user);
    _saveLoggedInUser(_user);
  }

  /// Handle Sending otp to user
  Future<bool> handleSendOTP(String phone) async {
    try {
      return await _authenticationService.sendOTP(http.Client(), phone);
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// Handle Logging out of a user
  Future<bool> logoutUser() async {
    try {
      await _userService.deleteFile();
      _loggedUser = null;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// Handle changes in user profile
  Future handleProfileUpdate(var user) async {
    User _user =
        await _authenticationService.updateProfile(http.Client(), user);
    _user.authToken = user['auth_token'];
    await _saveLoggedInUser(_user);
  }

  @override
  void dispose() {
    _userController.close();
  }
}
