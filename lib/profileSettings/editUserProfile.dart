import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:job_assessment/Global.dart' as global;
import 'package:job_assessment/profileSettings/customizeUserProfile.dart';

class EditUserProfile extends StatefulWidget {
  static const routeName = '/editUserProfile';

  @override
  _EditUserProfileState createState() => _EditUserProfileState();
}

Container subHeadingText(String data) {
  return Container(
    //   width: double.infinity,
    alignment: Alignment.centerLeft,
    child: Text(data,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.w400,
          //letterSpacing: .7),
        )),
  );
}

class _EditUserProfileState extends State<EditUserProfile> {
  initState() {
    _getUserProfile();
    super.initState();
  }

  
  var dob;
  var jsonResponse;
  _getUserProfile() async {
    final url = Uri.parse('http://65.2.117.202:5000/api/v2/userprofile');
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

  bool hideProfileBool = true;
  bool discoveryBool = true;
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
        elevation: 0,
        titleSpacing: 3,
        title: Text(
          'Profile Settings',
          style: TextStyle(
              fontSize: 22, color: Colors.black, fontWeight: FontWeight.w300),
        ),
      ),
      body: jsonResponse == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      subHeadingText('Your Name'),
                      IconButton(
                          onPressed: () {},
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.edit_outlined))
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 150,
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                                labelStyle:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                contentPadding: EdgeInsets.all(0),
                                labelText: jsonResponse['userprofile']['name']),
                          ),
                        ),
                        Container(
                          width: 150,
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              labelText: jsonResponse['userprofile']
                                  ['lastName'],
                              labelStyle:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                            ),
                          ),
                        )
                      ]),
                  SizedBox(
                    height: 20,
                  ),
                  subHeadingText('User ID'),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          labelText: jsonResponse['userprofile']['referCode'],
                          labelStyle:
                              TextStyle(color: Colors.grey, fontSize: 20),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.edit_outlined))),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(CustomizeUserProfile.routeName);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Profile Customize',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.cyan[700],
                              fontWeight: FontWeight.w400,
                              //letterSpacing: .7),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.cyan[700],
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 24,
                                color: Colors.white,
                              )),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      subHeadingText('Hide Profile'),
                      Switch(
                        value: hideProfileBool,
                        onChanged: (value) {
                          setState(() {
                            hideProfileBool = value;
                            print(hideProfileBool);
                          });
                        },
                        activeTrackColor: Colors.grey[300],
                        activeColor: Colors.cyan[600],
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      subHeadingText('Discovery'),
                      Switch(
                        value: discoveryBool,
                        onChanged: (value) {
                          setState(() {
                            discoveryBool = value;
                            print(discoveryBool);
                          });
                        },
                        activeTrackColor: Colors.grey[300],
                        activeColor: Colors.cyan[600],
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      subHeadingText(
                          jsonResponse['userprofile']['phoneNumber'] == null
                              ? 'Add Phone Number'
                              : 'Phone Number'),
                      Container(
                        margin: EdgeInsets.only(left: 100, bottom: 15, top: 5),
                        width: double.infinity,
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              labelText: jsonResponse['userprofile']
                                          ['phoneNumber'] ==
                                      null
                                  ? 'Enter Here'
                                  : jsonResponse['userprofile']['phoneNumber'],
                              labelStyle:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: Icon(jsonResponse['userprofile']
                                              ['phoneNumber'] ==
                                          null
                                      ? Icons.done
                                      : Icons.edit_outlined))),
                        ),
                      ),
                      Text(
                        '+80 Points on adding Phone number',
                        style: TextStyle(color: Colors.cyan[700]),
                      )
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 50, bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey),
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey[200]),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.black)),
                          onPressed: () {},
                          child: Text(
                            'Log Out',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                letterSpacing: .6),
                          )))
                ],
              ),
            ),
    );
  }
}
