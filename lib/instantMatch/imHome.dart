import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:job_assessment/instantMatch/imSearch.dart';
import 'package:job_assessment/location/location_model.dart';
import 'package:provider/provider.dart';

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
  Widget build(BuildContext context) {
    String _address = ""; // create this variable
    var locationModel = Provider.of<LocationModel>(context);
    final double lat = locationModel.latitude.toDouble();
    final double long = locationModel.longitude.toDouble();
    Future.delayed(Duration(seconds: 2), () async {
      print(lat);
      print(long);
      List<Placemark> newPlace = await placemarkFromCoordinates(lat, long);
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
    });
    Map<String, dynamic> request = {
      "latitude": lat,
      "longitude": long,
      "distance": _value,
      "interests": [],
      "sameGender": sameGenderBool,
      "onlineRecently": onlineRecentlyBool,
      "everyone": everyoneBool
    };
    String body = json.encode(request);
    if (selectedMatchValue == matchWith[1]) {
      sameGenderBool = true;
      onlineRecentlyBool = false;
      everyoneBool = false;
    } else if (selectedMatchValue == matchWith[2]) {
      sameGenderBool = false;
      onlineRecentlyBool = true;
      everyoneBool = false;
    } else if (selectedMatchValue == matchWith[3]) {
      sameGenderBool = false;
      onlineRecentlyBool = false;
      everyoneBool = true;
    } else {
      sameGenderBool = false;
      onlineRecentlyBool = false;
      everyoneBool = false;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              height: 300,
              child: GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: LatLng(lat, long), zoom: 15),
                zoomControlsEnabled: false,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.grey),
            ),
          ),
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
            child: ListView.builder(
              padding: EdgeInsets.only(left: 15),
              scrollDirection: Axis.horizontal,
              itemCount: matchWith.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      print(_address);
                      selectedMatchValue = matchWith[index];
                      print(sameGenderBool);
                      print(onlineRecentlyBool);
                      print(everyoneBool);
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
                        matchWith[index],
                        style: TextStyle(color: Colors.teal),
                      ),
                    ),
                  ),
                );
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
                Navigator.of(context)
                    .pushReplacementNamed(IMSearch.routeName, arguments: body);
              },
              label: Text('Find me a group'),
              backgroundColor: Colors.cyan[700])),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
