import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:job_assessment/signUp/SignUp_general.dart';
import 'package:http/http.dart' as http;

import 'package:job_assessment/Global.dart' as global;

class SignUpBasic extends StatefulWidget {
  static const routeName = '/signUpBasic';
  @override
  _SignUpBasicState createState() => _SignUpBasicState();
}

class _SignUpBasicState extends State<SignUpBasic> {
  late Future<FirebaseApp> _firebaseApp;
  final _form = GlobalKey<FormState>();
  bool emailMode = true;
  String dropdownValue = 'Choose Gender';
  TextEditingController phoneEmail = new TextEditingController();
  TextEditingController fName = new TextEditingController();
  TextEditingController lName = new TextEditingController();
  TextEditingController otpTF5 = new TextEditingController();
  TextEditingController otpTF6 = new TextEditingController();
  TextEditingController otpTF1 = new TextEditingController();
  TextEditingController otpTF2 = new TextEditingController();
  TextEditingController otpTF3 = new TextEditingController();
  TextEditingController otpTF4 = new TextEditingController();
  final otpFN1 = FocusNode();
  final otpFN2 = FocusNode();
  final otpFN3 = FocusNode();
  final otpFN4 = FocusNode();
  final otpFN5 = FocusNode();
  final otpFN6 = FocusNode();

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

  Container otpEmailContainer(TextEditingController controller,
      FocusNode focusNode, Function(String) onchanged) {
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

  String finalOTP = '';
  bool isLoggedIn = false;
  bool otpSent = false;
  String uid = '';
  var _verificationId;
  var token;
  Container otpContainer(TextEditingController controller, FocusNode focusNode,
      Function(String) onchanged) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
      width: 37,
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

  Container tfContainer(String labelText, TextInputType textInputType,
      TextEditingController controller, Widget prefix, int maxLength) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        maxLength: maxLength,
        controller: controller,
        keyboardType: textInputType,
        style: TextStyle(fontSize: 24),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            counterText: '',
            prefix: prefix,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: InputBorder.none,
            labelStyle: TextStyle(
                fontSize: 19, color: Colors.grey, fontWeight: FontWeight.w500)),
      ),
    );
  }

  void _verifyOTP(String smsCode) async {
    // we know that _verificationId is not empty
    final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: smsCode);
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (FirebaseAuth.instance.currentUser != null) {
        setState(() {
          isLoggedIn = true;
          uid = FirebaseAuth.instance.currentUser!.uid;
          FirebaseAuth.instance.currentUser!
              .getIdToken(true)
              .then((value) => token = value);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _sendOTP() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91' + phoneEmail.text,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    setState(() {
      otpSent = true;
    });
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    setState(() {
      _verificationId = verificationId;
      otpSent = true;
    });
  }

  void codeSent(String verificationId, int? a) {
    setState(() {
      _verificationId = verificationId;
      otpSent = true;
    });
  }

  void verificationFailed(FirebaseAuthException exception) {
    print(exception.message);
    setState(() {
      isLoggedIn = false;
      otpSent = false;
    });
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    await FirebaseAuth.instance.signInWithCredential(credential);
    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        isLoggedIn = true;
        uid = FirebaseAuth.instance.currentUser!.uid;
      });
    } else {
      print("Failed to Sign In");
    }
  }

  @override
  void initState() {
    super.initState();
    _firebaseApp = Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  var jsonResponse;
  sendEmailOTP(String email) async {
    final url = Uri.parse('http://65.2.117.202:5000/api/v2/verifyEmail');
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
        global.signUpOtp = jsonResponse['result']['otp'].toString();
        global.signUpEmail = email;
        otpSent = true;
      });
    } else {
      jsonResponse = json.decode(res.body);
      showValidationDialog(jsonResponse['error']);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: Colors.cyan[800],
            ),
          ),
        ),
      ),
      body: otpSent
          ? Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    Text(
                      'Verify OTP',
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    isLoggedIn
                        ? Icon(Icons.done)
                        : emailMode
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  otpEmailContainer(emailotpTF1, emailotpFN1,
                                      (_) {
                                    setState(() {
                                      emailotpText1 = emailotpTF1.text;
                                    });
                                    print(emailotpText1);
                                    if (emailotpText1.length == 1) {
                                      FocusScope.of(context)
                                          .requestFocus(emailotpFN2);
                                    }
                                  }),
                                  otpEmailContainer(emailotpTF2, emailotpFN2,
                                      (_) {
                                    setState(() {
                                      emailotpText2 = emailotpTF2.text;
                                    });
                                    print(emailotpText2);
                                    if (emailotpText2.length == 1) {
                                      FocusScope.of(context)
                                          .requestFocus(emailotpFN3);
                                    }
                                  }),
                                  otpEmailContainer(emailotpTF3, emailotpFN3,
                                      (_) {
                                    setState(() {
                                      emailotpText3 = emailotpTF3.text;
                                    });
                                    print(emailotpText3);
                                    if (emailotpText3.length == 1) {
                                      FocusScope.of(context)
                                          .requestFocus(emailotpFN4);
                                    }
                                  }),
                                  otpEmailContainer(emailotpTF4, emailotpFN4,
                                      (_) async {
                                    emailotpText4 = emailotpTF4.text;
                                    if (emailotpText3.length == 1) {
                                      FocusScope.of(context).unfocus();
                                    }
                                    emailfinalOTP = emailotpText1 +
                                        emailotpText2 +
                                        emailotpText3 +
                                        emailotpText4;
                                    if (emailfinalOTP.length == 4 &&
                                        emailfinalOTP == global.signUpOtp) {
                                      //  Navigator.of(context).pushNamed(ChangePassword.routeName);
                                      print('successful');
                                      setState(() {
                                        isLoggedIn = true;
                                      });
                                    } else {
                                      print('failed');
                                      print(emailfinalOTP);
                                      print(global.resetPasswordOTP);
                                    }
                                  }),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  otpContainer(otpTF1, otpFN1, (_) {
                                    FocusScope.of(context).requestFocus(otpFN2);
                                    finalOTP = finalOTP + otpTF1.text;
                                    print(finalOTP);
                                  }),
                                  otpContainer(otpTF2, otpFN2, (_) {
                                    FocusScope.of(context).requestFocus(otpFN3);
                                    finalOTP = finalOTP + otpTF2.text;
                                    print(finalOTP);
                                  }),
                                  otpContainer(otpTF3, otpFN3, (_) {
                                    FocusScope.of(context).requestFocus(otpFN4);
                                    finalOTP = finalOTP + otpTF3.text;
                                    print(finalOTP);
                                  }),
                                  otpContainer(otpTF4, otpFN4, (_) {
                                    FocusScope.of(context).requestFocus(otpFN5);
                                    finalOTP = finalOTP + otpTF4.text;
                                    print(finalOTP);
                                  }),
                                  otpContainer(otpTF5, otpFN5, (_) {
                                    FocusScope.of(context).requestFocus(otpFN6);
                                    finalOTP = finalOTP + otpTF5.text;
                                    print(finalOTP);
                                  }),
                                  otpContainer(otpTF6, otpFN6, (_) async {
                                    FocusScope.of(context).unfocus();
                                    finalOTP = finalOTP + otpTF6.text;
                                    print(finalOTP);
                                    if (finalOTP.length == 6) {
                                      _verifyOTP(finalOTP);
                                    }
                                  }),
                                ],
                              ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        isLoggedIn
                            ? 'Phone Number/Email is verified'
                            : 'An OTP has been sent to your Email/Number',
                        style: TextStyle(color: Colors.grey),
                      ),
                      style: ButtonStyle(alignment: Alignment.center),
                    ),
                    Text(
                      'Choose Password',
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    tfPassContainer(
                        'Create new Password',
                        passTF,
                        passNode,
                        (_) {
                          if (passTF.text.isEmpty) {
                            showValidationDialog('Password cannot be empty');
                          } else if (passTF.text.length < 6) {
                            showValidationDialog(
                                'Password must have 6 characters');
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
                  ],
                ),
              ),
            )
          : Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    Text(
                      'Email / Phone Number',
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    tfContainer(
                        emailMode
                            ? 'Enter your Email'
                            : 'Enter your Phone Number',
                        emailMode
                            ? TextInputType.emailAddress
                            : TextInputType.number,
                        phoneEmail,
                        emailMode ? Text('') : Text('+91'),
                        emailMode ? 40 : 10),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          emailMode = !emailMode;
                        });
                      },
                      child: Text(
                        emailMode
                            ? 'Use Phone Number Instead'
                            : 'Use Email Address',
                        style: TextStyle(fontSize: 17),
                      ),
                      style: ButtonStyle(
                          alignment: Alignment.centerRight,
                          splashFactory: NoSplash.splashFactory),
                    ),
                    Text(
                      'Your Name',
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    tfContainer(
                        'First Name', TextInputType.name, fName, Text(''), 20),
                    SizedBox(
                      height: 10,
                    ),
                    tfContainer(
                        'Last Name', TextInputType.name, lName, Text(''), 20),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Your Gender',
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: dropdownValue,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 20),
                          dropdownColor: Colors.white,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                              print(dropdownValue);
                            });
                          },
                          items: <String>[
                            'Choose Gender',
                            'Men',
                            'Women',
                            'Other'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.teal,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: isLoggedIn
          ? FloatingActionButton(
              child: Icon(Icons.arrow_forward),
              onPressed: () {
                if (passTF.text.isEmpty) {
                  showValidationDialog('Password cannot be empty');
                } else if (passTF.text.length < 6) {
                  showValidationDialog('Password must have 6 characters');
                } else if (passTF.text != rePassTF.text) {
                  showValidationDialog('Passwords do not match');
                } else {
                  setState(() {
                    global.signUpPass = passTF.text;
                    if (!emailMode) {
                      global.signUpOtp = finalOTP;
                    }
                  });
                  print(passTF.text);

                  Navigator.of(context).pushReplacementNamed(
                    SignUpGeneral.routeName,
                  );
                }
              })
          : FloatingActionButton(
              child: Icon(Icons.dynamic_form_outlined),
              onPressed: () {
                if (phoneEmail.text.length < 10 && !emailMode) {
                  showValidationDialog('Please enter valid phone number');
                } else if (phoneEmail.text.length < 30 &&
                    emailMode &&
                    !phoneEmail.text.endsWith('.com')) {
                  showValidationDialog('Please enter valid email address');
                } else if (fName.text.length < 3) {
                  showValidationDialog(
                      'First name can\'t be less than 3 characters');
                } else if (lName.text.length < 3) {
                  showValidationDialog(
                      'Last name can\'t be less than 3 characters');
                } else if (dropdownValue == 'Choose Gender') {
                  showValidationDialog('Please pick a gender');
                } else {
                  setState(() {
                    global.signUpEmail = phoneEmail.text;
                    global.signUpFName = fName.text;
                    global.signUpLName = lName.text;
                    global.signUpGender = dropdownValue;
                  });
                  emailMode ? sendEmailOTP(phoneEmail.text) : _sendOTP();
                }
              }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
