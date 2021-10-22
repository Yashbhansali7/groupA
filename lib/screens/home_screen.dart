import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:job_assessment/appbar.dart';
import 'package:job_assessment/instantMatch/imHome.dart';
import 'dart:convert';
import 'package:job_assessment/Global.dart' as global;
import 'package:http/http.dart' as http;
import '../widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String localMode = 'true';
  bool dataRecived = false;
  bool scrollable = false;
  var jsonResponse;
  var profileResponse;
  void initState() {
    getFeeds('true');
    _getUserProfile();
    super.initState();
  }

  int? count;
  getFeeds(String mode) async {
    final url = Uri.parse(
        'http://65.2.117.202:5000/api/v2/contents?isLocal=$mode&follow=false');
    var headers = {
      'x-access-token': global.token,
      'sourceFrom': '25',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      setState(() {
        jsonResponse = json.decode(res.body);
        // isDone = true;
        count = jsonResponse['contents'].length;
      });
      if (jsonResponse.toString().isNotEmpty) {
        setState(() {
          dataRecived = true;
        });
      } else {
        setState(() {
          dataRecived = false;
        });
      }
      print('Response Status: ${res.body.toString()}');
      var jsoned = jsonResponse["contents"][1];
      print(count);
      print(jsoned);
      print(jsoned['message']['body']);
      print(jsoned['message']['user']['name']);
      print(jsoned['message']['user']['userProfiles'][0]['image']);
    } else {
      
      jsonResponse = json.decode(res.body);
      print(res.reasonPhrase);
      print(jsonResponse['error'].toString());
    }
  }

  _getUserProfile() async {
    final url = Uri.parse('http://65.2.117.202:5000/api/v2/userprofile');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {'x-access-token': global.token, 'sourceFrom': '25'};
    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      setState(() {
        profileResponse = json.decode(res.body);
        global.currentUserUID = profileResponse['userprofile']['uuid'];
      });
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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: CustomAppbar(),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 90.0),
          child: dataRecived
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 190,
                            child: Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 145,
                                      alignment: Alignment.center,
                                      child: GoogleMap(
                                        initialCameraPosition: CameraPosition(
                                            target:
                                                LatLng(global.lat, global.long),
                                            zoom: 14),
                                        zoomControlsEnabled: false,
                                        myLocationButtonEnabled: true,
                                        myLocationEnabled: true,
                                      ),
                                    ),
                                    Container(
                                        height: 40,
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                                IMHome.modalRoute,
                                                arguments: {
                                                  'lat': global.lat,
                                                  'long': global.long
                                                });
                                          },
                                          child: Text(
                                            'Instant Connect',
                                            style: TextStyle(
                                                fontSize: 16,
                                                letterSpacing: .6,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.cyan[600]),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius
                                                                .circular(9),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    9)))),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ))
                                  ],
                                ),
                                margin: EdgeInsets.only(
                                  left: 25,
                                  right: 25,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 1.5,
                                    color: Colors.cyan,
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 40,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          localMode = 'true';
                                          getFeeds(localMode);
                                        });
                                      },
                                      child: Text(
                                        'Local Mode',
                                        style: TextStyle(
                                            color: localMode == 'true'
                                                ? Colors.cyan[700]
                                                : Colors.grey),
                                      )),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        localMode = 'false';
                                        getFeeds(localMode);
                                      });
                                    },
                                    child: Text(
                                      'Global Mode',
                                      style: TextStyle(
                                          color: localMode == 'true'
                                              ? Colors.grey
                                              : Colors.cyan[700]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 0),
                            child: GridView.builder(
                              physics: ScrollPhysics(),
                              padding: EdgeInsets.symmetric(vertical: 10),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: .9, crossAxisCount: 1),
                              itemCount: count,
                              itemBuilder: (context, index) {
                                return PostCard(index, jsonResponse);
                              },
                            )),
                      )
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }
}
