import 'package:connect_plus/widgets/version_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:connect_plus/login.dart';
import 'package:connect_plus/homepage.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connect_plus/injection_container.dart' as di;
import 'package:connect_plus/services/auth_service/auth_service.dart';
import 'package:connect_plus/models/user.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DotEnv().load('.env');
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    di.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Connect+',
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigationKey,
      routes: Routes.routes,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 5,
      navigateAfterSeconds: FutureBuilder<User>(
          future: authService.getUser(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              versionCheck(context);
              return Login(
                title: "login",
              );
            } else {
              return MyHomePage();
            }
          }),
      imageBackground: AssetImage('assets/splash.png'),
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      loaderColor: Colors.white,
    );
  }
}
