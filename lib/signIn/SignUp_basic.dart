import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:job_assessment/signIn/SignUp_general.dart';


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
  TextEditingController otpTF1 = new TextEditingController();
  TextEditingController otpTF2 = new TextEditingController();
  TextEditingController otpTF3 = new TextEditingController();
  TextEditingController otpTF4 = new TextEditingController();
  TextEditingController otpTF5 = new TextEditingController();
  TextEditingController otpTF6 = new TextEditingController();
  final otpFN1 = FocusNode();
  final otpFN2 = FocusNode();
  final otpFN3 = FocusNode();
  final otpFN4 = FocusNode();
  final otpFN5 = FocusNode();
  final otpFN6 = FocusNode();
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

  Container tfPassContainer(
    String labelText,
  ) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        style: TextStyle(fontSize: 24),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: InputBorder.none,
            labelStyle: TextStyle(
                fontSize: 19, color: Colors.grey, fontWeight: FontWeight.w500)),
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
                        'An OTP has been sent to your Email/Number',
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
                    tfPassContainer('Enter Password'),
                    tfPassContainer('Confirm Password'),
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
      floatingActionButton:
       isLoggedIn?
           FloatingActionButton(
              child: Icon(Icons.arrow_forward),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                    SignUpGeneral.routeName,
                    arguments: token);
              })
          : FloatingActionButton(
              child: Icon(Icons.dynamic_form_outlined),
              onPressed: () {
                _sendOTP();
              }),
      // }):FloatingActionButton(
      //   onPressed: () async {
      // if (phoneEmail.text.length < 10) {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text('Please enter valid email/password'),
      //     backgroundColor: Colors.red,
      //     duration: Duration(seconds: 3),
      //   ));
      // } else if (fName.text.length < 3) {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text('First name can\'t be less than 3 characters'),
      //     backgroundColor: Colors.red,
      //     duration: Duration(seconds: 3),
      //   ));
      // } else if (lName.text.length < 3) {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text('Last name can\'t be less than 3 characters'),
      //     backgroundColor: Colors.red,
      //     duration: Duration(seconds: 3),
      //   ));
      // } else if (dropdownValue == 'Choose Gender') {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text('Please pick a gender'),
      //     backgroundColor: Colors.red,
      //     duration: Duration(seconds: 3),
      //   ));
      // } else {
      //   _sendOTP();
      //   final conn = PostgreSQLConnection('10.0.2.2', 5432, 'groupalike',
      //       username: 'postgres', password: '9624');
      //   await conn.open();
      //   await conn.query(
      //       "INSERT INTO maintable(firstname,lastname,phone_email,gender) VALUES ('${fName.text}','${lName.text}','${phoneEmail.text}','$dropdownValue')");
      //}

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
