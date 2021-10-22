import 'package:flutter/cupertino.dart';
import 'package:job_assessment/Global.dart' as global;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:job_assessment/api/google_signin.dart';
import 'package:job_assessment/forgorPass/forgetPasswordHome.dart';
import 'package:job_assessment/screens/tabs_screen.dart';
import 'package:job_assessment/signUp/SignUp_basic.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/loginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _userEmail = TextEditingController();

  TextEditingController _userPass = TextEditingController();

  var jsonResponse;

  var token;
  Container tfPassContainer(String labelText) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        controller: _userPass,
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        style: TextStyle(fontSize: 22),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: InputBorder.none,
            labelStyle: TextStyle(
                fontSize: 19, color: Colors.grey, fontWeight: FontWeight.w400)),
      ),
    );
  }

  Container tfContainer(String labelText, TextInputType textInputType,
      TextEditingController controller, Widget prefix, int maxLength) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        maxLength: maxLength,
        controller: controller,
        keyboardType: textInputType,
        style: TextStyle(fontSize: 22),
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

  login(String email, String pswd, BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Please wait..  Logging You In'),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
    final url =
        Uri.parse('https://airmatch-development.herokuapp.com/api/v2/login');
    var headers = {
      'sourceFrom': '25',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    Map body = {'email': email, 'password': pswd};
    var res = await http.post(url, body: body, headers: headers);

    if (res.statusCode == 200) {
      jsonResponse = json.decode(res.body);
      // print('Response Status: ${res.statusCode}');
      print('Response Status: ${res.body.toString()}');
      print(jsonResponse["token"]);
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(jsonResponse["error"].toString()),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ));
      _userEmail.text = '';
      _userPass.text = '';
    }
  }

  Future signIn() async {
    final user = await GoogleSignInAPI.login();
    print(user!.email);

    if (user.email.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please wait..  Logging You In'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 3),
      ));
      final url = Uri.parse(
          'https://airmatch-development.herokuapp.com/api/v2/gmailLogin');
      // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var headers = {
        'sourceFrom': '25',
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      Map body = {'email': user.email};
      var res = await http.post(url, body: body, headers: headers);

      if (res.statusCode == 200) {
        jsonResponse = json.decode(res.body);
        // print('Response Status: ${res.statusCode}');
        print('Response Status: ${res.body.toString()}');
        print(jsonResponse["token"]);
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonResponse["error"].toString()),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ));
      }
    }
  }

  Future signOut() async {
    final user = await GoogleSignInAPI.logout();
    print(user);
  }

  void dispose() {
    _userEmail.dispose();
    _userPass.dispose();
    super.dispose();
  }

  bool emailMode = true;

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage(
                    'asset/groupalike.jpg',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                tfContainer(
                    emailMode ? 'Enter Your Email' : 'Enter Your Phone Number',
                    emailMode
                        ? TextInputType.emailAddress
                        : TextInputType.number,
                    _userEmail,
                    emailMode ? Text('') : Text('+91'),
                    emailMode ? 40 : 10),
                Container(
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
                tfPassContainer('Enter Your Password'),
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(ForgetPasswordHome.routeName);
                    },
                    child: Text(
                      'Forgot Password?',
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
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.cyan[800]),
                    child: ElevatedButton(
                      onPressed: () {
                        String email = _userEmail.text.toString();
                        String pswd = _userPass.text.toString();
                        login(email, pswd, context);
                        // Navigator.of(context)
                        //     .popAndPushNamed(TabsScreen.routeName);
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                      style: ButtonStyle(
                        shadowColor: MaterialStateProperty.all(Colors.black12),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        // elevation: MaterialStateProperty.all(3),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Or Sign in with  ",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                          fontSize: 18),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                        onTap: signOut,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          radius: 22,
                          backgroundImage: AssetImage('asset/Group6281.png'),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: signIn,
                        child: CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            radius: 22,
                            backgroundImage:
                                AssetImage('asset/Group6282.png'))),
                  ],
                ),
                showFab
                    ? Container(
                        alignment: Alignment.centerRight,
                        height: 50,
                        width: double.infinity,
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(SignUpBasic.routeName);
                          },
                          clipBehavior: Clip.none,
                          label: Text(
                            'Create a new account',
                            softWrap: false,
                            style: TextStyle(letterSpacing: .6, fontSize: 17),
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.cyan[900],
                          elevation: 0,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
