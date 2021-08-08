import 'package:flutter/material.dart';
import 'package:job_assessment/instantMatch/imHome.dart';

class PeopleScreen extends StatefulWidget {
  @override
  _PeopleScreenState createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Hey'),
          onPressed: () {
            Navigator.of(context)
                .pushNamed(IMHome.modalRoute,);
          },
        ),
      ),
    );
  }
}
