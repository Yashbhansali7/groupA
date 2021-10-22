import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_assessment/Global.dart' as global;
import 'package:flutter/material.dart';
import 'package:job_assessment/forgorPass/changePassword.dart';

class ForgotPasswordOTP extends StatefulWidget {
  static const routeName = '/forgetPasswordOTP';
  @override
  _ForgotPasswordOTPState createState() => _ForgotPasswordOTPState();
}

class _ForgotPasswordOTPState extends State<ForgotPasswordOTP> {
  int secondsRemaining = 30;
  bool enableResend = false;
  Timer? timer;

  @override
  initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  void _resendCode() {
    setState(() {
      secondsRemaining = 30;
      enableResend = false;
      resendOTP();
    });
  }

  @override
  dispose() {
    timer!.cancel();
    super.dispose();
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

  TextEditingController emailotpTF1 = new TextEditingController();
  TextEditingController emailotpTF2 = new TextEditingController();
  TextEditingController emailotpTF3 = new TextEditingController();
  TextEditingController emailotpTF4 = new TextEditingController();
  final emailotpFN1 = FocusNode();
  final emailotpFN2 = FocusNode();
  final emailotpFN3 = FocusNode();
  final emailotpFN4 = FocusNode();
  String emailotpText1 = '';
  String emailotpText2 = '';
  String emailotpText3 = '';
  String emailotpText4 = '';
  String emailfinalOTP = '';
  
  Container otpEmailContainer(TextEditingController controller, FocusNode focusNode,
      Function(String) onchanged) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
      width: 40,
      child: TextFormField(
        maxLength: 1,
        controller: controller,
        cursorColor: Colors.black,
        focusNode: focusNode,
        onChanged: onchanged,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            border: InputBorder.none,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            counterText: ''),
      ),
    );
  }

  bool emailMode = true;
  var jsonResponse;
  resendOTP() async {
    final url = Uri.parse('http://65.2.117.202:5000/api/v2/forgotPasswordOTP');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {
      'sourceFrom': '25',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    Map body = {'email': global.resetEmail};
    var res = await http.post(url, body: body, headers: headers);
    if (res.statusCode == 200) {
      jsonResponse = json.decode(res.body);
      print(jsonResponse);
      setState(() {
      global.resetPasswordOTP = jsonResponse['otp'].toString();        
      });
    } else {
      jsonResponse = json.decode(res.body);
      
    }
  }

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
          padding: EdgeInsets.only(bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 50, bottom: 20),
                alignment: Alignment.center,
                width: double.infinity,
                child: Text(
                  'Verification',
                  style: TextStyle(color: Colors.teal[800], fontSize: 22),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20, left: 80, right: 80),
                alignment: Alignment.center,
                width: double.infinity,
                child: Text(
                  'We just sent you an E-mail \n with \n 4-digit code.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700], fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    otpEmailContainer(emailotpTF1, emailotpFN1, (_) {
                      setState(() {
                        emailotpText1 = emailotpTF1.text;
                      });
                      print(emailotpText1);
                      if (emailotpText1.length == 1) {
                        FocusScope.of(context).requestFocus(emailotpFN2);
                      }
                    }),
                    otpEmailContainer(emailotpTF2, emailotpFN2, (_) {
                      setState(() {
                        emailotpText2 = emailotpTF2.text;
                      });
                      print(emailotpText2);
                      if (emailotpText2.length == 1) {
                        FocusScope.of(context).requestFocus(emailotpFN3);
                      }
                    }),
                    otpEmailContainer(emailotpTF3, emailotpFN3, (_) {
                      setState(() {
                        emailotpText3 = emailotpTF3.text;
                      });
                      print(emailotpText3);
                      if (emailotpText3.length == 1) {
                        FocusScope.of(context).requestFocus(emailotpFN4);
                      }
                    }),
                    otpEmailContainer(emailotpTF4, emailotpFN4, (_) async {
                      emailotpText4 = emailotpTF4.text;
                      if (emailotpText3.length == 1) {
                        FocusScope.of(context).unfocus();
                      }
                      emailfinalOTP = emailotpText1 + emailotpText2 + emailotpText3 + emailotpText4;
                      print(emailfinalOTP);
                    }),
                  ],
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
                      if (emailfinalOTP.length == 4 && emailfinalOTP == global.resetPasswordOTP) {
                        Navigator.of(context).pushNamed(ChangePassword.routeName);
                        print('successful');
                        
                      } else {
                        print('failed');
                        print(emailfinalOTP);
                        print(global.resetPasswordOTP);
                      }
                    },
                    child: Text(
                      'Verify',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: ButtonStyle(
                          alignment: Alignment.topCenter,
                          padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.teal[800])),
                      onPressed: () => enableResend ? _resendCode() : null,
                      child: Text(
                        enableResend
                            ? 'Resend OTP'
                            : 'Resend OTP in 00:$secondsRemaining secs',
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
