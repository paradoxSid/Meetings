import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:meetings/models/models.dart';

abstract class IAuthenticationService {
  /// Login User With Api
  Future<User> loginUser(http.Client client, String otp, String phone);

  /// Register User With Api
  Future<User> registerUser(http.Client client, var user);

  /// Send OTP to phone number With Api
  Future<bool> sendOTP(http.Client client, String phone);

  /// Updates profile of user
  Future<User> updateProfile(http.Client client, var user);
}
