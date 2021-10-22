import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_assessment/Global.dart' as global;
import 'package:job_assessment/screens/login_screen.dart';

class ChangePassword extends StatefulWidget {
  static const routeName = '/changePassword';
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController passTF = new TextEditingController();
  TextEditingController rePassTF = new TextEditingController();
  FocusNode passNode = new FocusNode();
  FocusNode repassNode = new FocusNode();
  bool passVisible = true;
  bool repassVisible = true;
  Container tfPassContainer(
      String labelText,
      TextEditingController controller,
      FocusNode focusNode,
      Function(String) onSubmit,
      bool visible,
      Function() onpressed) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10, bottom: 3),
      padding: EdgeInsets.only(bottom: 3),
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black26)],
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)),
      child: TextFormField(
        onFieldSubmitted: onSubmit,
        controller: controller,
        obscureText: visible,
        keyboardType: TextInputType.visiblePassword,
        style: TextStyle(fontSize: 24),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            suffixIcon: IconButton(
              splashRadius: 1,
              icon: Icon(visible ? Icons.remove_red_eye : Icons.remove_red_eye),
              onPressed: onpressed,
              color: visible ? Colors.grey : Colors.teal,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: InputBorder.none,
            labelStyle: TextStyle(
                fontSize: 19, color: Colors.grey, fontWeight: FontWeight.w400)),
      ),
    );
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
              height: text.length > 25 ? 140 : 110,
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
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
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

  var jsonResponse;
  changePass(String password) async {
    final url = Uri.parse('http://65.2.117.202:5000/api/v2/forgotPassword');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {
      'sourceFrom': '25',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    Map body = {
      'phoneNumber': global.resetEmail,
      'otp': global.resetPasswordOTP,
      'password': password
    };
    var res = await http.post(url, body: body, headers: headers);
    if (res.statusCode == 200) {
      jsonResponse = json.decode(res.body);
      print(jsonResponse);
      showDialog(
          barrierColor: Colors.black26,
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)), //this right here
              child: Container(
                height: jsonResponse['message'].length > 25 ? 140 : 110,
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
                        jsonResponse['message'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(LoginPage.routeName);
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
    } else {
      jsonResponse = json.decode(res.body);
      showValidationDialog(jsonResponse.toString());
    }
  }

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
      body: Padding(
        padding: const EdgeInsets.only(
            left: 40.0, right: 40.0, top: 40.0, bottom: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            tfPassContainer(
                'Create new Password',
                passTF,
                passNode,
                (_) {
                  if (passTF.text.isEmpty) {
                    showValidationDialog('Password cannot be empty');
                  } else if (passTF.text.length < 6) {
                    showValidationDialog('Password must have 6 characters');
                  } else {
                    FocusScope.of(context).requestFocus(repassNode);
                  }
                },
                passVisible,
                () {
                  setState(() {
                    passVisible = !passVisible;
                  });
                }),
            tfPassContainer(
                'Re-Enter Password',
                rePassTF,
                repassNode,
                (_) {
                  FocusScope.of(context).unfocus();
                },
                repassVisible,
                () {
                  setState(() {
                    repassVisible = !repassVisible;
                  });
                }),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.cyan[900]),
                child: ElevatedButton(
                  onPressed: () {
                    if (passTF.text.isEmpty) {
                      showValidationDialog('Password cannot be empty');
                    } else if (passTF.text.length < 6) {
                      showValidationDialog('Password must have 6 characters');
                    } else if (passTF.text != rePassTF.text) {
                      showValidationDialog('Passwords do not match');
                    } else {
                      changePass(passTF.text);
                      
                      print(passTF.text);
                    }
                  },
                  child: Text(
                    'Change Password',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
