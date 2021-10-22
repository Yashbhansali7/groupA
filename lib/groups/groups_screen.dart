import 'dart:convert';
import 'package:job_assessment/Global.dart' as global;
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:job_assessment/groups/addGroups.dart';
import 'package:job_assessment/groups/groupChat.dart';
import 'package:job_assessment/groups/nearbyGroup.dart';
import 'package:job_assessment/groups/trendingGroups.dart';

class GroupsScreen extends StatefulWidget {
  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  bool showNearby = true;
  var catGroupsRepsonse;
  var nearbyResponse;
  initState() {
    _generatenearbyGroups(global.lat, global.long);
    _generateCatGroups();
    super.initState();
  }

  _generateCatGroups() async {
    final url = Uri.parse('http://65.2.117.202:5000/api/v2/userCategories');
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

  _generatenearbyGroups(lat, long) async {
    final url = Uri.parse(
        'http://65.2.117.202:5000/api/v2/nearByGroups?sourceLatitude=$lat&sourceLongitude=$long');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {'x-access-token': global.token, 'sourceFrom': '25'};
    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      setState(() {
        nearbyResponse = json.decode(res.body);
      });
      print(nearbyResponse);
    } else {
      print(res.reasonPhrase);
      print(res.body.toString());
    }
  }

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
              'Groups',
              style: TextStyle(
                  color: Colors.teal[700],
                  fontSize: 40,
                  fontWeight: FontWeight.w400),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(TrendingGroups.routeName);
                },
                icon: Icon(
                  Icons.trending_up_rounded,
                  size: 30,
                  color: Colors.teal,
                )),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.filter_alt_outlined,
                size: 30,
                color: Colors.teal,
              ),
            )
          ],
        ),
        body: nearbyResponse == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Text(
                            'Public Groups Nearby',
                            style: TextStyle(
                                color: Colors.cyan[700],
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  showNearby = !showNearby;
                                });
                              },
                              child: Icon(
                                showNearby
                                    ? Icons.arrow_drop_down
                                    : Icons.arrow_drop_up,
                                color: Colors.cyan[700],
                                size: 40,
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: showNearby ? 100 : 0,
                      child: showNearby
                          ? ListView.builder(
                              itemCount: nearbyResponse['groups'].length,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            global.loadNearby =
                                                nearbyResponse['groups'][index]
                                                    ['id'];
                                          });
                                          Navigator.of(context).pushNamed(
                                              NearByGroups.routeName);
                                        },
                                        child: Card(
                                            // margin: EdgeInsets.only(bottom: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            elevation: 7,
                                            child: CircleAvatar(
                                              backgroundImage: nearbyResponse[
                                                              'groups'][index]
                                                          ['image'] ==
                                                      null
                                                  ? null
                                                  : NetworkImage(
                                                      nearbyResponse['groups']
                                                          [index]['image']),
                                              child: nearbyResponse['groups']
                                                          [index]['image'] ==
                                                      null
                                                  ? Icon(
                                                      Icons.groups,
                                                      color: Colors.cyan[800],
                                                      size: 45,
                                                    )
                                                  : null,
                                              radius: 28,
                                              backgroundColor: Colors.white,
                                            )),
                                      ),
                                      Text(
                                        nearbyResponse['groups'][index]
                                                    ['groupName'] ==
                                                null
                                            ? nearbyResponse['groups'][index]
                                                ['name']
                                            : nearbyResponse['groups'][index]
                                                ['groupName'],
                                      )
                                    ],
                                  ),
                                );
                              },
                            )
                          : Container(),
                    ),
                    Stack(children: [
                      SizedBox(
                        height: showNearby
                            ? MediaQuery.of(context).size.height * 0.51
                            : 450,
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemCount: 4,
                          itemBuilder: (context, i) {
                            return Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(0),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 20, bottom: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: i == 0
                                                  ? 50
                                                  : i == 1
                                                      ? 30
                                                      : 0,
                                            ),
                                            Text(
                                              'Active',
                                              style: TextStyle(
                                                  color: i == 0
                                                      ? Colors.cyan[700]
                                                      : Colors.grey,
                                                  fontWeight: i == 0
                                                      ? FontWeight.w600
                                                      : FontWeight.w400,
                                                  fontSize: i == 0 ? 18 : 16),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              'Have Met',
                                              style: TextStyle(
                                                  color: i == 1
                                                      ? Colors.cyan[700]
                                                      : Colors.grey,
                                                  fontWeight: i == 1
                                                      ? FontWeight.w600
                                                      : FontWeight.w400,
                                                  fontSize: i == 1 ? 18 : 16),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text('Favourite',
                                                style: TextStyle(
                                                    color: i == 2
                                                        ? Colors.red
                                                        : Colors.grey,
                                                    fontWeight: i == 2
                                                        ? FontWeight.w600
                                                        : FontWeight.w400,
                                                    fontSize:
                                                        i == 2 ? 18 : 16)),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text('Expired',
                                                style: TextStyle(
                                                    color: i == 3
                                                        ? Colors.black
                                                        : Colors.grey,
                                                    fontWeight: i == 3
                                                        ? FontWeight.w600
                                                        : FontWeight.w400,
                                                    fontSize:
                                                        i == 3 ? 18 : 16)),
                                            SizedBox(
                                              width: i == 2
                                                  ? 30
                                                  : i == 3
                                                      ? 50
                                                      : 0,
                                            ),
                                          ],
                                        ),
                                      ),
                                      i == 0
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white70,
                                                  border: Border.all(
                                                      color: Colors.black26),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  40),
                                                          topRight:
                                                              Radius.circular(
                                                                  40))),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 25.0),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 15),
                                                    child: Text(
                                                      'Category Groups',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.cyan[700],
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: showNearby
                                                        ? MediaQuery.of(context)
                                                                    .size
                                                                    .height *
                                                                .4 -
                                                            25
                                                        : 345,
                                                    child: Container(
                                                      child: ListView.builder(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    25.0),
                                                        itemCount:
                                                            catGroupsRepsonse
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        0,
                                                                    vertical:
                                                                        3),
                                                            child: Card(
                                                              elevation: 4,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15)),
                                                              child: ListTile(
                                                                onTap: () {
                                                                  setState(() {
                                                                    global.loadMessagesGroupId =
                                                                        catGroupsRepsonse[index]
                                                                            [
                                                                            'id'];
                                                                    global
                                                                        .loadMessagesGroupName = catGroupsRepsonse[
                                                                            index]
                                                                        [
                                                                        'name'];
                                                                  });
                                                                  Navigator.of(
                                                                          context)
                                                                      .pushNamed(
                                                                          GroupChat
                                                                              .routeName);
                                                                },
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            6),
                                                                horizontalTitleGap:
                                                                    14,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15)),
                                                                leading: catGroupsRepsonse[index]
                                                                            [
                                                                            'image'] ==
                                                                        null
                                                                    ? Icon(
                                                                        Icons
                                                                            .sports,
                                                                        size:
                                                                            35,
                                                                        color: Colors
                                                                            .blue,
                                                                      )
                                                                    : Container(
                                                                        child: Image.network(catGroupsRepsonse[index]
                                                                            [
                                                                            'image']),
                                                                        height:
                                                                            40,
                                                                        width:
                                                                            40,
                                                                      ),
                                                                title: Text(
                                                                  catGroupsRepsonse[
                                                                          index]
                                                                      ['name'],
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                                tileColor:
                                                                    Colors
                                                                        .white,
                                                                minVerticalPadding:
                                                                    6,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                    ]));
                          },
                          scrollDirection: Axis.horizontal,
                          physics: PageScrollPhysics(),
                        ),
                      ),
                      Positioned(
                          bottom: 15,
                          right: 20,
                          child: Container(
                              height: 65,
                              width: 65,
                              child: FloatingActionButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(AddGroups.routeName);
                                },
                                child: Icon(
                                  Icons.add,
                                  color: Colors.cyan[800],
                                  size: 40,
                                ),
                                elevation: 15,
                                backgroundColor: Colors.white,
                                isExtended: true,
                              )))
                    ]),
                    SizedBox(
                      height: 200,
                    )
                  ],
                ),
              ));
  }
}
