import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:meetings/models/models.dart';
import 'package:meetings/service/iauthentication_service.dart';

/// Service to maintain authentication with the api
class AuthenticationService implements IAuthenticationService {
  final String apiUrl = 'https://calendlio.sarayulabs.com/api/';

  @override
  Future<User> loginUser(http.Client client, String otp, String phone) async {
    String postUrl = apiUrl + 'auth/login';
    var res = await client.post(
      postUrl,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'phone_number': phone, 'otp': otp},
    );
    if (res.statusCode == 200)
      return compute(parseUser, res.body);
    else
      throw Exception(parseErrors(res.body));
  }

  @override
  Future<User> registerUser(http.Client client, user) async {
    String postUrl = apiUrl + 'auth/register';
    var res = await client.post(
      postUrl,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: user,
    );
    if (res.statusCode == 201)
      return compute(parseUser, res.body);
    else
      throw Exception(parseErrors(res.body));
  }

  @override
  Future<bool> sendOTP(http.Client client, String phone) async {
    String postUrl = apiUrl + 'verification/phone';
    var res = await client.post(
      postUrl,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'phone_number': phone},
    );
    if (res.statusCode == 204) return true;
    return false;
  }

  @override
  Future<User> updateProfile(http.Client client, var usr) async {
    String url = apiUrl + 'me';
    final res = await client.patch(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Token ' + usr['auth_token'],
      },
      body: {
        'first_name': usr['first_name'],
        'last_name': usr['last_name'],
        'email': usr['email'],
        'address': usr['address'],
        'phone_number': usr['phone_number'],
      },
    );

    if (res.statusCode == 200)
      return parseUser(res.body);
    else {
      throw Exception(parseErrors(res.body));
    }
  }
}

User parseUser(String responseBody) {
  // cut the useless data from the response body
  var rightJson = json.decode(responseBody);

  if (rightJson != null) {
    User user = User.fromJson(rightJson);
    return user;
  } else {
    return null;
  }
}

String parseErrors(String e) {
  String errors = '';
  jsonDecode(e)['errors'].forEach((err) => errors += err['message'] + '\n');
  return errors;
}
