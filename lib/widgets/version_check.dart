//Prompt users to update app if there is a new version available
//Uses url_launcher package

import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

versionCheck(context) async {
  //Get Current installed version of app
  final PackageInfo info = await PackageInfo.fromPlatform();
  List<String> currentVersionList = info.version.split(".");
  double currentVersion = double.parse(currentVersionList[0]) +
      (double.parse(currentVersionList[1]) / 10.0);
  print('CURRENT VERSION: ${currentVersion}');

  //Get Latest version info from firebase config
  final RemoteConfig remoteConfig = await RemoteConfig.instance;

  try {
    // Using default duration to force fetching from remote server.
    await remoteConfig.fetch(expiration: const Duration(seconds: 0));
    await remoteConfig.activateFetched();
    String device = "android";
    if (Platform.isIOS) device = "ios";
    String query = "force_update_current_version_" + device;
    double newVersion = double.parse(remoteConfig.getString(query));
    print('NEW VERSION: ${newVersion}');
    if (newVersion > currentVersion) {
      _showVersionDialog(context);
    }
  } on FetchThrottledException catch (exception) {
    // Fetch throttled.
    print(exception);
  } catch (exception) {
    print('Unable to fetch remote config. Cached or default values will be '
        'used');
  }
}

//Show Dialog to force user to update
_showVersionDialog(context) async {
  await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      String title = "New Update Available";
      String message =
          "There is a newer version of app available please update it now.";
      String btnLabel = "Update Now";
      return Platform.isIOS
          ? new CupertinoAlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text(btnLabel),
                  onPressed: () => _launchURL(
                      "https://apps.apple.com/us/app/connect-coe/id1542591430"),
                )
              ],
            )
          : new CupertinoAlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text(btnLabel),
                  onPressed: () => _launchURL(
                      "https://play.google.com/store/apps/details?id=com.techdev.connect_plus"),
                )
              ],
            );
    },
  );
  await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', true);
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
