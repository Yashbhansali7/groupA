import 'package:flutter/material.dart';
import 'package:job_assessment/signUp/SignUp_interest.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_assessment/Global.dart' as global;

class SignUpGeneral extends StatefulWidget {
  static const routeName = '/signUpGeneral';

  @override
  _SignUpGeneralState createState() => _SignUpGeneralState();
}

class _SignUpGeneralState extends State<SignUpGeneral> {
  List<dynamic> _placeList = [];
  bool searchBool = false;
  String selectedPlace = '';
  String finalDate = '1';
  String finalMonth = '1';
  String finalYear = '2021';

  showValidationDialog(String text) {
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
                          Navigator.of(context).pop();
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

  void getSuggestion(String input, lat, long) async {
    String kPLACES_API_KEY = "AIzaSyAG5eGy3nisf3udoZ3AvpGkqs7pJWng6Vg";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final url = Uri.parse(
        '$baseURL?input=$input&location=$lat,$long&types=%28cities%29&components=country:in&key=$kPLACES_API_KEY');
    var res = await http.get(url);
    if (res.statusCode == 200) {
      setState(() {
        _placeList = json.decode(res.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  TextEditingController cityController = TextEditingController();
  TextEditingController refController = TextEditingController();

  final _form = GlobalKey<FormState>();
  String dropdownDate = '1';
  String dropdownMonth = "January";
  String dropdownYear = '2021';

  @override
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
        child: Form(
          key: _form,
          child: ListView(
            children: [
              Text(
                'Which city you live in?',
                style: TextStyle(
                    color: Colors.teal,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  onFieldSubmitted: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        searchBool = false;
                      });
                    }
                  },
                  onChanged: (val) {
                    setState(() {
                      searchBool = true;
                      getSuggestion(val, global.lat, global.long);
                    });
                  },
                  controller: cityController..text,
                  keyboardType: TextInputType.visiblePassword,
                  style: TextStyle(fontSize: 21),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            cityController.text = '';
                            searchBool = false;
                            FocusScope.of(context).unfocus();
                          });
                          print(_placeList);
                        },
                        icon: Icon(Icons.cancel),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      labelText: 'Enter City',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                          fontSize: 19,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500)),
                ),
              ),
              searchBool
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _placeList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            setState(() {
                              cityController.text =
                                  _placeList[index]["description"];
                              selectedPlace = _placeList[index]["description"];
                              global.signUpCity =
                                  _placeList[index]["description"];
                              FocusScope.of(context).unfocus();
                              searchBool = false;
                            });
                          },
                          title: Text(_placeList[index]["description"]),
                        );
                      },
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Date of birth',
                          style: TextStyle(
                              color: Colors.teal,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          //mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15),
                              width: 60,
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: dropdownDate,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.teal),
                                  dropdownColor: Colors.white,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownDate = newValue!;
                                      if (dropdownDate.length == 1) {
                                        finalDate = '0' + dropdownDate;
                                      } else {
                                        finalDate = dropdownDate;
                                      }
                                      print(finalDate);
                                    });
                                  },
                                  items: List<String>.generate(31,
                                          (int index) => (index + 1).toString())
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 15),
                              width: 150,
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: dropdownMonth,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.teal),
                                  dropdownColor: Colors.white,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownMonth = newValue!;
                                      if (dropdownMonth == "January") {
                                        setState(() {
                                          finalMonth = '01';
                                        });
                                      } else if (dropdownMonth == "February") {
                                        setState(() {
                                          finalMonth = '02';
                                        });
                                      } else if (dropdownMonth == "March") {
                                        setState(() {
                                          finalMonth = '03';
                                        });
                                      } else if (dropdownMonth == "April") {
                                        setState(() {
                                          finalMonth = '04';
                                        });
                                      } else if (dropdownMonth == "May") {
                                        setState(() {
                                          finalMonth = '05';
                                        });
                                      } else if (dropdownMonth == "June") {
                                        setState(() {
                                          finalMonth = '06';
                                        });
                                      } else if (dropdownMonth == "July") {
                                        setState(() {
                                          finalMonth = '07';
                                        });
                                      } else if (dropdownMonth == "August") {
                                        setState(() {
                                          finalMonth = '08';
                                        });
                                      } else if (dropdownMonth == "September") {
                                        setState(() {
                                          finalMonth = '09';
                                        });
                                      } else if (dropdownMonth == "October") {
                                        setState(() {
                                          finalMonth = '10';
                                        });
                                      } else if (dropdownMonth == "November") {
                                        setState(() {
                                          finalMonth = '11';
                                        });
                                      } else {
                                        setState(() {
                                          finalMonth = '12';
                                        });
                                      }
                                    });
                                    print(finalMonth);
                                  },
                                  items: [
                                    "January",
                                    "February",
                                    "March",
                                    "April",
                                    "May",
                                    "June",
                                    "July",
                                    "August",
                                    "September",
                                    "October",
                                    "November",
                                    "December"
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12)),
                              padding: EdgeInsets.only(left: 15),
                              width: 100,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: dropdownYear,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.teal),
                                  dropdownColor: Colors.white,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownYear = newValue!;
                                      finalYear = dropdownYear;
                                      print(finalYear);
                                    });
                                  },
                                  items: List<String>.generate(
                                          50,
                                          (int index) =>
                                              (2021 - index).toString())
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          'I have a Referral Code',
                          style: TextStyle(
                              color: Colors.teal,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            controller: refController,
                            keyboardType: TextInputType.visiblePassword,
                            style: TextStyle(fontSize: 24),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 15),
                                labelText: 'Enter Referral Code',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                border: InputBorder.none,
                                labelStyle: TextStyle(
                                    fontSize: 19,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500)),
                          ),
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (cityController.text.isEmpty) {
              showValidationDialog('Please select a city');
            } else if (dropdownYear == '2021') {
              showValidationDialog('Please select valid date of birth');
            } else {
              setState(() {
                global.signUpCity = cityController.text;
                global.signUpDob =
                    finalDate + '-' + finalMonth + '-' + finalYear;
              });
              print(global.signUpDob);
              Navigator.of(context)
                  .pushReplacementNamed(SignUpInterest.routeName);
            }
          },
          child: Icon(Icons.arrow_forward)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
