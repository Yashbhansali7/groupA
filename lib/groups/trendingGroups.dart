import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:job_assessment/Global.dart' as global;
import 'package:http/http.dart' as http;

class TrendingGroups extends StatefulWidget {
  static const routeName = 'trendingGroups';
  @override
  _TrendingGroupsState createState() => _TrendingGroupsState();
}

class _TrendingGroupsState extends State<TrendingGroups> {
  int pageNo = 0;
  List groups = [];
  List groupDetails = [];
  var trendResponse;
  var detailResponse;
  PageController? pageController;
  int currentPage = 0;
  double viewportFraction = .6;
  String reqSent = 'Send Invite';
  double? pageOffset = 0;

  initState() {
    _generateTrendingGroups();
    super.initState();
    pageController =
        PageController(initialPage: 0, viewportFraction: viewportFraction)
          ..addListener(() {
            setState(() {
              pageOffset = pageController!.page;
              currentPage = pageController!.page!.toInt();
            });
          });
  }

  _generateTrendingGroups() async {
    final url = Uri.parse(
        'http://65.2.117.202:5000/api/v2/trendingGroups?page=$pageNo');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {'x-access-token': global.token, 'sourceFrom': '25'};
    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      setState(() {
        trendResponse = json.decode(res.body);
      });
      print(trendResponse);
      for (int i = 0; i < 5; i++) {
        groups.add(trendResponse['groups'][i]['id']);
        _generateGroupDetails(groups[(pageNo * 5) + i]);
      }
      if (pageNo < 3) {
        pageNo = pageNo + 1;
        _generateTrendingGroups();
      }
      print(groups);
    } else {
      print(res.reasonPhrase);
      print(res.body.toString());
    }
  }

  _generateGroupDetails(String groupId) async {
    final url = Uri.parse(
        'http://65.2.117.202:5000/api/v2/groupDetails?groupId=$groupId');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {'x-access-token': global.token, 'sourceFrom': '25'};
    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      setState(() {
        detailResponse = json.decode(res.body);
      });
      groupDetails.add(detailResponse['groups']);

      // print(jsonResponse);
    } else {
      print(res.reasonPhrase);
      print(res.body.toString());
    }
  }

  var inviteResponse;
  _sendInvitation(String id) async {
    final url = Uri.parse('http://65.2.117.202:5000/api/v2/requestGroup');
    var headers = {
      'x-access-token': global.token,
      'sourceFrom': '25',
    };
    Map body = {"groupId": id};
    var res = await http.post(url, body: body, headers: headers);
    if (res.statusCode == 200) {
      inviteResponse = json.decode(res.body);

      print('Response Status: ${res.body.toString()}');
    } else {
      inviteResponse = json.decode(res.body);
      print(res.reasonPhrase);
      print(inviteResponse['error'].toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.teal,
            size: 28,
          ),
        ),
        elevation: 0,
        titleSpacing: 3,
        title: Text(
          'Trending Groups',
          style: TextStyle(
              fontSize: 22, color: Colors.black, fontWeight: FontWeight.w300),
        ),
      ),
      body: trendResponse == null || detailResponse == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 306,
                    child: PageView.builder(
                      controller: pageController,
                      itemBuilder: (context, i) {
                        int groupLength =
                            groupDetails[i]["groupMembers"].length;
                        double scale = max(viewportFraction,
                            (1 - (pageOffset! - i).abs()) + viewportFraction);
                        return Container(
                          padding: EdgeInsets.only(
                            right: 15,
                            left: i == 0 ? 20 : 15,
                            top: 40 - scale * 25,
                            bottom: 0,
                          ),
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 4,
                                    blurRadius: 8,
                                    color: Colors.black12)
                              ],
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.amber,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 13, vertical: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            groupDetails[i]['groupName'] == null
                                                ? groupDetails[i]['name']
                                                : groupDetails[i]['groupName'],
                                            style: TextStyle(
                                                color: Colors.teal[800],
                                                fontSize: 19)),
                                        Text(
                                          '$groupLength members',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 16),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                  ),
                                  child: groupDetails[i]['image'] == null
                                      ? Image.asset(
                                          'asset/groupalike.jpg',
                                          fit: BoxFit.cover,
                                          height: 180,
                                          width: 220,
                                        )
                                      : Image.network(groupDetails[i]['image']),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: groupDetails.length,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .7,
                        height: 75,
                        decoration: BoxDecoration(
                            color: Colors.cyan[800],
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40),
                                bottomRight: Radius.circular(40))),
                        alignment: Alignment.center,
                        child: Text(
                          groupDetails[currentPage]['groupName'] == null
                              ? groupDetails[currentPage]['name']
                              : groupDetails[currentPage]['groupName'],
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        //  color: Colors.pink,
                        padding: EdgeInsets.all(10),
                        child: RichText(
                          text: TextSpan(
                              text: 'Created on \n',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                              children: [
                                TextSpan(
                                  text: DateFormat.yMMMd().format(
                                      DateTime.parse(groupDetails[currentPage]
                                              ['createdAt']
                                          .substring(0, 10))),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                )
                              ]),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 25),
                    child: Column(
                      children: [
                        groupDetails[currentPage]['description'] == null
                            ? Container()
                            : Container(
                                margin: EdgeInsets.only(bottom: 15),
                                width: double.infinity,
                                child: Text(
                                  'Description',
                                  style: TextStyle(
                                      color: Colors.cyan[800],
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                )),
                        groupDetails[currentPage]['description'] == null
                            ? Container()
                            : Container(
                                margin: EdgeInsets.only(bottom: 25),
                                width: double.infinity,
                                child: Text(
                                  groupDetails[currentPage]['description'],
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17),
                                )),
                        groupDetails[currentPage]['tags'].length == 0
                            ? Container()
                            : Container(
                                margin: EdgeInsets.only(bottom: 15),
                                width: double.infinity,
                                child: Text(
                                  'Tags',
                                  style: TextStyle(
                                      color: Colors.cyan[800],
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                )),
                        groupDetails[currentPage]['tags'].length == 0
                            ? Container()
                            : SizedBox(
                                height: 35,
                                child: ListView.builder(
                                  padding: EdgeInsets.only(bottom: 5),
                                  itemCount:
                                      groupDetails[currentPage]['tags'].length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20))),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.cyan[700])),
                                          onPressed: () {},
                                          child: Text(
                                            groupDetails[currentPage]['tags']
                                                [index]['tag']['name'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16),
                                          )),
                                    );
                                  },
                                ),
                              ),
                        Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            width: double.infinity,
                            child: Text(
                              'Members',
                              style: TextStyle(
                                  color: Colors.cyan[800],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20),
                            )),
                        SizedBox(
                          height: 70,
                          child: ListView.builder(
                            itemCount: groupDetails[currentPage]['groupMembers']
                                .length,
                            padding: EdgeInsets.all(0),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    right: 3.0, bottom: 10),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    elevation: 7,
                                    child: CircleAvatar(
                                      backgroundImage: groupDetails[currentPage]
                                                              ['groupMembers']
                                                          [index]['user']
                                                      ['userProfiles'][0]
                                                  ['image'] ==
                                              null
                                          ? null
                                          : NetworkImage(
                                              groupDetails[currentPage]
                                                          ['groupMembers']
                                                      [index]['user']
                                                  ['userProfiles'][0]['image']),
                                      child: groupDetails[currentPage]
                                                              ['groupMembers']
                                                          [index]['user']
                                                      ['userProfiles'][0]
                                                  ['image'] ==
                                              null
                                          ? Icon(
                                              Icons.person,
                                              color: Colors.cyan[800],
                                              size: 45,
                                            )
                                          : null,
                                      radius: 28,
                                      backgroundColor: Colors.white,
                                    )),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 180,
                          margin: EdgeInsets.all(10),
                          child: FloatingActionButton.extended(
                              elevation: 10,
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.cyan[800],
                              onPressed: () {
                                _sendInvitation(groups[currentPage]);
                                setState(() {
                                  reqSent = 'Invite Sent';
                                });
                              },
                              label: Text(
                                reqSent,
                                style: TextStyle(
                                    color: Colors.cyan[700], fontSize: 17),
                              )),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
