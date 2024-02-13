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
import 'package:connect_plus/models/wire_magazine.dart';

import 'package:http/http.dart' as http;
import 'package:rrule/rrule.dart';
import 'package:time_machine/time_machine.dart';
import 'package:connect_plus/models/announcement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_plus/utils/lists.dart';
class WebAPI {
  /*static final String baseURL = "http://18.188.100.150:1337";
  static final String _registerURL = '/auth/local/register';
  static final String _loginURL = '/auth/local';
  static final String _checkUserURL = '/users/me';*/
  static final String _offersCollection = 'offers';
  static final String _eventsCollection = 'events';
  static final String _activitiesCollection = 'activities';
  static final String _webinarsCollection = 'webinars';
  static final String _ergsCollection = 'ergs';
  static final String _categoriesCollection = 'categories';
  static final String _eventHighlightsCollection = "event-highlights";
  static final String _offerHighlightsCollection = "offer-highlights";
  static final String _announcementCollection = "announcements";
  static final String _businessUnitCollection = "business-units";
  static final String _wireMagazineCollection = "wire-magazines";
  static final String _emergencyContactsCollection = "emergency-contacts";

  // TODO: remove this to a separate service
  static User currentUser;
  static String currentToken;


  /*static String constructURL(String apiURL) {
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
  }*/

  static Future<List<ERG>> getERGS() async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(_ergsCollection).get();

    final List<ERG> ergs = [];
    for (final doc in querySnapshot.docs) {
      ergs.add(ERG.fromJson({...doc.data(),'id':doc.id,'_id':doc.id}));
    }
    return ergs;
  }

  static Map<String, dynamic> getERGByID(String ergId) {
    return ergs.firstWhere((erg) => erg['id'] == ergId, orElse: () => {});
  }

  static Map<String, dynamic> getCategoryByID(String categoryId) {
    return categories.firstWhere((category) => category['id'] == categoryId, orElse: () => {});
  }

  static Future<List<EventHighlight>> getEventHighlights() async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(_eventHighlightsCollection).get();

    final List<EventHighlight> highlights = [];
    for (final doc in querySnapshot.docs) {
      highlights.add(EventHighlight.fromJson({...doc.data(),'id':doc.id,'_id':doc.id}));
    }
    return highlights;
  }

  static Future<List<OfferHighlight>> getOfferHighlights() async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(_offerHighlightsCollection).get();

    final List<OfferHighlight> highlights = [];
    for (final doc in querySnapshot.docs) {
      highlights.add(OfferHighlight.fromJson({...doc.data(),'id':doc.id,'_id':doc.id}));
    }
    return highlights;
  }

  static Future<List<EmergencyContact>> getEmergencyContacts() async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(_emergencyContactsCollection).get();

    final List<EmergencyContact> contacts = [];
    for (final doc in querySnapshot.docs) {
      contacts.add(EmergencyContact.fromJson({...doc.data(),'id':doc.id,'_id':doc.id}));
    }
    return contacts;
  }

  static Future<List<Category>> getCategories() async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(_categoriesCollection).get();
    final List<Category> categories = [];
    for (final doc in querySnapshot.docs) {
      categories.add(Category.fromJson({...doc.data(),'id':doc.id,'_id':doc.id}));
    }
    return categories;
  }

  static Future<List<Offer>> getOffers() async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(_offersCollection).get();
    final List<Offer> offers = [];
    for (final doc in querySnapshot.docs) {
      dynamic erg= doc.data()['erg']!=null? getERGByID(doc.data()['erg'].id):null;
      dynamic category= doc.data()['category']!=null? getCategoryByID(doc.data()['category'].id):null;
      Offer offer = Offer.fromJson({...doc.data(),'id':doc.id,'_id':doc.id,'erg':erg,'category':category});
      if (offer.expiration.isAfter(DateTime.now()))
        offers.add(offer);
    }
    offers.sort((b, a) => a.expiration.compareTo(b.expiration));
    return offers;
  }

  static Future<List<Offer>> getOffersByCategory(Category category) async {
    DocumentReference categoryRef = FirebaseFirestore.instance.collection(_categoriesCollection).doc(category.id);
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(_offersCollection)
        .where('category', isEqualTo:categoryRef)
        .get();

    final List<Offer> offers = [];
    for (final doc in querySnapshot.docs) {
      dynamic erg= doc.data()['erg']!=null? getERGByID(doc.data()['erg'].id):null;
      dynamic category= doc.data()['category']!=null? getCategoryByID(doc.data()['category'].id):null;
      Offer offer = Offer.fromJson({...doc.data(),'id':doc.id,'_id':doc.id,'erg':erg,'category':category});
      if (offer.expiration.isAfter(DateTime.now())) {
        offers.add(offer);
      }
    }
    offers.sort((b, a) => a.expiration.compareTo(b.expiration));

    return offers;
  }

  static Future<Offer> getOfferByName(Category category) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(_offersCollection)
        .where('name', isEqualTo: category.name) // Replace 'categoryId' with the actual field name in your offers documents
        .get();

    final List<Offer> offers = [];
    for (final doc in querySnapshot.docs) {
      dynamic erg= doc.data()['erg']!=null? getERGByID(doc.data()['erg'].id):null;
      dynamic category= doc.data()['category']!=null? getCategoryByID(doc.data()['category'].id):null;
      Offer offer = Offer.fromJson({...doc.data(),'id':doc.id,'_id':doc.id,'erg':erg,'category':category});
      if (offer.expiration.isAfter(DateTime.now())) {
        offers.add(offer);
      }
    }
    offers.sort((b, a) => a.expiration.compareTo(b.expiration));

    return offers[0];
  }

  static Future<List<Offer>> getRecentOffers() async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(_offersCollection).get();
    final List<Offer> offers = [];
    for (final doc in querySnapshot.docs) {
      dynamic erg= doc.data()['erg']!=null? getERGByID(doc.data()['erg'].id):null;
      dynamic category= doc.data()['category']!=null? getCategoryByID(doc.data()['category'].id):null;
      Offer offer = Offer.fromJson({...doc.data(),'id':doc.id,'_id':doc.id,'erg':erg,'category':category});
      if (offer.expiration.isAfter(DateTime.now()))
        offers.add(offer);
    }
    offers.sort((b, a) => a.expiration.compareTo(b.expiration));
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
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(_activitiesCollection).get();
    final List<Activity> activities = [];
    for (final doc in querySnapshot.docs) {
      dynamic erg= doc.data()['erg']!=null? getERGByID(doc.data()['erg'].id):null;
      Activity activity=Activity.fromJson({...doc.data(),'id':doc.id,'_id':doc.id,'erg':erg});
      if (activity.endDate.isAfter(DateTime.now()))
        activities.add(activity);
    }
    return activities;
  }

  static Future<Activity> getActivityByName(String name) async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(_activitiesCollection).
        where('name', isEqualTo: name).get();
    final List<Activity> activities = [];
    for (final doc in querySnapshot.docs) {
      dynamic erg= doc.data()['erg']!=null? getERGByID(doc.data()['erg'].id):null;
      Activity activity=Activity.fromJson({...doc.data(),'id':doc.id,'_id':doc.id,'erg':erg});
      if (activity.endDate.isAfter(DateTime.now()))
        activities.add(activity);
    }
    return activities[0];
  }

  static Future<List<Activity>> getActivitiesByERG(ERG erg) async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(_activitiesCollection).
    where('erg', isEqualTo: erg.id).get();
    final List<Activity> activities = [];
    for (final doc in querySnapshot.docs) {
      dynamic erg= doc.data()['erg']!=null? getERGByID(doc.data()['erg'].id):null;
      Activity activity=Activity.fromJson({...doc.data(),'id':doc.id,'_id':doc.id,'erg':erg});
      if (activity.endDate.isAfter(DateTime.now()))
        activities.add(activity);
    }
    return activities;
  }

  static Future<List<Webinar>> getWebinars() async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(_webinarsCollection).get();
    final List<Webinar> webinars = [];
    for (final doc in querySnapshot.docs) {
      dynamic erg= doc.data()['erg']!=null? getERGByID(doc.data()['erg'].id):null;
      Webinar webinar=Webinar.fromJson({...doc.data(),'id':doc.id,'_id':doc.id,'erg':erg});
      if (webinar.isRecorded == true)
        webinars.add(webinar);
    }
    webinars.sort((b, a) => a.startDate.compareTo(b.startDate));
    return webinars;
  }

  static Future<Webinar> getWebinarByName(String name) async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(_webinarsCollection).
        where('name',isEqualTo: name).get();
    final List<Webinar> webinars = [];
    for (final doc in querySnapshot.docs) {
      dynamic erg= doc.data()['erg']!=null? getERGByID(doc.data()['erg'].id):null;
      Webinar webinar=Webinar.fromJson({...doc.data(),'id':doc.id,'_id':doc.id,'erg':erg});
      if (webinar.isRecorded == true)
        webinars.add(webinar);
    }
    webinars.sort((b, a) => a.startDate.compareTo(b.startDate));
    return webinars[0];
  }

 static Future<Announcement> getAnnouncementByName(String name) async {
   final QuerySnapshot querySnapshot =
   await FirebaseFirestore.instance.collection(_announcementCollection).
   where('name',isEqualTo: name).get();
   dynamic doc = querySnapshot.docs[0];
   dynamic erg= doc.data()['erg']!=null? getERGByID(doc.data()['erg'].id):null;
   return Announcement.fromJson({...doc.data(),'id':doc.id,'_id':doc.id,'erg':erg});
  }

  static Future<List<Webinar>> getWebinarsByERG(ERG erg) async {
    DocumentReference ergRef = FirebaseFirestore.instance.collection(_ergsCollection).doc(erg.id);
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(_webinarsCollection).
    where('erg',isEqualTo: ergRef).get();
    final List<Webinar> webinars = [];
    for (final doc in querySnapshot.docs) {
      dynamic erg= doc.data()['erg']!=null? getERGByID(doc.data()['erg'].id):null;
      Webinar webinar=Webinar.fromJson({...doc.data(),'id':doc.id,'_id':doc.id,'erg':erg});
      if (webinar.isRecorded == true)
        webinars.add(webinar);
    }
    webinars.sort((b, a) => a.startDate.compareTo(b.startDate));
    return webinars;
  }

  static Future<List<Event>> getEvents() async {
    final List<Event> events = [];
      final QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection(_eventsCollection).get();
      for (final doc in querySnapshot.docs) {
        dynamic erg= doc.data()['erg']!=null? getERGByID(doc.data()['erg'].id):null;
        Event event = Event.fromJson(
            {...doc.data(), 'id': doc.id, '_id': doc.id,'erg':erg});
        if (event.endDate.isAfter(DateTime.now()))
          events.add(event);
      }
      events.sort((b, a) => a.startDate.compareTo(b.startDate));
    return events;
  }

  static Future<List<Event>> getAllEvents() async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(_eventsCollection).get();
    final List<Event> events = [];
    for (final doc in querySnapshot.docs) {
      dynamic erg= doc.data()['erg']!=null? getERGByID(doc.data()['erg'].id):null;
      Event event =  Event.fromJson({...doc.data(), 'id': doc.id, '_id': doc.id,'erg':erg});
      events.add(event);
    }
    events.sort((b, a) => a.startDate.compareTo(b.startDate));
    return events;
  }

  static Future<Event> getEventByName(String name) async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(_eventsCollection).
    where('name',isEqualTo: name).
    get();
    final List<Event> events = [];
    for (final doc in querySnapshot.docs) {
      dynamic erg= doc.data()['erg']!=null?getERGByID(doc.data()['erg'].id):null;
      Event event =  Event.fromJson({...doc.data(), 'id': doc.id, '_id': doc.id,'erg':erg});
      events.add(event);
    }
    events.sort((b, a) => a.startDate.compareTo(b.startDate));
    return events[0];
  }

  static Future<List<Event>> getEventsByERG(String ergId) async {
    DocumentReference ergRef = FirebaseFirestore.instance.collection(_ergsCollection).doc(ergId);
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(_eventsCollection).
    where('erg',isEqualTo: ergRef).
    get();
    final List<Event> events = [];
    for (final doc in querySnapshot.docs) {
      dynamic erg= doc.data()['erg']!=null?getERGByID(doc.data()['erg'].id):null;
      Event event =  Event.fromJson({...doc.data(), 'id': doc.id, '_id': doc.id,'erg':erg});
      events.add(event);
    }
    events.sort((b, a) => a.startDate.compareTo(b.startDate));
    return events;
  }

  static Future<List<Event>> getRecentEvents() async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(_eventsCollection).get();
    final List<Event> events = [];
    for (final doc in querySnapshot.docs) {
      dynamic erg= doc.data()['erg']!=null? getERGByID(doc.data()['erg'].id):null;
      Event event =  Event.fromJson({...doc.data(), 'id': doc.id, '_id': doc.id,'erg':erg});
      if (event.endDate.isAfter(DateTime.now()))
        events.add(event);
    }
    events.sort((b, a) => a.startDate.compareTo(b.startDate));
    events.sublist(0, 6);
    return events;
  }

  static Future<List<Webinar>> getSliderWebinars() async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(_webinarsCollection).
    where('slider',isEqualTo: true).get();
    final List<Webinar> webinars = [];
    for (final doc in querySnapshot.docs) {
      dynamic erg= doc.data()['erg']!=null? getERGByID(doc.data()['erg'].id):null;
      Webinar webinar=Webinar.fromJson({...doc.data(),'id':doc.id,'_id':doc.id,'erg':erg});
      if (webinar.isRecorded == true)
        webinars.add(webinar);
    }
    webinars.sort((b, a) => a.startDate.compareTo(b.startDate));
    return webinars;
  }

  static Future<List<Event>> getSliderEvents() async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(_eventsCollection).
    where('slider',isEqualTo: true).
    get();
    final List<Event> events = [];
    for (final doc in querySnapshot.docs) {
      dynamic erg= doc.data()['erg']!=null? getERGByID(doc.data()['erg'].id):null;
      Event event =  Event.fromJson({...doc.data(), 'id': doc.id, '_id': doc.id,'erg':erg});
      events.add(event);
    }
    events.sort((b, a) => a.startDate.compareTo(b.startDate));
    return events;
  }

  static Future<List<Announcement>> getAnnouncements() async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(_announcementCollection).
    get();
    final List<Announcement> announcements = [];
    for (final doc in querySnapshot.docs) {
      dynamic erg= doc.data()['erg']!=null? getERGByID(doc.data()['erg'].id):null;
      announcements.add(Announcement.fromJson({...doc.data(),'id':doc.id,'_id':doc.id,'erg':erg}));
    }
    return announcements;
  }

  /// Returns list of all announcements future or null deadlines
  static Future<List<Announcement>> getUnexpiredAnnouncements() async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(_announcementCollection).
    get();
    final List<Announcement> announcements = [];
    for (final doc in querySnapshot.docs) {
      dynamic erg= doc.data()['erg']!=null? getERGByID(doc.data()['erg'].id):null;
      announcements.add(Announcement.fromJson({...doc.data(),'id':doc.id,'_id':doc.id,'erg':erg}));
    }
    return announcements;
  }

  static Future<List<String>> getBusinessUnits() async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(_businessUnitCollection).
    get();
    final List<String> BUs = [];
    for (final doc in querySnapshot.docs) {
      BUs.add(doc.data()['name']);
    }
    return BUs;
  }
  static Future<List<WireMagazine>> getWireMagazines() async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(_wireMagazineCollection).
    get();
    final List<WireMagazine> wireMagazines = [];
    for (final doc in querySnapshot.docs) {
      wireMagazines.add(WireMagazine.fromJson({...doc.data(),'id':doc.id,'_id':doc.id}));
    }
    wireMagazines.sort((b, a) => a.edition.compareTo(b.edition));
    return wireMagazines;
  }
}
