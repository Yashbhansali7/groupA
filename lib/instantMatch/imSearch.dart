import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:job_assessment/groups/groupChat.dart';
import 'package:job_assessment/instantMatch/imHome.dart';
import 'package:job_assessment/Global.dart' as global;
import 'package:http/http.dart' as http;
import 'package:job_assessment/profileSettings/memberProfile.dart';
import 'package:job_assessment/screens/tabs_screen.dart';

class IMSearch extends StatefulWidget {
  static const routeName = '/imSearch';
  @override
  _IMSearchState createState() => _IMSearchState();
}

class _IMSearchState extends State<IMSearch> {
  bool isDone = false;
  bool isFailed = false;
  int count = 0;
  showDialogBox() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 6,
              sigmaY: 6,
            ),
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        'Seems like you\'re here first!',
                        style: TextStyle(
                            color: Colors.cyan[700],
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      Text('''We couldn't find nearby users,
please try again later.''',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[850],
                            fontSize: 18,
                          )),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.cyan[700]),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              )))),
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(IMHome.modalRoute);
                          },
                          child: Text('Okay'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  initState() {
    getGroupsIM(global.instantMatchBody);
    super.initState();
  }

  List userDetails = [];
  var jsonResponse;
  getGroupsIM(String body) async {
    final url = Uri.parse('http://65.2.117.202:5000/api/v2/instantMatch');
    var headers = {
      'x-access-token': global.token,
      'sourceFrom': '25',
      'Content-Type': 'application/json'
    };
    var res = await http.post(url, body: body, headers: headers);
    if (res.statusCode == 200) {
      jsonResponse = json.decode(res.body);
      setState(() {
        isDone = true;
        //count = jsonResponse[count].toInt();
      });
      print('Response Status: ${res.body.toString()}');
      for (int i = 0; i < jsonResponse['users'].length; i++)
        _userDetails(jsonResponse['users'][i]['uuid']);
    } else {
      setState(() {
        isFailed = true;
      });
      showDialogBox();
      jsonResponse = json.decode(res.body);
      print(res.reasonPhrase);
      print(jsonResponse['error'].toString());
    }
  }

  var createdRes;
  createInstantMatch(id) async {
    final url = Uri.parse('http://65.2.117.202:5000/api/v2/createInstantMatch');
    var headers = {
      'x-access-token': global.token,
      'sourceFrom': '25',
    };
    Map body = {'reviewId': id};
    var res = await http.post(url, body: body, headers: headers);
    if (res.statusCode == 200) {
      createdRes = json.decode(res.body);
      setState(() {
        global.loadMessagesGroupId = createdRes['groupId'];
        global.loadMessagesGroupName = 'instantMatch';
      });
      Navigator.of(context).pushReplacementNamed(GroupChat.routeName);
      print('Response Status: ${res.body.toString()}');
    } else {
      createdRes = json.decode(res.body);
      print(res.reasonPhrase);
      print(createdRes['error'].toString());
    }
  }

  showValidationDialog() {
    showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)), //this right here
            child: Container(
              height: 190,
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Cancelling this group match would temporarily disable match with people in this group.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Colors.cyan[700],
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            )),
                        SizedBox(
                          width: 40,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.popUntil(context,
                                  ModalRoute.withName(TabsScreen.routeName));
                            },
                            child: Text(
                              'Proceed',
                              style: TextStyle(
                                  color: Colors.cyan[700],
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  var detailsResponse;
  _userDetails(id) async {
    final url = Uri.parse('http://65.2.117.202:5000/api/v2/profile?uuid=$id');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {'x-access-token': global.token, 'sourceFrom': '25'};
    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      setState(() {
        detailsResponse = json.decode(res.body);
      });
      userDetails.insert(0, detailsResponse);
    } else {
      print(res.reasonPhrase);
      print(res.body.toString());
    }
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          enableFeedback: false,
          splashFactory: NoSplash.splashFactory,
          onTap: () => showValidationDialog(),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.teal,
            size: 30,
          ),
        ),
        elevation: 1,
        titleSpacing: 3,
        title: Text(
          'Find another group',
          style: TextStyle(
              fontSize: 24, color: Colors.black, fontWeight: FontWeight.w300),
        ),
      ),
      body: isDone
          ? Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height - 150,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1, childAspectRatio: 1.6),
                    itemCount: userDetails.length,
                    padding: EdgeInsets.symmetric(vertical: 40),
                    itemBuilder: (context, i) {
                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    global.getMemberuid =
                                        userDetails[i]['userprofile']['uuid'];
                                  });
                                  Navigator.of(context).pushReplacementNamed(
                                      MemberProfileScreen.routeName);
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey[200],
                                  radius: 46,
                                  backgroundImage: userDetails[i]['userprofile']
                                              ['userProfiles'][0]['image'] ==
                                          null
                                      ? null
                                      : NetworkImage(userDetails[i]
                                              ['userprofile']['userProfiles'][0]
                                          ['image']),
                                  child: userDetails[i]['userprofile']
                                              ['userProfiles'][0]['image'] !=
                                          null
                                      ? null
                                      : Icon(
                                          Icons.person,
                                          color: Colors.cyan[800],
                                          size: 64,
                                        ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(15),
                                child: Text(
                                  userDetails[i]['userprofile']['name'],
                                  style: TextStyle(
                                      color: Colors.cyan[700], fontSize: 22),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              SizedBox(
                                height: 50,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '0',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          'Trips',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          userDetails[i]['userprofile']
                                                  ['footprints']
                                              .length
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          'Footprints',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          userDetails[i]['userprofile']
                                              ['starCount'],
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          'Stars',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          userDetails[i]['userprofile']
                                                  ['userReviews']
                                              .length
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          'Reviews',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '0',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          'Tagged',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                FloatingActionButton.extended(
                    onPressed: () {
                      createInstantMatch(jsonResponse['reviewId']);
                    },
                    label: Text(
                      'Get Connected',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                    ))
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(top: 30),
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Text(
                      'This should only take a moment..',
                      style: TextStyle(
                          color: Colors.cyan[700],
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    )),
                CircleAvatar(
                  radius: 120,
                  child: Image.asset('asset/groupalike.jpg'),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text(
                    '''Please wait while our
match algorithm are at work to get
you the best match in a group!''',
                    style: TextStyle(
                        color: Colors.grey[850],
                        fontSize: 20,
                        fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
    );
  }
}
