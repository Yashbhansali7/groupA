import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_assessment/events/addEventHome.dart';
import 'package:job_assessment/Global.dart' as global;
import 'package:http/http.dart' as http;
import 'package:job_assessment/events/eventDetails.dart';
import 'package:job_assessment/events/upcomingEvents.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  initState() {
    setState(() {
      global.addEventName = '';
      global.addEventDesc = '';
      global.addEventTags = [];
      global.addEventStartTime = '';
      global.addEventEndTime = '';
      global.addEventStartDate = '';
      global.addEventLat = '';
      global.addEventLong = '';
      global.addEventType = '';
      global.addEventGroupId = '';
      global.addEventGroupMemberId = '';
      global.placeName = '';
      global.placeAddress = '';
    });

    _generateCatGroups();
    _events();
    super.initState();
  }

  bool isLoading = true;
  var catGroupsRepsonse;
  _generateCatGroups() async {
    final url = Uri.parse('http://65.2.117.202:5000/api/v2/groups');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {'x-access-token': global.token, 'sourceFrom': '25'};
    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      setState(() {
        catGroupsRepsonse = json.decode(res.body);
      });
    } else {
      print(res.reasonPhrase);
      print(res.body.toString());
    }
  }

  var eventsRepsonse;
  _events() async {
    final url = Uri.parse('http://65.2.117.202:5000/api/v2/events');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {'x-access-token': global.token, 'sourceFrom': '25'};
    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      setState(() {
        eventsRepsonse = json.decode(res.body);
      });
      for (int i = 0; i < eventsRepsonse['events'].length; i++)
        _groupDetails(eventsRepsonse['events'][i]['groupId']);
      print(eventsRepsonse);
    } else {
      print(res.reasonPhrase);
      print(res.body.toString());
    }
  }

  var detailsResponse;
  List groupName = [];
  List groupImg = [];
  _groupDetails(id) async {
    final url =
        Uri.parse('http://65.2.117.202:5000/api/v2/groupDetails?groupId=$id');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {'x-access-token': global.token, 'sourceFrom': '25'};
    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      setState(() {
        detailsResponse = json.decode(res.body);
      });
      groupName.insert(0, detailsResponse['groups']['name']);
      groupImg.insert(0, detailsResponse['groups']['image']);
      if (eventsRepsonse['events'].length == groupName.length) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print(res.reasonPhrase);
      print(res.body.toString());
    }
  }

  showMessageDialog() {
    showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)), //this right here
            child: Container(
              height: 320,
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                child: Column(
                  children: [
                    Text(
                      'Select Group',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        itemCount: catGroupsRepsonse['groups'].length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 1),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    global.addEventGroupId =
                                        catGroupsRepsonse['groups'][index]
                                            ['id'];
                                    global.addEventGroupMemberId =
                                        catGroupsRepsonse['groups'][index]
                                            ['groupMembers'][0]['id'];
                                  });
                                  Navigator.of(context)
                                      .pushNamed(AddEventHome.routeName);
                                },
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 6),
                                horizontalTitleGap: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                leading: catGroupsRepsonse['groups'][index]
                                            ['image'] ==
                                        null
                                    ? Icon(
                                        Icons.sports,
                                        size: 35,
                                        color: Colors.blue,
                                      )
                                    : Container(
                                        child: Image.network(
                                            catGroupsRepsonse['groups'][index]
                                                ['image']),
                                        height: 40,
                                        width: 40,
                                      ),
                                title: Text(
                                  catGroupsRepsonse['groups'][index]['name'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontSize: 16),
                                ),
                                tileColor: Colors.white,
                                minVerticalPadding: 6,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 10,
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Events',
            style: TextStyle(
                color: Colors.teal[700],
                fontSize: 40,
                fontWeight: FontWeight.w400),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(UpcomingEvent.routeName);
              },
              icon: Icon(
                Icons.calendar_today,
                color: Colors.teal[800],
                size: 35,
              )),
          Container(
            padding: EdgeInsets.only(left: 7, right: 3),
            margin: EdgeInsets.only(top: 22, bottom: 22, left: 15),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateTime.now().day.toString(),
                  style: TextStyle(color: Colors.grey[800], fontSize: 28),
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Oct',
                      style: TextStyle(color: Colors.grey[800], fontSize: 13),
                    ),
                    Text(
                      DateTime.now().year.toString(),
                      style: TextStyle(color: Colors.grey[800], fontSize: 13),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        child: eventsRepsonse == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No Events yet',
                    style: TextStyle(
                        color: Colors.teal[800],
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                  Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 70),
                      child: Text('Schedule an event to get started',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w300,
                              fontSize: 18))),
                  FloatingActionButton(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.teal[900],
                      onPressed: () {
                        showMessageDialog();
                      },
                      child: Icon(
                        Icons.add,
                        color: Colors.teal[900],
                        size: 50,
                      )),
                  Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 70),
                      child: Text(
                          'Schedule your group\'s next event in a few simple steps',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w300,
                              fontSize: 18)))
                ],
              )
            : isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(left: 10, top: 10),
                    itemCount: eventsRepsonse['events'].length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.only(left: 10),
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              eventsRepsonse['events'][index]['createdAt']
                                  .toString()
                                  .substring(8, 10),
                              style: TextStyle(
                                  color: Colors.grey[800], fontSize: 28),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Sep',
                                  style: TextStyle(
                                      color: Colors.grey[800], fontSize: 13),
                                ),
                                Text(
                                  DateTime.now().year.toString(),
                                  style: TextStyle(
                                      color: Colors.grey[800], fontSize: 13),
                                ),
                              ],
                            )
                          ],
                        ),
                        title: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    spreadRadius: 1)
                              ]),
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 10, top: 15),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(40)),
                                  child: CircleAvatar(
                                    backgroundImage: groupImg[index] == null
                                        ? null
                                        : NetworkImage(
                                            groupImg[index],
                                          ),
                                    child: groupImg[index] == null
                                        ? Icon(
                                            Icons.groups,
                                            size: 50,
                                            color: Colors.cyan[800],
                                          )
                                        : null,
                                    backgroundColor: Colors.white,
                                    radius: 30,
                                  )),
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 75,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          eventsRepsonse['events'][index]
                                                      ['name'] ==
                                                  null
                                              ? ''
                                              : eventsRepsonse['events'][index]
                                                  ['name'],
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          groupName[index],
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 13, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                    EventsDetails.routeName);
                                                setState(() {
                                                  global.selectedEvent =
                                                      eventsRepsonse['events']
                                                          [index];
                                                });
                                                print(global.selectedEvent);
                                              },
                                              icon: Icon(Icons.info))),
                                      Text(
                                        eventsRepsonse['events'][index]
                                                    ['startAt']
                                                .toString()
                                                .substring(11, 16) +
                                            '-' +
                                            eventsRepsonse['events'][index]
                                                    ['endAt']
                                                .toString()
                                                .substring(11, 16),
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.grey),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                          width: double.infinity,
                        ),
                      );
                    },
                  ),
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12, width: 2),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.tealAccent)),
        child: FloatingActionButton(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            onPressed: () {
              showMessageDialog();
            },
            child: Icon(
              Icons.add,
              size: 30,
            )),
      ),
    );
  }
}
