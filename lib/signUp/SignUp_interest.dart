import 'package:flutter/material.dart';
import 'package:job_assessment/signUp/SignUp_dp.dart';
import 'dart:convert';
import 'package:job_assessment/Global.dart' as global;
import 'package:http/http.dart' as http;

class SignUpInterest extends StatefulWidget {
  static const routeName = 'signUpInterest';

  @override
  _SignUpInterestState createState() => _SignUpInterestState();
}

class _SignUpInterestState extends State<SignUpInterest> {
  List collectiveInterest = [];
  List interests = [];
  var response;
  initState() {
    _getInterests();
    super.initState();
  }

  _getInterests() async {
    final url = Uri.parse('http://65.2.117.202:5000/api/v2/interest');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {'sourceFrom': '25'};
    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      setState(() {
        response = json.decode(res.body);
      });
    } else {
      print(res.reasonPhrase);
      print(res.body.toString());
    }
  }

  int currLength = 7;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: response == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 100),
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose your interest',
                      style: TextStyle(
                          color: Colors.cyan[800],
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                    Container(
                      height: 40,
                      padding: EdgeInsets.only(top: 10, right: 10),
                      alignment: Alignment.centerRight,
                      child: (() {
                        if (collectiveInterest.length < 5) {
                          return Text(
                            'Select minimum 5 interests',
                            style: TextStyle(fontSize: 18),
                          );
                        } else if (collectiveInterest.length > 7) {
                          return Text(
                            'Select maximum 7 interests',
                            style: TextStyle(fontSize: 18),
                          );
                        } else {
                          return Text(
                            '$currLength interests left',
                            style: TextStyle(fontSize: 18),
                          );
                        }
                      }()),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        style: TextStyle(fontSize: 24),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 15),
                            labelText: 'Search Interest',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: InputBorder.none,
                            labelStyle: TextStyle(
                                fontSize: 19,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 380,
                      child: GridView.builder(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: .7,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 5),
                        itemCount: response['interest'].length,
                        itemBuilder: (context, i) {
                          String bro = response['interest'][i]['id'];
                          return TextButton(
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(0)),
                              textStyle: MaterialStateProperty.all(
                                  TextStyle(fontSize: 18)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              foregroundColor: collectiveInterest.contains(bro)
                                  ? MaterialStateProperty.all(Colors.cyan[800])
                                  : MaterialStateProperty.all(Colors.grey),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: collectiveInterest.contains(bro)
                                            ? Colors.teal
                                            : Colors.white,
                                        width: 2)),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                if (collectiveInterest.contains(bro)) {
                                  collectiveInterest.remove(bro);
                                  currLength = currLength + 1;
                                } else {
                                  collectiveInterest
                                      .add(response['interest'][i]['id']);
                                  currLength = currLength - 1;
                                }
                                print(collectiveInterest);
                              });
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                response['interest'][i]['gimage'] == null
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.groups,
                                          size: 50,
                                          color: Colors.teal,
                                        ),
                                      )
                                    : Image.network(
                                        response['interest'][i]['gimage'],
                                      ),
                                Text(
                                  response['interest'][i]['name'],
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: collectiveInterest.contains(bro)
                                          ? Colors.teal
                                          : Colors.grey),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: Container(
          height: 60,
          width: 300,
          child: FloatingActionButton.extended(
            onPressed: () {
              if (collectiveInterest.length >= 5 &&
                  collectiveInterest.length <= 7) {
                for (int i = 0; i < collectiveInterest.length; i++) {
                  global.signUpInterest.add({'id': collectiveInterest[i]});
                }
                if (global.signUpInterest[0] == {}) {
                  global.signUpInterest.removeAt(0);
                }
                Navigator.of(context).pushReplacementNamed(SignUpDP.routeName);
              } else if (collectiveInterest.length < 5) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please select minimum 5 interests'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please select maximum 7 interests'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            label: Text('Save and proceed'),
            backgroundColor:
                collectiveInterest.length >= 5 && collectiveInterest.length <= 7
                    ? Colors.cyan
                    : Colors.grey,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
