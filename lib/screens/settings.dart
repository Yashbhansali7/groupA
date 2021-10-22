import 'package:flutter/material.dart';
import 'package:job_assessment/screens/followRequest_screen.dart';
import 'package:job_assessment/screens/manageNoti_screen.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settingsScreen';
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Padding headingText(String data) {
    return Padding(
      padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
      child: Text(
        data,
        style: TextStyle(
            fontSize: 22,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
            letterSpacing: .7),
      ),
    );
  }

  Padding subHeadingText(String data) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 30),
      child: Container(
     //   width: double.infinity,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(data,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                //letterSpacing: .7),
              )),
        ),
      ),
    );
  }

  bool openForEventsBool = true;
  bool discoveryBool = true;
  bool nightmodeBool = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: Navigator.of(context).pop,
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.teal,
            size: 28,
          ),
        ),
        elevation: 1,
        titleSpacing: 3,
        title: Text(
          'Settings',
          style: TextStyle(
              fontSize: 24, color: Colors.black, fontWeight: FontWeight.w300),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headingText('Account'),
              ListTile(
                leading: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                    ),
                    color: Colors.grey[100],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.mail,
                        color: Colors.deepPurple,
                      ),
                    )),
                title: Text(
                  'Google',
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),
                ),
                trailing: Text('abc@gmail.com',
                    style: TextStyle(color: Colors.grey, fontSize: 18)),
              ),
              subHeadingText('Disconnect Account'),
              subHeadingText('Deactivate Account'),
              headingText('Events'),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    subHeadingText('Open For Events'),
                    Switch(
                      value: openForEventsBool,
                      onChanged: (value) {
                        setState(() {
                          openForEventsBool = value;
                          print(openForEventsBool);
                        });
                      },
                      activeTrackColor: Colors.grey[300],
                      activeColor: Colors.cyan[600],
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor:  Colors.grey[300],                      
                    ),
                  ],
                ),
              
              headingText('Groups'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [                  
                  subHeadingText('Discovery'),
                  Switch(
                      value: discoveryBool,
                      onChanged: (value) {
                        setState(() {
                          discoveryBool = value;
                          print(discoveryBool);
                        });
                      },
                      activeTrackColor: Colors.grey[300],
                      activeColor: Colors.cyan[600],
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor:  Colors.grey[300],                      
                    ),
                ],
              ),
              headingText('General'),
              GestureDetector(
                  onTap: () => Navigator.of(context)
                      .pushNamed(FollowRequestScreen.routeName),
                  child: subHeadingText('Blocked Members')),
              subHeadingText('Manage Categories'),
              GestureDetector(onTap: () => Navigator.of(context)
                      .pushNamed(ManageNotiScreen.routeName),child: subHeadingText('Set up notifications')),
              subHeadingText('Profile Settings'),
              subHeadingText('Currency'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  subHeadingText('Night mode'),
                   Switch(
                      value: nightmodeBool,
                      onChanged: (value) {
                        setState(() {
                          nightmodeBool = value;
                          print(nightmodeBool);
                        });
                      },
                      activeTrackColor: Colors.grey[300],
                      activeColor: Colors.cyan[600],
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor:  Colors.grey[300],                      
                    ),
                ],
              ),
              subHeadingText('Developer'),
              subHeadingText('Language'),
              headingText('Other'),
              subHeadingText('Rate us'),
              subHeadingText('Export Data'),
              subHeadingText('Text Size'),
              subHeadingText('Clear Local data'),
              subHeadingText('Restore Purchases'),
              headingText('About'),
              subHeadingText('Help'),
              subHeadingText('Community guidelines'),
              subHeadingText('Twitter'),
              subHeadingText('Privacy Policy'),
              subHeadingText('Terms of Use'),
              Container(
                child: Center(
                  child: Text(
                    'App Version 2.0.0',
                    style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                width: double.infinity,
                padding: EdgeInsets.all(20),
              )
            ],
          ),
        ),
      ),
    );
  }
}
