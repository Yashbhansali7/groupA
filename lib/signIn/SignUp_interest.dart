import 'package:flutter/material.dart';
import 'package:job_assessment/signIn/SignUp_dp.dart';

class SignUpInterest extends StatefulWidget {
  static const routeName = 'signUpInterest';

  @override
  _SignUpInterestState createState() => _SignUpInterestState();
}

class _SignUpInterestState extends State<SignUpInterest> {
  List collectiveInterest = [];
  List sportsInterest = [
    'Football',
    'Cricket',
    'Basketball',
    'Tennis',
    'Table Tennis',
    'Hockey'
  ];
  List foodInterest = [
    'Italian',
    'Chinese',
    'North-Indian',
    'South-Indian',
    'Mexican',
  ];
  List musicInterest = [
    'Pop',
    'Rock',
    'Jazz',
    'Classic',
    'Heavy Metal',
    'Country'
  ];
  List danceInterest = [
    'Contemporary',
    'Ballroom',
    'Hip-hop',
    'Freestyle',
    'Ballet',
    'Tap'
  ];
  int currLength = 7;
  @override
  Widget build(BuildContext context) {
    final token = ModalRoute.of(context)!.settings.arguments.toString();
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 50, 20, 100),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose your interest',
                style: TextStyle(
                    color: Colors.teal,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),
              Text('You\'ll be placed in selected categories',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  )),
              Container(
                height: 60,
                padding: EdgeInsets.only(top: 30, right: 10),
                alignment: Alignment.centerRight,
                child: (() {
                  if (collectiveInterest.length < 2) {
                    return Text(
                      'Select minimum 2 interests',
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
                padding: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  style: TextStyle(fontSize: 24),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 15),
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
              Text(
                'Sports',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 150,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .43,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: sportsInterest.length,
                  itemBuilder: (context, i) {
                    String bro = sportsInterest[i];
                    return TextButton(
                      style: ButtonStyle(
                        textStyle:
                            MaterialStateProperty.all(TextStyle(fontSize: 18)),
                        backgroundColor: collectiveInterest.contains(bro)
                            ? MaterialStateProperty.all(Colors.white)
                            : MaterialStateProperty.all(Colors.grey[100]),
                        foregroundColor: collectiveInterest.contains(bro)
                            ? MaterialStateProperty.all(Colors.cyan[800])
                            : MaterialStateProperty.all(Colors.grey),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                            collectiveInterest.add(sportsInterest[i]);
                            currLength = currLength - 1;
                          }
                          print(collectiveInterest);
                        });
                      },
                      child: Text(sportsInterest[i]),
                    );
                  },
                  scrollDirection: Axis.horizontal,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Food',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 150,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .43,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: foodInterest.length,
                  itemBuilder: (context, i) {
                    String bro = foodInterest[i];
                    return TextButton(
                      style: ButtonStyle(
                        textStyle:
                            MaterialStateProperty.all(TextStyle(fontSize: 18)),
                        backgroundColor: collectiveInterest.contains(bro)
                            ? MaterialStateProperty.all(Colors.white)
                            : MaterialStateProperty.all(Colors.grey[100]),
                        foregroundColor: collectiveInterest.contains(bro)
                            ? MaterialStateProperty.all(Colors.cyan[800])
                            : MaterialStateProperty.all(Colors.grey),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                            collectiveInterest.add(foodInterest[i]);
                            currLength = currLength - 1;
                          }
                          print(collectiveInterest);
                        });
                      },    child: Text(foodInterest[i]),
                    );
                  },
                  scrollDirection: Axis.horizontal,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Music',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 150,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .43,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: musicInterest.length,
                  itemBuilder: (context, i) {
                    String bro = musicInterest[i];
                    return TextButton(
                      style: ButtonStyle(
                        textStyle:
                            MaterialStateProperty.all(TextStyle(fontSize: 18)),
                        backgroundColor: collectiveInterest.contains(bro)
                            ? MaterialStateProperty.all(Colors.white)
                            : MaterialStateProperty.all(Colors.grey[100]),
                        foregroundColor: collectiveInterest.contains(bro)
                            ? MaterialStateProperty.all(Colors.cyan[800])
                            : MaterialStateProperty.all(Colors.grey),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                            collectiveInterest.add(musicInterest[i]);
                            currLength = currLength - 1;
                          }
                          print(collectiveInterest);
                        });
                      },
                      child: Text(musicInterest[i]),
                    );
                  },
                  scrollDirection: Axis.horizontal,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Dance',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 150,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .43,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: danceInterest.length,
                  itemBuilder: (context, i) {
                    String bro = danceInterest[i];
                    return TextButton(
                      style: ButtonStyle(
                        textStyle:
                            MaterialStateProperty.all(TextStyle(fontSize: 18)),
                        backgroundColor: collectiveInterest.contains(bro)
                            ? MaterialStateProperty.all(Colors.white)
                            : MaterialStateProperty.all(Colors.grey[100]),
                        foregroundColor: collectiveInterest.contains(bro)
                            ? MaterialStateProperty.all(Colors.cyan[800])
                            : MaterialStateProperty.all(Colors.grey),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                            collectiveInterest.add(danceInterest[i]);
                            currLength = currLength - 1;
                          }
                          print(collectiveInterest);
                        });
                      },
                      child: Text(danceInterest[i]),
                    );
                  },
                  scrollDirection: Axis.horizontal,
                ),
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
              if (collectiveInterest.length >= 2 &&
                  collectiveInterest.length <= 7)
                Navigator.of(context).pushReplacementNamed(SignUpDP.routeName,arguments: token);
              else if (collectiveInterest.length < 2) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please select minimum 2 interests'),
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
                collectiveInterest.length >= 2 && collectiveInterest.length <= 7
                    ? Colors.cyan
                    : Colors.grey,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
