import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_assessment/Global.dart' as global;
import 'package:job_assessment/events/addEventHome.dart';
import 'package:job_assessment/screens/tabs_screen.dart';

class AddEventLocation extends StatefulWidget {
  static const routeName = '/addEventLocation';
  @override
  _AddEventLocationState createState() => _AddEventLocationState();
}

class _AddEventLocationState extends State<AddEventLocation> {
  var _controller = TextEditingController();
  List<dynamic> _placeList = [];
  List<dynamic> _nearbyPlaceList = [];
  bool searchBool = false;
  bool showSummary = false;
  String selectedPlace = '';

  void getNearbySuggestion(lat, long) async {
    String kPLACES_API_KEY = "AIzaSyAG5eGy3nisf3udoZ3AvpGkqs7pJWng6Vg";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    final url = Uri.parse(
        '$baseURL?location=$lat,$long&radius=500&types=establishment&components=country:in&key=$kPLACES_API_KEY');
    var res = await http.get(url);
    if (res.statusCode == 200) {
      setState(() {
        _nearbyPlaceList = json.decode(res.body)['results'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  void getSuggestion(String input, lat, long) async {
    String kPLACES_API_KEY = "AIzaSyAG5eGy3nisf3udoZ3AvpGkqs7pJWng6Vg";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final url = Uri.parse(
        '$baseURL?input=$input&location=$lat,$long&radius=500&types=establishment&components=country:in&key=$kPLACES_API_KEY');
    var res = await http.get(url);
    if (res.statusCode == 200) {
      setState(() {
        _placeList = json.decode(res.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  initState() {
    super.initState();
    getNearbySuggestion(global.lat, global.long);
  }

  showMessageDialog(String text) {
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
 Navigator.popUntil(context,
                                  ModalRoute.withName(TabsScreen.routeName));
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

  var jsonResponse;
  addEvent() async {
    final url = Uri.parse('http://65.2.117.202:5000/api/v2/event');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {
      'x-access-token': global.token,
      'sourceFrom': '25',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    Map body = {
      'name': global.addEventName,
      'description': global.addEventDesc,
      'type': global.addEventType,
      'startAt': global.addEventStartDate,
      'endAt': global.addEventStartDate,
      'lattitude': global.lat.toString(),
      'longitude': global.long.toString(),
      'info': '',
      'googleId': '',
      'placeName': global.placeName,
      'address': global.placeAddress,
      'groupMemberId': global.addEventGroupMemberId,
      'groupId': global.addEventGroupId,
    };
    var res = await http.post(url, body: body, headers: headers);
    if (res.statusCode == 200) {
      jsonResponse = json.decode(res.body);
      print(jsonResponse);
      showMessageDialog('Event Added Successfully');
    } else {
      jsonResponse = json.decode(res.body);
      print(jsonResponse);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Schedule Event',
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
      body: selectedPlace == ''
          ? SingleChildScrollView(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                searchBool
                    ? Align(
                        alignment: Alignment.topCenter,
                        child: TextField(
                          controller: _controller,
                          onChanged: (val) {
                            setState(() {
                              getSuggestion(val, global.lat, global.long);
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Seek your location here",
                            focusColor: Colors.white,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            prefixIcon: Icon(Icons.map),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _controller.text = '';
                                  searchBool = false;
                                });
                                print(global.lat);
                                print(global.long);
                                print(_placeList);
                              },
                              icon: Icon(Icons.cancel),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                searchBool
                    ? Container()
                    : Stack(children: [
                        Container(
                          height: 280,
                          alignment: Alignment.center,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                                target: LatLng(global.lat, global.long),
                                zoom: 14),
                            zoomControlsEnabled: false,
                            myLocationButtonEnabled: true,
                            myLocationEnabled: true,
                          ),
                        ),
                        Positioned(
                            right: 10,
                            top: 60,
                            child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                    iconSize: 26,
                                    onPressed: () {
                                      setState(() {
                                        searchBool = true;
                                      });
                                    },
                                    icon: Icon(Icons.search))))
                      ]),
                searchBool
                    ? ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _placeList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () => setState(() {
                              selectedPlace = _placeList[index]["description"];
                              global.placeName =
                                  _placeList[index]["description"];
                            }),
                            title: Text(_placeList[index]["description"]),
                          );
                        },
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(top: 10),
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: _nearbyPlaceList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ListTile(
                              onTap: () => setState(() {
                                selectedPlace = _nearbyPlaceList[index]['name'];
                                global.placeName =
                                    _nearbyPlaceList[index]['name'];
                                global.placeAddress =
                                    _nearbyPlaceList[index]['vicinity'];
                              }),
                              tileColor: Colors.white,
                              title: Text(_nearbyPlaceList[index]['name']),
                              subtitle: Text(
                                _nearbyPlaceList[index]['vicinity'],
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ))
          : Container(
              width: double.infinity,
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: Text(
                        global.addEventName,
                        style: TextStyle(color: Colors.grey[700], fontSize: 30),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: Text(
                        global.addEventDesc,
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
                                  global.addEventStartDate,
                                  style: TextStyle(
                                      color: Colors.grey[700], fontSize: 18),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Text(
                                      DateFormat.Hm().format(DateTime.now()),
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 18),
                                    ),
                                    Text(
                                      '-',
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 18),
                                    ),
                                    Text(
                                      DateFormat.Hm().format(DateTime.now()
                                          .add(Duration(minutes: 15))),
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 18),
                                    ),
                                  ],
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
                            style: TextStyle(
                                color: Colors.teal[700], fontSize: 24),
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
                      margin: EdgeInsets.only(bottom: 80),
                      child: Text(
                        selectedPlace,
                        style: TextStyle(color: Colors.grey[700], fontSize: 22),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 130,
                          margin: EdgeInsets.only(),
                          child: FloatingActionButton.extended(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.teal[900],
                              onPressed: () {
                                addEvent();
                                // showMessageDialog('Event Added Successfully');
                                print(global.addEventName);
                                print(global.addEventDesc);
                                print(global.addEventTags);
                                print(global.addEventStartTime);
                                print(global.addEventEndTime);
                                print(global.addEventStartDate);
                                print(global.addEventLat);
                                print(global.addEventLong);
                                print(global.addEventType);
                                print(global.addEventGroupId);
                                print(global.addEventGroupMemberId);
                              },
                              label: Text(
                                'Done',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400),
                              )),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        FloatingActionButton(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.teal[900],
                            onPressed: () {
                              Navigator.popUntil(context,
                                  ModalRoute.withName(AddEventHome.routeName));
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colors.teal[900],
                              size: 30,
                            )),
                      ],
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12, width: 2),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(global.lat);
          print(global.long);
        },
      ),
    );
  }
}
