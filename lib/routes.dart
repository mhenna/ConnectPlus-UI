import 'package:flutter/material.dart';
import 'Events.dart';
import 'Offers.dart';


class Routes{

  static const String events = '/events';
  static const String offers = '/offers';

  static final routes = <String, WidgetBuilder>{

    events: (BuildContext context) => Events(),
    offers: (BuildContext context) => Offers(),

  };
}