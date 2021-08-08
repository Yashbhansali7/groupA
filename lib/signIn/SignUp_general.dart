import 'package:flutter/material.dart';
import 'package:job_assessment/signIn/SignUp_interest.dart';

class SignUpGeneral extends StatefulWidget {
  static const routeName = '/signUpGeneral';

  @override
  _SignUpGeneralState createState() => _SignUpGeneralState();
}

class _SignUpGeneralState extends State<SignUpGeneral> {
  final _form = GlobalKey<FormState>();
  String dropdownDate = '1';
  String dropdownMonth = "January";
  String dropdownYear = '2021';
  Container tfContainer(String labelText,) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        style: TextStyle(fontSize: 24),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: InputBorder.none,
            labelStyle: TextStyle(
                fontSize: 19, color: Colors.grey, fontWeight: FontWeight.w500)),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final token = ModalRoute.of(context)!.settings.arguments;
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
              Text('Which city you live in?',style: TextStyle(
                    color: Colors.teal,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),),
                    SizedBox(height: 30,),
              tfContainer('Enter City'),
              SizedBox(height: 30,),
              Text('Date of birth',style: TextStyle(
                    color: Colors.teal,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),),
              SizedBox(height: 30,),            
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15),
                    width: 60,
                      decoration: BoxDecoration(color: Colors.grey[100],borderRadius: BorderRadius.circular(12)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        
                        value: dropdownDate,
                        
                        elevation: 16,
                        style: const TextStyle(color: Colors.teal),
                        dropdownColor: Colors.white,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownDate = newValue!;
                          });
                        },
                        items: List<String>.generate(
                                31, (int index) => (index + 1).toString())
                            .map<DropdownMenuItem<String>>((String value) {
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
                      decoration: BoxDecoration(color: Colors.grey[100],borderRadius: BorderRadius.circular(12)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: dropdownMonth,
                        
                        elevation: 16,
                        style: const TextStyle(color: Colors.teal),
                        dropdownColor: Colors.white,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownMonth = newValue!;
                          });
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
                        ].map<DropdownMenuItem<String>>((String value) {
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
                    decoration: BoxDecoration(color: Colors.grey[100],borderRadius: BorderRadius.circular(12)),
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
                          });
                        },
                        items: List<String>.generate(
                                30, (int index) => (2021 - index).toString())
                            .map<DropdownMenuItem<String>>((String value) {
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
              SizedBox(height: 40,),
              Text('I have a Referral Code',style: TextStyle(
                    color: Colors.teal,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),),
                    SizedBox(height: 20,),
            tfContainer('Enter Referral Code  ')
            ],
            
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
          Navigator.of(context).pushReplacementNamed(SignUpInterest.routeName,arguments: token);
           
          },
          child: Icon(Icons.arrow_forward)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
