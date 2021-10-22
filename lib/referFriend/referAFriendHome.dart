import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_assessment/Global.dart' as global;
import 'package:flutter/material.dart';
import 'package:job_assessment/referFriend/referAFriend_screen.dart';

class ReferAFriendHome extends StatefulWidget {
  static const routeName = '/referAFriendHome';
  @override
  _ReferAFriendHomeState createState() => _ReferAFriendHomeState();
}

class _ReferAFriendHomeState extends State<ReferAFriendHome> {
  initState() {
    _getUserProfile();
    super.initState();
  }

  showReferDialog() {
    showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)), //this right here
            child: Container(
              height: 350,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 3, left: 7),
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.close,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
                    ),
                    Text(
                      'Share your refer code',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your refer code',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w300),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                jsonResponse['userprofile']['referCode'],
                                style: TextStyle(
                                    color: Colors.cyan[700],
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      padding: EdgeInsets.all(0),
                                      iconSize: 30,
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.copy,
                                        color: Colors.cyan[700],
                                      )),
                                  IconButton(
                                      padding: EdgeInsets.all(0),
                                      iconSize: 30,
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.share,
                                        color: Colors.cyan[700],
                                      ))
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey[400],
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12)),
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        style: TextStyle(fontSize: 24),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 15),
                            labelText: 'Send Invite by email',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: InputBorder.none,
                            labelStyle: TextStyle(
                                fontSize: 19,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                    Text(
                      '+50 point when they join',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                    ),
                    Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        // margin: EdgeInsets.only(top: 50, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey),
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.cyan[700]),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context)
                                  .pushNamed(ReferAFriendContact.routeName);
                            },
                            child: Text(
                              'Select from Contacts',
                              style: TextStyle(
                                  //fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  letterSpacing: .6),
                            ))),
                  ],
                ),
              ),
            ),
          );
        });
  }

  String joinedMode = 'joined';
  var jsonResponse;
  _getUserProfile() async {
    final url = Uri.parse('http://65.2.117.202:5000/api/v2/userprofile');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {'x-access-token': global.token, 'sourceFrom': '25'};
    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      setState(() {
        jsonResponse = json.decode(res.body);
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
        titleSpacing: 3,
        title: Text(
          'Refer A Friend',
          style: TextStyle(
              fontSize: 22, color: Colors.black, fontWeight: FontWeight.w300),
        ),
      ),
      body: jsonResponse == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(1),
                child: Column(
                  children: [
                    joinedMode == 'joined'
                        ? Center(
                            child: Container(
                                height: 250,
                                width: double.infinity,
                                child: Image.asset('asset/Group6173.png')))
                        : Container(),
                    joinedMode == 'joined'
                        ? Center(
                            child: Container(
                              child: Text(
                                jsonResponse['userprofile']['referCode'],
                                style: TextStyle(
                                    color: Colors.cyan[700],
                                    fontSize: 27,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          )
                        : Container(),
                    joinedMode == 'joined'
                        ? Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              child: Text(
                                'Share your refer code with your friends and earn bonus points.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          )
                        : Container(),
                    Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        // margin: EdgeInsets.only(top: 50, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey),
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.cyan[700]),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                            onPressed: () {
                              showReferDialog();
                            },
                            child: Text(
                              'Refer',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  letterSpacing: .6),
                            ))),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              joinedMode = 'joined';
                            });
                          },
                          child: Text(
                            'Joined',
                            style: TextStyle(
                                fontSize: 18,
                                color: joinedMode == 'joined'
                                    ? Colors.cyan[700]
                                    : Colors.grey),
                          )),
                      Text(
                        '  |  ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            joinedMode = 'notYet';
                          });
                        },
                        child: Text(
                          'Not yet',
                          style: TextStyle(
                              fontSize: 18,
                              color: joinedMode == 'joined'
                                  ? Colors.grey
                                  : Colors.cyan[700]),
                        ),
                      ),
                    ]),
                    joinedMode == 'joined'
                        ? SizedBox(
                            height: 480,
                            child: global.referredAndJoined.isNotEmpty
                                ? ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading: Container(
                                          height: 50,
                                          width: 50,
                                          color: Colors.green,
                                        ),
                                        title: Text(
                                          'Ranjeet',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset('asset/Group5471.png'),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 15),
                                        child: Text(
                                          'Groupalike helps people connect with other like-minded people.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 5),
                                        child: Text(
                                          'Refer Groupalike to your friends & when they join you and them both, get points!',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )
                                    ],
                                  ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            child: global.referredContacts.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('asset/Refer_empty.png'),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 15),
                                        child: Text(
                                          'Groupalike helps people connect with other like-minded people.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 5),
                                        child: Text(
                                          'Refer Groupalike to your friends & when they join you and them both, get points!',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )
                                    ],
                                  )
                                : Container()),
                  ],
                ),
              ),
            ),
    );
  }
}
