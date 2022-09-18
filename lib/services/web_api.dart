import 'dart:convert';
import 'dart:io';

import 'package:connect_plus/emergencyContact.dart';
import 'package:connect_plus/models/activity.dart';
import 'package:connect_plus/models/activityDate.dart';
import 'package:connect_plus/models/category.dart';
import 'package:connect_plus/models/emergencyContact.dart';
import 'package:connect_plus/models/erg.dart';
import 'package:connect_plus/models/event.dart';
import 'package:connect_plus/models/eventHighlight.dart';
import 'package:connect_plus/models/login_request_params.dart';
import 'package:connect_plus/models/offer.dart';
import 'package:connect_plus/models/offerHighlight.dart';
import 'package:connect_plus/models/profile.dart';
import 'package:connect_plus/models/register_request_params.dart';
import 'package:connect_plus/models/user.dart';
import 'package:connect_plus/models/webinar.dart';

import 'package:http/http.dart' as http;
import 'package:rrule/rrule.dart';
import 'package:time_machine/time_machine.dart';
import 'package:connect_plus/models/announcement.dart';

class WebAPI {
  static final String baseURL = "http://18.188.100.150:1337";
  static final String _registerURL = '/auth/local/register';
  static final String _loginURL = '/auth/local';
  static final String _checkUserURL = '/users/me';
  static final String _offersURL = '/offers';
  static final String _eventsURL = '/events';
  static final String _activitiesURL = '/activities';
  static final String _webinarsURL = '/webinars';
  static final String _ergsURL = '/ergs';
  static final String _categoriesURL = '/categories';
  static final String _eventHighlightsURL = "/event-highlights";
  static final String _announcementURL = "/announcements";
  static final String _businessUnitURL = "/business-units";
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
      throw response.statusCode;
    }
    return response.body;
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
      throw response;
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

  static Future<List<ERG>> getERGS() async {
    final response = await get(_ergsURL);

    // TODO: Add this logic to a seperate transformer service
    final List<dynamic> rawERGS = json.decode(response.body);
    final List<ERG> ergs = [];
    for (final ergJson in rawERGS) {
      ergs.add(ERG.fromJson(ergJson));
    }
    return ergs;
  }

  static Future<List<EventHighlight>> getEventHighlights() async {
    final response = await get('/event-highlights');

    final List<dynamic> rawHighlights = json.decode(response.body);
    final List<EventHighlight> highlights = [];
    for (final highlightJson in rawHighlights) {
      highlights.add(EventHighlight.fromJson(highlightJson));
    }
    return highlights;
  }

  static Future<List<OfferHighlight>> getOfferHighlights() async {
    final response = await get('/offer-highlights');

    final List<dynamic> rawHighlights = json.decode(response.body);
    final List<OfferHighlight> highlights = [];
    for (final highlightJson in rawHighlights) {
      highlights.add(OfferHighlight.fromJson(highlightJson));
    }
    return highlights;
  }

  static Future<List<EmergencyContact>> getEmergencyContacts() async {
    final response = await get('/emergency-contacts');

    final List<dynamic> rawContacts = json.decode(response.body);
    final List<EmergencyContact> contacts = [];
    for (final contactJson in rawContacts) {
      contacts.add(EmergencyContact.fromJson(contactJson));
    }
    return contacts;
  }

  static Future<List<Category>> getCategories() async {
    final response = await get(_categoriesURL);

    final List<dynamic> rawCategories = json.decode(response.body);
    final List<Category> categories = [];
    for (final categoryJson in rawCategories) {
      categories.add(Category.fromJson(categoryJson));
    }
    return categories;
  }

  static Future<List<Offer>> getOffers() async {
    final response = await get(_offersURL);

    // TODO: Add this logic to a seperate transformer service
    final List<dynamic> rawOffers = json.decode(response.body);
    final List<Offer> offers = [];
    for (final offerJson in rawOffers) {
      if (Offer.fromJson(offerJson).expiration.isAfter(DateTime.now()))
        offers.add(Offer.fromJson(offerJson));
    }
    offers.sort((b, a) => a.createdAt.compareTo(b.createdAt));

    return offers;
  }

  static Future<List<Offer>> getOffersByCategory(Category category) async {
    final categoryId = category.id;
    final categoryURL = "$_offersURL?category_eq=$categoryId";
    final response = await get(categoryURL);

    // TODO: Add this logic to a seperate transformer service
    final rawOffers = json.decode(response.body);
    final List<Offer> offers = [];
    for (final offerJson in rawOffers) {
      if (Offer.fromJson(offerJson).expiration.isAfter(DateTime.now()))
        offers.add(Offer.fromJson(offerJson));
    }
    offers.sort((b, a) => a.createdAt.compareTo(b.createdAt));

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
    final response = await get(_offersURL);

    // TODO: Add this logic to a seperate transformer service
    final List<dynamic> rawOffers = json.decode(response.body);
    final List<Offer> offers = [];
    for (final offerJson in rawOffers) {
      if (Offer.fromJson(offerJson).expiration.isAfter(DateTime.now()))
        offers.add(Offer.fromJson(offerJson));
    }
    offers.sort((b, a) => a.createdAt.compareTo(b.createdAt));

    offers.sublist(0, 6);
    return offers;
  }

  static List<DateTime> getActivityRecurrence(String frequency,
      DateTime endDate, DateTime startDate, List<ActivityDate> dates) {
    RecurrenceRule rrule;

    Set<ByWeekDayEntry> days = {};
    dates.forEach((element) {
      if (element.day == 'Sunday') {
        days.add(ByWeekDayEntry(DayOfWeek.sunday));
      }
      if (element.day == 'Monday') {
        days.add(ByWeekDayEntry(DayOfWeek.monday));
      }
      if (element.day == 'Tuesday') {
        days.add(ByWeekDayEntry(DayOfWeek.tuesday));
      }
      if (element.day == 'Wednesday') {
        days.add(ByWeekDayEntry(DayOfWeek.wednesday));
      }
      if (element.day == 'Thursday') {
        days.add(ByWeekDayEntry(DayOfWeek.thursday));
      }
      if (element.day == 'Friday') {
        days.add(ByWeekDayEntry(DayOfWeek.friday));
      }
      if (element.day == 'Saturday') {
        days.add(ByWeekDayEntry(DayOfWeek.saturday));
      }
    });
    if (frequency == 'daily') {
      rrule = RecurrenceRule(
        frequency: Frequency.daily,
        until: LocalDateTime.dateTime(endDate),
        byWeekDays: days,
        weekStart: DayOfWeek.sunday,
      );
    } else if (frequency == 'weekly') {
      rrule = RecurrenceRule(
        frequency: Frequency.weekly,
        until: LocalDateTime.dateTime(endDate),
        byWeekDays: days,
        weekStart: DayOfWeek.sunday,
      );
    } else if (frequency == 'biweekly') {
      rrule = RecurrenceRule(
        frequency: Frequency.weekly,
        interval: 2,
        until: LocalDateTime.dateTime(endDate),
        byWeekDays: days,
        weekStart: DayOfWeek.sunday,
      );
    } else if (frequency == 'monthly') {
      rrule = RecurrenceRule(
        frequency: Frequency.monthly,
        until: LocalDateTime.dateTime(endDate),
        byWeekDays: days,
        weekStart: DayOfWeek.sunday,
      );
    }
    // Every two weeks on Tuesday and Thursday, but only in December.

    Iterable<LocalDateTime> instances = rrule.getInstances(
      start: LocalDateTime.dateTime(startDate),
    );
    List<DateTime> dateTimeInstances = [];
    instances.forEach((element) {
      dateTimeInstances.add(element.toDateTimeLocal());
    });
    return dateTimeInstances;
  }

  static Future<List<Activity>> getActivitiesDates() async {
    List<Activity> activities = await getActivities();

    activities.forEach((activity) {
      activity.recurrenceDates = [];
      activity.recurrenceDates.addAll(getActivityRecurrence(activity.recurrence,
          activity.endDate, activity.startDate, activity.activityDates));
    });
    return activities;
  }

  static Future<List<Activity>> getActivities() async {
    final response = await get(_activitiesURL);

    // TODO: Add this logic to a seperate transformer service
    final List<dynamic> rawActivities = json.decode(response.body);
    final List<Activity> activities = [];
    for (final activityJson in rawActivities) {
      if (Activity.fromJson(activityJson).endDate.isAfter(DateTime.now()))
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
      if (Webinar.fromJson(webinarJson).isRecorded == true) {
        webinars.add(Webinar.fromJson(webinarJson));
      }
    }
    webinars.sort((b, a) => a.startDate.compareTo(b.startDate));

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

  static Future<Announcement> getAnnouncementByName(String name) async {
    final announcementURL = "$_announcementURL?name=$name";
    final response = await get(announcementURL);

    // TODO: Add this logic to a seperate transformer service
    final announcementRaw = json.decode(response.body);
    final Announcement announcement = Announcement.fromJson(announcementRaw[0]);

    return announcement;
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
    webinars.sort((b, a) => a.startDate.compareTo(b.startDate));

    return webinars;
  }

  static Future<List<Event>> getEvents() async {
    final response = await get(_eventsURL);

    // TODO: Add this logic to a seperate transformer service
    final List<dynamic> rawEvents = json.decode(response.body);
    final List<Event> events = [];
    for (final eventJson in rawEvents) {
      if (Event.fromJson(eventJson).endDate.isAfter(DateTime.now()))
        events.add(Event.fromJson(eventJson));
    }
    events.sort((b, a) => a.startDate.compareTo(b.startDate));
    return events;
  }

  static Future<List<Event>> getAllEvents() async {
    final response = await get(_eventsURL);
    // TODO: Add this logic to a seperate transformer service
    final List<dynamic> rawEvents = json.decode(response.body);
    final List<Event> events = [];
    for (final eventJson in rawEvents) {
        events.add(Event.fromJson(eventJson));
    }
    events.sort((b, a) => a.startDate.compareTo(b.startDate));
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
      if (Event.fromJson(eventJson).endDate.isAfter(DateTime.now()))
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
      if (Event.fromJson(eventJson).endDate.isAfter(DateTime.now()))
        events.add(Event.fromJson(eventJson));
    }
    events.sort((b, a) => a.startDate.compareTo(b.startDate));

    return events;
  }

  static Future<List<Webinar>> getSliderWebinars() async {
    final webinarsUrl = "$_webinarsURL?slider_eq=true";
    final response = await get(webinarsUrl);

    // TODO: Add this logic to a seperate transformer service
    final rawWebinars = json.decode(response.body);
    final List<Webinar> webinars = [];
    for (final webinarJson in rawWebinars) {
      webinars.add(Webinar.fromJson(webinarJson));
    }
    webinars.sort((b, a) => a.startDate.compareTo(b.startDate));

    return webinars;
  }

  static Future<List<Event>> getSliderEvents() async {
    final eventsURL = "$_eventsURL?slider_eq=true";
    final response = await get(eventsURL);

    // TODO: Add this logic to a seperate transformer service
    final rawEvents = json.decode(response.body);
    final List<Event> events = [];
    for (final eventJson in rawEvents) {
      events.add(Event.fromJson(eventJson));
    }
    events.sort((b, a) => a.startDate.compareTo(b.startDate));

    return events;
  }

  static Future<List<Announcement>> getAnnouncements() async {
    final response = await get(_announcementURL);

    // TODO: Add this logic to a seperate transformer service
    final List<dynamic> rawAnnouncements = json.decode(response.body);
    final List<Announcement> announcements = [];
    for (final announcementJson in rawAnnouncements) {
      //if (announcement.fromJson(announcementJson).endDate.isAfter(DateTime.now()))
      announcements.add(Announcement.fromJson(announcementJson));
    }

    return announcements;
  }

  /// Returns list of all announcements future or null deadlines
  static Future<List<Announcement>> getUnexpiredAnnouncements() async {
    final now = DateTime.now().toIso8601String();
    final response = await get(
      "$_announcementURL?_where[_or][0][deadline_gt]=$now&_where[_or][1][deadline_null]=true",
    );
    // TODO: Add this logic to a seperate transformer service
    final List<dynamic> rawAnnouncements = json.decode(response.body);
    final List<Announcement> announcements = [];
    for (final announcementJson in rawAnnouncements) {
      //if (announcement.fromJson(announcementJson).endDate.isAfter(DateTime.now()))
      announcements.add(Announcement.fromJson(announcementJson));
    }

    return announcements;
  }

  static Future<List<String>> getBusinessUnits() async {
    final response = await get(_businessUnitURL);

    // TODO: Add this logic to a seperate transformer service
    final List<dynamic> rawBU = json.decode(response.body);
    final List<String> BUs = [];
    for (final BU in rawBU) {
      BUs.add(BU["name"]);
    }
    print(BUs);
    return BUs;
  }
}
