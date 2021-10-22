import 'package:flutter/material.dart';
import 'package:job_assessment/location/location_model.dart';
import 'package:job_assessment/screens/login_screen.dart';
import 'package:postgres/postgres.dart';
import 'package:job_assessment/signUp/SignUp_basic.dart';
import 'package:provider/provider.dart';
import 'package:job_assessment/Global.dart' as global;

class WelcomeScreen extends StatelessWidget {
  static const routeName = '/welcomeScreen';
  final List headerText = ['Match', 'Interact', 'Meet'];
  final List subText = [
    'Match with nearby peoples',
    'Multi-Player games and activities',
    'Enjot offers from local business'
  ];
  final String img = 'asset/welcome_screen.png';

  void connect() async {
    final conn = PostgreSQLConnection('10.0.2.2', 5432, 'groupalike',
        username: 'postgres', password: '9624');
    await conn.open();

    var results = await conn.query("Select * from abc");
    for (var row in results) {
      print('''
    id: ${row[0]}
    name: ${row[1]}
    job: ${row[2]}
    ''');
    }
  }

  Widget build(BuildContext context) {
    var locationModel = Provider.of<LocationModel>(context);
    global.lat = locationModel.latitude;
    global.long = locationModel.longitude;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(0),
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(img),
                    ),
                    Text(
                      headerText[index],
                      style: TextStyle(
                        color: Colors.cyan[900],
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      subText[index],
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                      ),
                    ),
                  ],
                );
              },
              scrollDirection: Axis.horizontal,
              physics: PageScrollPhysics(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF00695C)),
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context)
                    .pushReplacementNamed(LoginPage.routeName),
                child: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  // elevation: MaterialStateProperty.all(3),
                  foregroundColor: MaterialStateProperty.all(Colors.teal[800]),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.cyan[800]),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context)
                    .pushReplacementNamed(SignUpBasic.routeName),
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
                style: ButtonStyle(
                  shadowColor: MaterialStateProperty.all(Colors.black12),

                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  // elevation: MaterialStateProperty.all(3),
                  //shadowColor: MaterialStateProperty.all(Colors.transparent),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            margin: EdgeInsets.only(top: 15, bottom: 25),
            child: Column(
              children: [
                Text(
                  'By clicking Sign Up, you agree with our Terms & Conditions',
                  style: TextStyle(
                      letterSpacing: .5,
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 4),
                Text(
                  'Learn about how we process your data in our Privacy Policy',
                  style: TextStyle(
                      letterSpacing: .5,
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
