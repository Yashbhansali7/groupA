import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:job_assessment/screens/tabs_screen.dart';
import 'package:job_assessment/Global.dart' as global;

class SignUpDP extends StatefulWidget {
  static const routeName = '/signUpDP';

  _SignUpDPState createState() => _SignUpDPState();
}

class _SignUpDPState extends State<SignUpDP> {
  File? _profileImg = null;

  void _pickImg(ImageSource imageSource) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: imageSource,
    );
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _profileImg = pickedImageFile;
    });
  }

  var jsonResponse;
  var token;
  register() async {
    final url = Uri.parse('http://65.2.117.202:5000/api/v2/register');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {
      'sourceFrom': '25',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    Map body = {
      'email': global.signUpEmail,
      'firstName': global.signUpFName,
      'lastName': global.signUpLName,
      'otp': global.signUpOtp,
      'dob': global.signUpDob,
      'gender': global.signUpGender,
      'city': global.signUpCity,
      'interest': global.signUpInterest.toString(),
      'password': global.signUpPass
    };
    var res = await http.post(url, body: body, headers: headers);

    if (res.statusCode == 200) {
      jsonResponse = json.decode(res.body);
      print('Response Status: ${res.body.toString()}');
      token = jsonResponse["token"];
      global.token = jsonResponse["token"];
      token.toString().isNotEmpty
          ? Navigator.of(context).popAndPushNamed(
              TabsScreen.routeName,
            )
          : null;
    } else {
      jsonResponse = json.decode(res.body);
      print(res.reasonPhrase);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 45, bottom: 60.0, right: 20),
            child: GestureDetector(
              onTap: () {
                register();
                //  Navigator.of(context).popAndPushNamed(TabsScreen.routeName);
              },
              child: Text('Skip',
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 20,
                      fontWeight: FontWeight.w500)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0)), //this right here
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      'Add photo',
                                      style: TextStyle(
                                          color: Colors.cyan[800],
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        _pickImg(ImageSource.camera);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        '  Take photo',
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400),
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        _pickImg(ImageSource.gallery);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        '  Choose from gallery',
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80)),
                  child: CircleAvatar(
                    backgroundImage:
                        _profileImg == null ? null : FileImage(_profileImg!),
                    backgroundColor: Colors.white,
                    radius: 80,
                    child: _profileImg == null
                        ? Icon(
                            Icons.add_a_photo,
                            size: 50,
                          )
                        : null,
                  ),
                ),
              )),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Text('Add a profile picture',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w300)),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Text(
                  'Or you can do this later in profile settings',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.w300),
                ),
              ),
              SizedBox(
                height: 80,
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.teal[300]!,
                Colors.cyan[800]!,
                Colors.cyan[800]!,
              ],
            ),
          ),
          child: ElevatedButton(
            onPressed: () => register(),
            child: Text(
              'Take Me In',
              style: TextStyle(fontSize: 18),
            ),
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              shadowColor: MaterialStateProperty.all(Colors.black12),
            ),
          ),
        ),
      ),
    );
  }
}
