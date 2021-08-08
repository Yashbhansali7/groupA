import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:job_assessment/instantMatch/imHome.dart';
import 'package:job_assessment/Global.dart' as global;
import 'package:http/http.dart' as http;

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
        count = jsonResponse[count].toInt();
      });
      print('Response Status: ${res.body.toString()}');
      print(jsonResponse['users'][1]['referCode']);
    } else {
      setState(() {
      isFailed = true;        
      });
      jsonResponse = json.decode(res.body);
      print(res.reasonPhrase);
      print(jsonResponse['error'].toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var body = ModalRoute.of(context)!.settings.arguments;
    isDone == true || isFailed == true?null
        : Future.delayed(Duration(seconds: 2), () {
            getGroupsIM(body.toString());
          })
        ;
    return Scaffold(
      backgroundColor: Colors.white,
      body: isDone
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  Container(
                      margin: EdgeInsets.only(top: 30),
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: Text(
                        'Congratulations!',
                        style: TextStyle(
                            color: Colors.cyan[700],
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      )),
                  CircleAvatar(
                    radius: 120,
                    child: Image.asset('asset/groupalike.jpg'),
                  ),
                  Text(
                    '''You have been grouped alike
  with $count members.''',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.cyan, width: 2),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.cyan[700]),
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(IMHome.modalRoute);
                      },
                      child: Text(
                        'Review Group',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  )
                ])
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getGroupsIM(body.toString());
          print(body);
          //showDialogBox();
        },
        child: Text('hey'),
      ),
    );
  }
}
