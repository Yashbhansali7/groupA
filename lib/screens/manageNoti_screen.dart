import 'package:flutter/material.dart';

class ManageNotiScreen extends StatefulWidget {
  static const routeName = '/manageNotiScreen';
  @override
  _ManageNotiScreenState createState() => _ManageNotiScreenState();
}

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
bool feedNotibool = false;
  bool groupNotiBool = false;
  bool discoverNotiBool = false;
  bool eventsNotiBool = false;
class _ManageNotiScreenState extends State<ManageNotiScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          enableFeedback: false,
          splashFactory: NoSplash.splashFactory,
          onTap: Navigator.of(context).pop,
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.teal,
            size: 30,
          ),
        ),
        elevation: 1,
        titleSpacing: 3,
        title: Text(
          'Set up notifications',
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
              headingText('Feeds'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  subHeadingText('Mute Notifications'),
                  Switch(
                      value: feedNotibool,
                      onChanged: (value) {
                        setState(() {
                          feedNotibool = value;
                          print(feedNotibool);
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
                  subHeadingText('Mute Notifications'),
                  Switch(
                      value: groupNotiBool,
                      onChanged: (value) {
                        setState(() {
                          groupNotiBool = value;
                          print(groupNotiBool);
                        });
                      },
                      activeTrackColor: Colors.grey[300],
                      activeColor: Colors.cyan[600],
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor:  Colors.grey[300],                      
                    ),
                ],
              ),
              headingText('Discover'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  subHeadingText('Mute Notifications'),
                  Switch(
                      value: discoverNotiBool,
                      onChanged: (value) {
                        setState(() {
                          discoverNotiBool = value;
                          print(discoverNotiBool);
                        });
                      },
                      activeTrackColor: Colors.grey[300],
                      activeColor: Colors.cyan[600],
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor:  Colors.grey[300],                      
                    ),
                ],
              ),
              headingText('Events'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  subHeadingText('Mute Notifications'),
                  Switch(
                      value: eventsNotiBool,
                      onChanged: (value) {
                        setState(() {
                          eventsNotiBool = value;
                          print(eventsNotiBool);
                        });
                      },
                      activeTrackColor: Colors.grey[300],
                      activeColor: Colors.cyan[600],
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor:  Colors.grey[300],                      
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
