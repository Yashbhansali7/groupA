import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:job_assessment/instantMatch/imHome.dart';
import 'package:job_assessment/instantMatch/imSearch.dart';
import 'package:job_assessment/screens/login_screen.dart';
import 'package:job_assessment/signIn/SignUp_TAC.dart';
import 'package:job_assessment/signIn/SignUp_basic.dart';
import 'package:job_assessment/signIn/SignUp_dp.dart';
import 'package:job_assessment/signIn/SignUp_general.dart';
import 'package:job_assessment/signIn/SignUp_interest.dart';
import './screens/login_screen.dart';
import './screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'location/location_model.dart';
import 'location/location_services.dart';
import './screens/swipe_screen.dart';
import './screens/tabs_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        
        StreamProvider<LocationModel>.value(
          value: LocationService().getStreamData(),
          initialData: LocationModel(0, 0),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Job Assessment',
          theme: ThemeData(
            canvasColor: Colors.transparent,
            primarySwatch: Colors.teal,
          ),
          home: MyHome(),
          routes: {
            LoginPage.routeName: (ctx) => LoginPage(),
            WelcomeScreen.routeName: (ctx) => WelcomeScreen(),
            TabsScreen.routeName: (ctx) => TabsScreen(),
            SwipeScreen.routeName: (ctx) => SwipeScreen(),
            SignUpBasic.routeName: (ctx) => SignUpBasic(),
            SignUpGeneral.routeName: (ctx) => SignUpGeneral(),
            SignUpTAC.routeName: (ctx) => SignUpTAC(),
            SignUpInterest.routeName: (ctx) => SignUpInterest(),
            SignUpDP.routeName: (ctx) => SignUpDP(),
            IMHome.modalRoute: (ctx) => IMHome(),
            IMSearch.routeName: (ctx) => IMSearch()
          }),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 2),
      () {
        Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'asset/groupalike.jpg',
        ),
      ),
    );
  }
}
