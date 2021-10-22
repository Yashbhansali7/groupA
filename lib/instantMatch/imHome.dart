import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import "package:job_assessment/Global.dart" as global;
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:job_assessment/instantMatch/imSearch.dart';

class IMHome extends StatefulWidget {
  static const modalRoute = '/imHome';
  @override
  _IMHomeState createState() => _IMHomeState();
}

class _IMHomeState extends State<IMHome> {
  List<String> matchWith = [
    'Custom Interest',
    'Same Gender',
    'Online Recently',
    'Everyone'
  ];
  String selectedMatchValue = '';

  String? previewUrl;
  int _value = 30;
  bool sameGenderBool = false;
  bool onlineRecentlyBool = false;
  bool everyoneBool = false;

  String? _address;
  void dispose() {
    super.dispose();
  }

  initState() {
    getMap();
    _getInterests();
    super.initState();
  }

  getMap() async {
    List<Placemark> newPlace =
        await placemarkFromCoordinates(global.lat, global.long);
    Placemark placeMark = newPlace[0];
    String? name = placeMark.name;
    String? subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? postalCode = placeMark.postalCode;
    String? country = placeMark.country;
    String address =
        "$name, $subLocality, $locality, $administrativeArea $postalCode, $country";
    setState(() {
      _address = address; // update _address
    });
  }

  showInterestDialog() {
    showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, ss) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)), //this right here
              child: Stack(
                children: [
                  Container(
                    height: 440,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(top: 3, right: 7),
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Icon(
                                Icons.close,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 380,
                            child: GridView.builder(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: .7,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 5),
                              itemCount: response['interest'].length,
                              itemBuilder: (context, i) {
                                String bro = response['interest'][i]['name'];
                                return TextButton(
                                  style: ButtonStyle(
                                    splashFactory: NoSplash.splashFactory,
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.all(0)),
                                    textStyle: MaterialStateProperty.all(
                                        TextStyle(fontSize: 18)),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    foregroundColor: global.instantMatchInterest
                                            .contains(bro)
                                        ? MaterialStateProperty.all(
                                            Colors.cyan[800])
                                        : MaterialStateProperty.all(
                                            Colors.grey),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(
                                              color: global.instantMatchInterest
                                                      .contains(bro)
                                                  ? Colors.teal
                                                  : Colors.white,
                                              width: 2)),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (global.instantMatchInterest
                                          .contains(bro)) {
                                        ss(() {
                                          global.instantMatchInterest
                                              .remove(bro);
                                        });
                                      } else {
                                        ss(() {
                                          global.instantMatchInterest.add(
                                              response['interest'][i]['name']);
                                        });
                                      }
                                      print(global.instantMatchInterest);
                                    });
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      response['interest'][i]['gimage'] == null
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.groups,
                                                size: 45,
                                                color: Colors.teal,
                                              ),
                                            )
                                          : Image.network(
                                              response['interest'][i]['gimage'],
                                            ),
                                      Text(
                                        response['interest'][i]['name'],
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: global.instantMatchInterest
                                                    .contains(bro)
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
                        ],
                      ),
                    ),
                  ),
                  global.instantMatchInterest.length > 0
                      ? Positioned(
                          left: 50,
                          right: 50,
                          bottom: 10,
                          child: Container(
                            height: 44,
                            child: FloatingActionButton.extended(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.cyan[700],
                              shape: RoundedRectangleBorder(
                                  side:
                                      BorderSide(color: Colors.cyan, width: 2),
                                  borderRadius: BorderRadius.circular(15)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              label: Text('Done'),
                            ),
                          ))
                      : SizedBox(height: 1)
                ],
              ),
            );
          });
        });
  }

  var response;
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

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              height: 300,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(global.lat, global.long), zoom: 15),
                zoomControlsEnabled: false,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.grey),
            ),
            Positioned(
              top: 20,
              left: 5,
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: GestureDetector(
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 30,
                      color: Colors.cyan[700],
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            )
          ]),
          SizedBox(
            height: 20,
          ),
          Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.teal, width: 1.5)),
              child: Text(
                _address.toString(),
              )),
          SizedBox(
            height: 30,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 25, bottom: 10),
            child: Text(
              'Match With',
              style: TextStyle(fontSize: 17),
            ),
          ),
          SizedBox(
            height: 40,
            child: StatefulBuilder(
              builder: (context, ss) {
                return ListView(
                    padding: EdgeInsets.only(left: 15),
                    scrollDirection: Axis.horizontal,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showInterestDialog();
                          ss(() {
                            sameGenderBool = false;
                            onlineRecentlyBool = false;
                            everyoneBool = false;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              border: Border.all(color: Colors.teal)),
                          margin: EdgeInsets.symmetric(horizontal: 7),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              matchWith[0],
                              style: TextStyle(color: Colors.teal),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ss(() {
                            global.instantMatchInterest = [];
                            sameGenderBool = true;
                            onlineRecentlyBool = false;
                            everyoneBool = false;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: sameGenderBool
                                  ? Colors.cyan[700]
                                  : Colors.white,
                              border: Border.all(color: Colors.teal)),
                          margin: EdgeInsets.symmetric(horizontal: 7),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              matchWith[1],
                              style: TextStyle(
                                  color: sameGenderBool
                                      ? Colors.white
                                      : Colors.teal),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ss(() {
                            sameGenderBool = false;
                            onlineRecentlyBool = true;
                            global.instantMatchInterest = [];
                            everyoneBool = false;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: onlineRecentlyBool
                                  ? Colors.cyan[700]
                                  : Colors.white,
                              border: Border.all(color: Colors.teal)),
                          margin: EdgeInsets.symmetric(horizontal: 7),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              matchWith[2],
                              style: TextStyle(
                                  color: onlineRecentlyBool
                                      ? Colors.white
                                      : Colors.teal),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ss(() {
                            global.instantMatchInterest = [];
                            sameGenderBool = false;
                            onlineRecentlyBool = false;
                            everyoneBool = true;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: everyoneBool
                                  ? Colors.cyan[700]
                                  : Colors.white,
                              border: Border.all(color: Colors.teal)),
                          margin: EdgeInsets.symmetric(horizontal: 7),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              matchWith[3],
                              style: TextStyle(
                                  color: everyoneBool
                                      ? Colors.white
                                      : Colors.teal),
                            ),
                          ),
                        ),
                      ),
                    ]);
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 25, bottom: 20),
            child: Text(
              'Search In  ',
              style: TextStyle(fontSize: 17),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('0 '),
                Text(' 15'),
                Text(' 30'),
                Text(
                  '45 KM',
                  style: TextStyle(color: Colors.cyan[700]),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Slider(
            value: _value.toDouble(),
            min: 0,
            max: 45,
            divisions: 3,
            activeColor: Colors.teal,
            inactiveColor: Colors.grey[200],
            label: _value.toString(),
            onChanged: (double newValue) {
              setState(() {
                _value = newValue.toInt();
              });
            },
          )
        ],
      ),
      floatingActionButton: Container(
          height: 60,
          width: 330,
          child: FloatingActionButton.extended(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              onPressed: () {
                Map<String, dynamic> request = {
                  "latitude": global.lat,
                  "longitude": global.long,
                  "distance": _value,
                  "interests": global.instantMatchInterest,
                  "sameGender": sameGenderBool,
                  "onlineRecently": onlineRecentlyBool,
                  "everyone": everyoneBool
                };
                setState(() {
                  global.instantMatchBody = json.encode(request);
                });
                Navigator.of(context).pushReplacementNamed(IMSearch.routeName);
              },
              label: Text('Find me a group'),
              backgroundColor: Colors.cyan[700])),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
