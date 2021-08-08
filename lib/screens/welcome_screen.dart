import 'package:flutter/material.dart';
import 'package:job_assessment/screens/login_screen.dart';
import 'package:postgres/postgres.dart';
import 'package:job_assessment/signIn/SignUp_basic.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = '/welcomeScreen';
  final List headerText = ['Match', 'Interact', 'Meet'];
  final List subText = [
    'Match with nearby similar peoples',
    'Play Games and Chat',
    'Schedule a meeting together'
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
    //  await conn.close();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            //flex: 2,
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(0),
                      //height: 400,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(img),
                      // decoration: BoxDecoration(
                      // border: Border.all(width: 2),
                      //),
                    ),
                    Text(
                      headerText[index],
                      style: TextStyle(
                        color: Colors.teal[300],
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      subText[index],
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        //fontWeight: FontWeight.bold,
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
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.teal[300]!,
                    Colors.cyan[800]!,
                    Colors.cyan[800]!,
                  ],
                ),
              ),
              child: ElevatedButton(

                onPressed: () => Navigator.of(context)
                    .pushReplacementNamed(SignUpBasic.routeName),
                child: Text('SIGN UP'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  // elevation: MaterialStateProperty.all(3),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                ),
              ),
            ),
          ),
          Container(
            //padding: EdgeInsets.only(bottom: 10),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Already have an Account?'),
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(0))),
                  onPressed:()=> Navigator.of(context).pushReplacementNamed(LoginPage.routeName),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
