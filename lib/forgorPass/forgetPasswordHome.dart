import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_assessment/Global.dart' as global;
import 'package:job_assessment/forgorPass/forgotPasswordOTP.dart';

class ForgetPasswordHome extends StatefulWidget {
  static const routeName = '/forgetPasswordHome';
  @override
  _ForgetPasswordHomeState createState() => _ForgetPasswordHomeState();
}

class _ForgetPasswordHomeState extends State<ForgetPasswordHome> {
  var jsonResponse;
  Container tfContainer(String labelText, TextInputType textInputType,
      TextEditingController controller, Widget prefix, int maxLength) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        maxLength: maxLength,
        controller: controller,
        keyboardType: textInputType,
        style: TextStyle(fontSize: 22),
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            counterText: '',
            prefix: prefix,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: InputBorder.none,
            labelStyle: TextStyle(
                fontSize: 19, color: Colors.grey, fontWeight: FontWeight.w400)),
      ),
    );
  }

  sendOTP(String email) async {
    final url = Uri.parse('http://65.2.117.202:5000/api/v2/forgotPasswordOTP');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {
      'sourceFrom': '25',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    Map body = {'email': email};
    var res = await http.post(url, body: body, headers: headers);

    if (res.statusCode == 200) {
      jsonResponse = json.decode(res.body);
      // print('Response Status: ${res.statusCode}');
      print('Response Status: ${res.body.toString()}');
      setState(() {
        global.resetPasswordOTP = jsonResponse['otp'].toString();
        global.resetEmail = email;
      });
      Navigator.of(context).pushNamed(ForgotPasswordOTP.routeName);
    } else {
      jsonResponse = json.decode(res.body);
      showValidationDialog('Enter valid Email address');
      _userEmail.text = '';
    }
  }

  showValidationDialog(String text) {
    showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)), //this right here
            child: Container(
              height: 120,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      text,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'OK',
                          style: TextStyle(
                              color: Colors.cyan[700],
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        ))
                  ],
                ),
              ),
            ),
          );
        });
  }

  TextEditingController _userEmail = TextEditingController();
  bool emailMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: Navigator.of(context).pop,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.close,
              color: Colors.grey,
              size: 30,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 50, bottom: 20),
                alignment: Alignment.center,
                width: double.infinity,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.teal[800], fontSize: 22),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 40, left: 40, right: 40),
                alignment: Alignment.center,
                width: double.infinity,
                child: Text(
                  'Don\'t worry! Just enter your email address below ',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700], fontSize: 18),
                ),
              ),
              tfContainer(
                  emailMode ? 'Enter Your Email' : 'Enter Your Phone Number',
                  emailMode ? TextInputType.emailAddress : TextInputType.number,
                  _userEmail,
                  emailMode ? Text('') : Text('+91'),
                  emailMode ? 40 : 10),
              Container(
                margin: EdgeInsets.only(right: 24),
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      emailMode = !emailMode;
                    });
                  },
                  child: Text(
                    emailMode ? 'Phone Number' : 'Email',
                    style: TextStyle(fontSize: 17),
                  ),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 20)),
                      foregroundColor:
                          MaterialStateProperty.all(Colors.cyan[900]),
                      alignment: Alignment.centerRight,
                      splashFactory: NoSplash.splashFactory),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.cyan[900]),
                  child: ElevatedButton(
                    onPressed: () {
                      String email = _userEmail.text.toString();
                      if (email.length == 0) {
                        showValidationDialog('Email cannot be empty');
                      } else if (!email.endsWith('.com')) {
                        showValidationDialog('Enter a valid Email');
                      } else {
                        sendOTP(email);
                      }
                      FocusScope.of(context).unfocus();
                    },
                    child: Text(
                      'Reset',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      // elevation: MaterialStateProperty.all(3),
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
