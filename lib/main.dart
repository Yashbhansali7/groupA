import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:job_assessment/events/addEventDnT.dart';
import 'package:job_assessment/events/addEventHome.dart';
import 'package:job_assessment/events/addEventLocation.dart';
import 'package:job_assessment/events/eventDetails.dart';
import 'package:job_assessment/forgorPass/changePassword.dart';
import 'package:job_assessment/groups/addGroups.dart';
import 'package:job_assessment/groups/groupChat.dart';
import 'package:job_assessment/groups/nearbyGroup.dart';
import 'package:job_assessment/groups/trendingGroups.dart';
import 'package:job_assessment/instantMatch/imHome.dart';
import 'package:job_assessment/instantMatch/imSearch.dart';
import 'package:job_assessment/profileSettings/customizeUserProfile.dart';
import 'package:job_assessment/profileSettings/editUserProfile.dart';
import 'package:job_assessment/profileSettings/memberProfile.dart';
import 'package:job_assessment/profileSettings/userProfile.dart';
import 'package:job_assessment/referFriend/referAFriendHome.dart';
import 'package:job_assessment/screens/blockedMember_screen.dart';
import 'package:job_assessment/screens/followRequest_screen.dart';
import 'package:job_assessment/forgorPass/forgetPasswordHome.dart';
import 'package:job_assessment/forgorPass/forgotPasswordOTP.dart';
import 'package:job_assessment/screens/login_screen.dart';
import 'package:job_assessment/screens/manageNoti_screen.dart';
import 'package:job_assessment/referFriend/referAFriend_screen.dart';
import 'package:job_assessment/screens/settings.dart';
import 'package:job_assessment/chats/singleChat_screen.dart';
import 'package:job_assessment/events/upcomingEvents.dart';
import 'package:job_assessment/signUp/SignUp_TAC.dart';
import 'package:job_assessment/signUp/SignUp_basic.dart';
import 'package:job_assessment/signUp/SignUp_dp.dart';
import 'package:job_assessment/signUp/SignUp_general.dart';
import 'package:job_assessment/signUp/SignUp_interest.dart';
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
          title: 'Job',
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
            IMSearch.routeName: (ctx) => IMSearch(),
            AddEventHome.routeName: (ctx) => AddEventHome(),
            AddEventDnT.routeName: (ctx) => AddEventDnT(),
            SingleChatScreen.routeName: (ctx) => SingleChatScreen(),
            SettingsScreen.routeName: (ctx) => SettingsScreen(),
            FollowRequestScreen.routeName: (ctx) => FollowRequestScreen(),
            BlockedMemberScreen.routeName: (ctx) => BlockedMemberScreen(),
            ManageNotiScreen.routeName: (ctx) => ManageNotiScreen(),
            ReferAFriendContact.routeName: (ctx) => ReferAFriendContact(),
            UserProfileScreen.routeName: (ctx) => UserProfileScreen(),
            EditUserProfile.routeName: (ctx) => EditUserProfile(),
            CustomizeUserProfile.routeName: (ctx) => CustomizeUserProfile(),
            ReferAFriendHome.routeName: (ctx) => ReferAFriendHome(),
            ForgetPasswordHome.routeName: (ctx) => ForgetPasswordHome(),
            ForgotPasswordOTP.routeName: (ctx) => ForgotPasswordOTP(),
            ChangePassword.routeName: (ctx) => ChangePassword(),
            UpcomingEvent.routeName: (ctx) => UpcomingEvent(),
            TrendingGroups.routeName: (ctx) => TrendingGroups(),
            GroupChat.routeName: (ctx) => GroupChat(),
            AddEventLocation.routeName: (ctx) => AddEventLocation(),
            EventsDetails.routeName: (ctx) => EventsDetails(),
            AddGroups.routeName: (ctx) => AddGroups(),
            NearByGroups.routeName: (ctx) => NearByGroups(),
            MemberProfileScreen.routeName: (ctx) => MemberProfileScreen(),
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
