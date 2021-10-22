import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_assessment/Global.dart' as global;

class MemberProfileScreen extends StatefulWidget {
  static const routeName = '/memberprofile';
  @override
  _MemberProfileScreenState createState() => _MemberProfileScreenState();
}

class _MemberProfileScreenState extends State<MemberProfileScreen> {
  initState() {
    _getUserProfile(global.getMemberuid);
    super.initState();
  }

  var dob;
  var jsonResponse;
  _getUserProfile(String uid) async {
    final url = Uri.parse('http://65.2.117.202:5000/api/v2/profile?uuid=$uid');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {'x-access-token': global.token, 'sourceFrom': '25'};
    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      print('hello');
      setState(() {
        jsonResponse = json.decode(res.body);
      });
      print('Response Status: ${res.body.toString()}');
      print(jsonResponse);
      dob = jsonResponse['userprofile']['userProfiles'][0]['dob'];
      setState(() {
        dob = DateFormat.yMMMMd().format(DateTime.parse(dob.substring(0, 10)));
      });
    } else {
      print(res.reasonPhrase);
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
          enableFeedback: false,
          splashFactory: NoSplash.splashFactory,
          onTap: Navigator.of(context).pop,
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.teal,
            size: 30,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.share,
                color: Colors.teal,
                size: 30,
              )),
        ],
      ),
      body: jsonResponse == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          color: Colors.grey[200],
                          child: jsonResponse['userprofile']['userProfiles'][0]
                                      ['image'] ==
                                  null
                              ? Icon(Icons.person, size: 100)
                              : Image.network(jsonResponse['userprofile']
                                  ['userProfiles'][0]['image']),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              jsonResponse['userprofile']['name'],
                              style: TextStyle(
                                  color: Colors.cyan[700],
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              jsonResponse['userprofile']['referCode'],
                              style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton.icon(
                                  style: ButtonStyle(
                                      alignment: Alignment.topCenter,
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.all(0))),
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.star_border_outlined,
                                    size: 30,
                                    color: Colors.cyan[600],
                                  ),
                                  label: Text(
                                      jsonResponse['userprofile']['starCount'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.cyan[600],
                                      )),
                                ),
                                TextButton.icon(
                                  style: ButtonStyle(
                                      alignment: Alignment.topCenter,
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.all(0))),
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.cyan[600],
                                  ),
                                  label: Text(
                                    '18',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.cyan[600],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Joined $dob',
                              style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                jsonResponse['userprofile']['footprints']
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                jsonResponse['userprofile']['starCount'],
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                jsonResponse['userprofile']['userReviews']
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    SizedBox(
                      height: 20,
                    ),
                    Text('Tagged',
                        style: TextStyle(color: Colors.black, fontSize: 22)),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Footprints',
                        style: TextStyle(color: Colors.black, fontSize: 22)),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        itemCount:
                            jsonResponse['userprofile']['footprints'].length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 5),
                            child: Column(
                              children: [
                                Container(
                                  height: 40,
                                  width: 60,
                                  color: Colors.blueAccent,
                                  child: Image.network(
                                      jsonResponse['userprofile']['footprints']
                                          [index]['image']),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  jsonResponse['userprofile']['footprints']
                                      [index]['country'],
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey[600]),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Text('Reviews',
                        style: TextStyle(color: Colors.black, fontSize: 22)),
                  ],
                ),
              ),
            ),
    );
  }
}
