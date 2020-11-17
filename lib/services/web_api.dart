import 'dart:convert';
import 'dart:io';

import 'package:connect_plus/models/activity.dart';
import 'package:connect_plus/models/erg.dart';
import 'package:connect_plus/models/event.dart';
import 'package:connect_plus/models/login_request_params.dart';
import 'package:connect_plus/models/offer.dart';
import 'package:connect_plus/models/register_request_params.dart';
import 'package:connect_plus/models/user.dart';
import 'package:connect_plus/models/user_profile.dart';
import 'package:connect_plus/models/user_profile_request_params.dart';
import 'package:connect_plus/models/webinar.dart';

import 'package:http/http.dart' as http;

class WebAPI {
  static final String baseURL = "http://18.221.173.220:1337";
  static final String _registerURL = '/auth/local/register';
  static final String _loginURL = '/auth/local';
  static final String _profilesURL = '/profiles';
  static final String _checkUserURL = '/users/me';
  static final String _offersURL = '/offers';
  static final String _eventsURL = '/events';
  static final String _activitiesURL = '/activities';
  static final String _webinarsURL = '/webinars';

  // TODO: remove this to a separate service
  static User currentUser;
  static String currentToken;

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

  static put<T>(String url, String body) async {
    final requestURL = constructURL(url);

    Map<String, String> headers = generateHeaders();

    final response = await http.put(
      requestURL,
      headers: headers,
      body: body,
    );
    // TODO: Implement better error handling approach
    if (response.statusCode != 200) {
      throw response.body;
    }
    return response;
  }

  static get(String url, {String token}) async {
    final requestURL = constructURL(url);

    // create default headers
    Map<String, String> headers = generateHeaders(token);
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
      final token = currentToken;
      headers['Authorization'] = "Bearer $token";
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

    return registeredUser;
  }

  static Future<UserWithToken> login(
    LoginRequestParams params,
  ) async {
    currentToken = null;
    currentUser = null;
    final requestBody = jsonEncode(params);
    try {
      final response = await post(_loginURL, requestBody);
      final responseBody = json.decode(response.body);
      final loggedInUser = UserWithToken.fromJson(responseBody);

      // reset the current user on login
      currentUser = loggedInUser.user;
      currentToken = loggedInUser.jwt;
      return loggedInUser;
    } catch (e) {
      currentUser = null;
      currentToken = null;
      throw e;
    }
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

  static Future<UserProfile> updateProfile(
      UserProfileRequestParams params, String id) async {
    final requestBody = jsonEncode(params);
    final response = await put(_profilesURL + "/$id", requestBody);
    final responseBody = json.decode(response.body);
    final profile = UserProfile.fromJson(responseBody);
    return profile;
  }

  static Future<User> checkToken(String token) async {
    final response = await get(_checkUserURL, token: token);
    final user = User.fromJson(json.decode(response.body));
    if (user != null) {
      currentUser = user;
      currentToken = token;
    } else {
      currentToken = null;
    }
    return user;
  }

  static Future<UserProfile> getProfile(String id) async {
    final response = await get(_profilesURL + "/$id");
    final profile = UserProfile.fromJson(json.decode(response.body));
    return profile;
  }

  static Future<List<Offer>> getOffers() async {
    final response = await get(_offersURL);

    // TODO: Add this logic to a seperate transformer service
    final List<dynamic> rawOffers = json.decode(response.body);
    final List<Offer> offers = [];
    for (final offerJson in rawOffers) {
      offers.add(Offer.fromJson(offerJson));
    }

    return offers;
  }

  static Future<List<Offer>> getOffersByCategory(OfferCategory category) async {
    final categoryName = category.toString();
    final categoryURL = "$_offersURL?category_eq=$categoryName";
    final response = await get(categoryURL);

    // TODO: Add this logic to a seperate transformer service
    final rawOffers = json.decode(response.body);
    final List<Offer> offers = [];
    for (final offerJson in rawOffers) {
      offers.add(Offer.fromJson(offerJson));
    }
    return offers;
  }

  static Future<Offer> getOfferByName(String name) async {
    final offerURL = "$_offersURL?name=$name";
    final response = await get(offerURL);

    // TODO: Add this logic to a seperate transformer service
    final offerRaw = json.decode(response.body);
    final Offer offer = Offer.fromJson(offerRaw[0]);

    return offer;
  }

  static Future<List<Offer>> getRecentOffers() async {
    final recentURL = "$_offersURL?_limit=5";
    final response = await get(recentURL);

    // TODO: Add this logic to a seperate transformer service
    final List<dynamic> rawOffers = json.decode(response.body);
    final List<Offer> offers = [];
    for (final offerJson in rawOffers) {
      offers.add(Offer.fromJson(offerJson));
    }

    return offers;
  }

  static Future<List<Activity>> getActivities() async {
    final response = await get(_activitiesURL);

    // TODO: Add this logic to a seperate transformer service
    final List<dynamic> rawActivities = json.decode(response.body);
    final List<Activity> activities = [];
    for (final activityJson in rawActivities) {
      activities.add(Activity.fromJson(activityJson));
    }

    return activities;
  }

  static Future<Activity> getActivityByName(String name) async {
    final activityURL = "$_activitiesURL?name=$name";
    final response = await get(activityURL);

    // TODO: Add this logic to a seperate transformer service
    final activityRaw = json.decode(response.body);
    final Activity activity = Activity.fromJson(activityRaw[0]);

    return activity;
  }

  static Future<List<Activity>> getActivitiesByERG(ERG erg) async {
    final ergId = erg.id;
    final ergURL = "$_activitiesURL?erg_eq=$ergId";
    final response = await get(ergURL);

    // TODO: Add this logic to a seperate transformer service
    final rawActivities = json.decode(response.body);
    final List<Activity> activities = [];
    for (final activityJson in rawActivities) {
      activities.add(Activity.fromJson(activityJson));
    }
    return activities;
  }

  static Future<List<Webinar>> getWebinars() async {
    final response = await get(_webinarsURL);

    // TODO: Add this logic to a seperate transformer service
    final List<dynamic> rawWebinars = json.decode(response.body);
    final List<Webinar> webinars = [];
    for (final webinarJson in rawWebinars) {
      webinars.add(Webinar.fromJson(webinarJson));
    }

    return webinars;
  }

  static Future<Webinar> getWebinarByName(String name) async {
    final webinarURL = "$_webinarsURL?name=$name";
    final response = await get(webinarURL);

    // TODO: Add this logic to a seperate transformer service
    final webinarRaw = json.decode(response.body);
    final Webinar webinar = Webinar.fromJson(webinarRaw[0]);

    return webinar;
  }

  static Future<List<Webinar>> getWebinarsByERG(ERG erg) async {
    final ergId = erg.id;
    final ergURL = "$_webinarsURL?erg_eq=$ergId";
    final response = await get(ergURL);

    // TODO: Add this logic to a seperate transformer service
    final rawWebinars = json.decode(response.body);
    final List<Webinar> webinars = [];
    for (final webinarJson in rawWebinars) {
      webinars.add(Webinar.fromJson(webinarJson));
    }
    return webinars;
  }

  static Future<List<Event>> getEvents() async {
    final response = await get(_eventsURL);

    // TODO: Add this logic to a seperate transformer service
    final List<dynamic> rawEvents = json.decode(response.body);
    final List<Event> events = [];
    for (final eventJson in rawEvents) {
      events.add(Event.fromJson(eventJson));
    }

    return events;
  }

  static Future<Event> getEventByName(String name) async {
    final eventURL = "$_eventsURL?name=$name";
    final response = await get(eventURL);

    // TODO: Add this logic to a seperate transformer service
    final eventRaw = json.decode(response.body);
    final Event event = Event.fromJson(eventRaw[0]);
    return event;
  }

  static Future<List<Event>> getEventsByERG(ERG erg) async {
    final ergId = erg.id;
    final ergURL = "$_eventsURL?erg_eq=$ergId";
    final response = await get(ergURL);

    // TODO: Add this logic to a seperate transformer service
    final rawEvents = json.decode(response.body);
    final List<Event> events = [];
    for (final eventJson in rawEvents) {
      events.add(Event.fromJson(eventJson));
    }
    return events;
  }

  static Future<List<Event>> getRecentEvents() async {
    final recentURL = "$_eventsURL?_limit=5";
    final response = await get(recentURL);

    // TODO: Add this logic to a seperate transformer service
    final List<dynamic> rawEvents = json.decode(response.body);
    final List<Event> events = [];
    for (final eventJson in rawEvents) {
      events.add(Event.fromJson(eventJson));
    }

    return events;
  }
}
