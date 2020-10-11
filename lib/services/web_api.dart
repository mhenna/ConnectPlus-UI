import 'dart:convert';
import 'dart:io';

import 'package:connect_plus/models/login_request_params.dart';
import 'package:connect_plus/models/register_request_params.dart';
import 'package:connect_plus/models/user.dart';
import 'package:connect_plus/models/user_profile.dart';
import 'package:connect_plus/models/user_profile_request_params.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;

class WebAPI {
  static final String baseURL = DotEnv().env["API_BASE_URL"];
  static final String _registerURL = '/auth/local/register';
  static final String _loginURL = '/auth/local';
  static final String _profilesURL = '/profiles';
  static final String _checkUserURL = '/users/me';

  // TODO: remove this to a separate service
  static final localStorage = LocalStorage('Connect+');

  // TODO: remove this to a separate service
  static UserWithToken currentUser;

  static String constructURL(String apiURL) {
    return baseURL + apiURL;
  }

  static post<T>(String url, String body) async {
    final requestURL = constructURL(url);

    Map<String, String> headers = generateHeaders();

    final response = await http.post(
      requestURL,
      headers: headers,
      body: body,
    );
    // TODO: Implement better error handling approach
    if (response.statusCode != 200) {
      throw response;
    }
    return response;
  }

  static get<T>(String url) async {
    final requestURL = constructURL(url);

    // create default headers
    Map<String, String> headers = generateHeaders();
    final response = await http.get(
      requestURL,
      headers: headers,
    );

    // TODO: Implement better error handling approach
    if (response.statusCode != 200) {
      throw response;
    }
    return response;
  }

  static Map<String, String> generateHeaders([String token]) {
    // create default headers
    Map<String, String> headers = {
      'content-type': ContentType.json.toString(),
    };

    // always attach Authorization Header when user is logged in
    if (currentUser != null) {
      final jwt = currentUser.jwt;
      headers['Authorization'] = "Bearer $jwt";
    }
    if (token != null) {
      headers['Authorization'] = "Bearer $token";
    }
    return headers;
  }

  static Future<UserWithToken> register(
    RegisterRequestParameters params,
  ) async {
    final requestBody = jsonEncode(params);
    final response = await post(_registerURL, requestBody);
    final responseBody = json.decode(response.body);
    final registeredUser = UserWithToken.fromJson(responseBody);

    // reset the current user on register
    currentUser = registeredUser;
    return registeredUser;
  }

  static Future<UserWithToken> login(
    LoginRequestParams params,
  ) async {
    final requestBody = jsonEncode(params);
    final response = await post(_loginURL, requestBody);
    final responseBody = json.decode(response.body);
    final loggedInUser = UserWithToken.fromJson(responseBody);

    // reset the current user on login
    currentUser = loggedInUser;
    return loggedInUser;
  }

  static Future<UserProfile> setProfile(
    UserProfileRequestParams params,
  ) async {
    final requestBody = jsonEncode(params);
    final response = await post(_profilesURL, requestBody);
    final responseBody = json.decode(response.body);
    final profile = UserProfile.fromJson(responseBody);
    return profile;
  }

  static Future<UserWithToken> checkToken(String token) async {
    final headers = generateHeaders(token);
    final response = await http.get(_checkUserURL, headers: headers);
    final user = UserWithToken.fromJson(json.decode(response.body));
    currentUser = user;
    return user;
  }

  static Future<UserProfile> getProfile(String id) async {
    final response = await get(_profilesURL + "/$id");
    final profile = UserProfile.fromJson(json.decode(response.body));
    return profile;
  }
}
