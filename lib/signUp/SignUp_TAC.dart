import 'package:flutter/material.dart';
import 'package:job_assessment/signUp/SignUp_interest.dart';

class SignUpTAC extends StatefulWidget {
  static const routeName = 'signupTAC';

  @override
  _SignUpTACState createState() => _SignUpTACState();
}

class _SignUpTACState extends State<SignUpTAC> {
  bool cb1selected = false;
  bool cb1expanded = false;
  bool cb2selected = false;
  bool cb2expanded = false;
  bool cb3selected = false;
  bool cb3expanded = false;
  bool cb4selected = false;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.cyan[800],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              'Data Preferences',
              style: TextStyle(
                  color: Colors.teal,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 100.0),
              child: Text('At Groupalike we\'re committed to your privacy.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Allow us to:',
              style: TextStyle(
                  color: Colors.teal,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20,
            ),
            CheckboxListTile(
              tileColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              title: Text(
                'Collect & Store your data',
                style: TextStyle(
                    color: Colors.teal,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              secondary: GestureDetector(
                  onTap: () {
                    setState(() {
                      cb1expanded = !cb1expanded;
                    });
                  },
                  child: Icon(Icons.arrow_drop_down)),
              checkColor: Colors.teal,
              dense: true,
              activeColor: Colors.transparent,
              value: cb1selected,
              onChanged: (value) {
                setState(() {
                  cb1selected = value!;
                });
              },
            ),
            cb1expanded
                ? Container(
                    padding: EdgeInsets.only(left: 73),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      color: Colors.grey[50],
                    ),
                    child: Text('hello'),
                  )
                : SizedBox(
                    height: 1,
                  ),
            SizedBox(
              height: 5,
            ),
            CheckboxListTile(
              tileColor: Colors.grey[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              title: Text(
                'Communicate with you',
                style: TextStyle(
                    color: Colors.teal,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              secondary: GestureDetector(
                  onTap: () {
                    setState(() {
                      cb2expanded = !cb2expanded;
                    });
                  },
                  child: Icon(Icons.arrow_drop_down)),
              checkColor: Colors.teal,
              dense: true,
              activeColor: Colors.transparent,
              value: cb2selected,
              onChanged: (value) {
                setState(() {
                  cb2selected = value!;
                });
              },
            ),
            cb2expanded
                ? Container(
                    padding: EdgeInsets.only(left: 73),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      color: Colors.grey[50],
                    ),
                    child: Text('hello'),
                  )
                : SizedBox(
                    height: 1,
                  ),
            SizedBox(
              height: 5,
            ),
            CheckboxListTile(
              tileColor: Colors.grey[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              title: Text(
                'Tailor offers and ads for you',
                style: TextStyle(
                    color: Colors.teal,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              secondary: GestureDetector(
                  onTap: () {
                    setState(() {
                      cb3expanded = !cb3expanded;
                    });
                  },
                  child: Icon(Icons.arrow_drop_down)),
              checkColor: Colors.teal,
              dense: true,
              activeColor: Colors.transparent,
              value: cb3selected,
              onChanged: (value) {
                setState(() {
                  cb3selected = value!;
                });
              },
            ),
            cb3expanded
                ? Container(
                    padding: EdgeInsets.only(left: 73),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      color: Colors.grey[50],
                    ),
                    child: Text('hello'),
                  )
                : SizedBox(
                    height: 1,
                  ),
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CheckboxListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                title: RichText(
                  text: TextSpan(
                      text: 'I\'ve read and accept all ',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(
                            text: 'Terms & Condition ',
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 20,
                                fontWeight: FontWeight.w500)),
                        TextSpan(text: '\nand '),
                        TextSpan(
                            text: 'Privacy Policy.',
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 20,
                                fontWeight: FontWeight.w500)),
                      ]),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                checkColor: Colors.teal,
                dense: true,
                activeColor: Colors.transparent,
                value: cb4selected,
                onChanged: (value) {
                  setState(() {
                    cb4selected = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .pushReplacementNamed(SignUpInterest.routeName);
          },
          child: Icon(Icons.arrow_forward)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
