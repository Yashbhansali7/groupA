import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:job_assessment/Global.dart' as global;

class EventsDetails extends StatefulWidget {
  static const routeName = '/eventDetails';

  @override
  _EventsDetailsState createState() => _EventsDetailsState();
}

class _EventsDetailsState extends State<EventsDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Event Details',
          style:
              TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w400),
        ),
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.cyan[700],
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Text(
                  global.selectedEvent['name'],
                  style: TextStyle(color: Colors.grey[700], fontSize: 30),
                ),
                alignment: Alignment.centerLeft,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Text(
                  global.selectedEvent['description'],
                  style: TextStyle(color: Colors.grey[700], fontSize: 18),
                ),
                alignment: Alignment.centerLeft,
              ),
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.teal[800],
                      size: 90,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Container(
                          child: Text(
                            DateFormat.yMMMMd().format(DateTime.parse(global.selectedEvent['startAt'].toString()
                                                .substring(0, 10))),
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 18),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        Container(
                          child: Text(
                          global.selectedEvent
                                                    ['startAt']
                                                .toString()
                                                .substring(11, 16) +
                                            '-' +
                                         global.selectedEvent 
                                                    ['endAt']
                                                .toString()
                                                .substring(11, 16),
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.grey),
                                      ),
                          alignment: Alignment.centerLeft,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Venue',
                      style: TextStyle(color: Colors.teal[700], fontSize: 24),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Icon(
                        Icons.location_on_outlined,
                        color: Colors.teal[800],
                        size: 40,
                      ))
                ],
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  global.selectedEvent['placeName'],
                  style: TextStyle(color: Colors.grey[700], fontSize: 22),
                ),
                alignment: Alignment.centerLeft,
              ),
             Container(
                margin: EdgeInsets.only(bottom: 80),
                child: Text(
                  global.selectedEvent['address'],
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                alignment: Alignment.centerLeft,
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12, width: 2),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
        ),
      ),
    );
  }
}
