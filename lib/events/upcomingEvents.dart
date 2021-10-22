import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:job_assessment/Global.dart' as global;

class UpcomingEvent extends StatefulWidget {
  static const routeName = 'upcomingEvent';

  @override
  _UpcomingEventState createState() => _UpcomingEventState();
}

class _UpcomingEventState extends State<UpcomingEvent> {
  var jsonResponse;
  bool dataRecived = false;
  bool upcomingEmpty = false;
  void initState() {
    loadUpcoming();
    super.initState();
  }

  loadUpcoming() async {
    final url =
        Uri.parse('http://65.2.117.202:5000/api/v2/upcomingEvents?page=0');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {'x-access-token': global.token, 'sourceFrom': '25'};
    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      jsonResponse = json.decode(res.body);
      print(jsonResponse);
      if (jsonResponse['events'].length == 0) {
        setState(() {
          upcomingEmpty = true;
        });
      }
      if (jsonResponse.toString().isNotEmpty) {
        setState(() {
          dataRecived = true;
        });
      }
    } else {
      print(res.body.toString());
    }
  }

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
          'Upcoming Events',
          style: TextStyle(
              fontSize: 24, color: Colors.black, fontWeight: FontWeight.w300),
        ),
      ),
      body:dataRecived
          ?  
          // upcomingEmpty?
           Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'asset/Group5271.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 70,
                    ),
                    child: Text('You have no upcoming events',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400,
                            fontSize: 16))),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 70),
                    child: Text(
                      'Create an event in a group or from the events section',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                      textAlign: TextAlign.center,
                    ))
              ],
            )
          // : Container(
          //     color: Colors.red,
          //   )
            :Center(child: CircularProgressIndicator(),),
    );
  }
}
