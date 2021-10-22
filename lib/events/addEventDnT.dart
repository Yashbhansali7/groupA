import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_assessment/events/addEventLocation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:job_assessment/Global.dart' as global;

class AddEventDnT extends StatefulWidget {
  static const routeName = '/addEventDnT';
  @override
  _AddEventDnTState createState() => _AddEventDnTState();
}

DateTime selectedDay = DateTime.now();
DateTime focusedDay = DateTime.now();
bool reoccuringBool = false;
bool paidEventBool = false;
bool advancedOptionBool = false;
String dropdownDate = '1';
String dropdownType = 'Day';
int _radioSelected = 1;
String? _radioVal;

class _AddEventDnTState extends State<AddEventDnT> {
  initState() {
    super.initState();
    selectedDay = DateTime.now();
    focusedDay = DateTime.now();
   
  }

  TextEditingController startTimeTF1 = new TextEditingController();
  TextEditingController startTimeTF2 = new TextEditingController();
  final startTimeFN1 = FocusNode();
  final startTimeFN2 = FocusNode();
  var startTimeMode = 'AM';
  TextEditingController endTimeTF1 = new TextEditingController();
  TextEditingController endTimeTF2 = new TextEditingController();
  final endTimeFN1 = FocusNode();
  final endTimeFN2 = FocusNode();
  var endTimeMode = 'AM';
  String? startTime;
  String? endTime;
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  DateTime? _selectedDate;
  void _pickDateDialog() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDatePickerMode: DatePickerMode.day,
      helpText: 'Choose date',
      cancelText: 'Cancel',
      confirmText: 'Save',
      errorFormatText: 'Invalid date format',
      errorInvalidText: 'Invalid date format',
      fieldLabelText: 'Start date',
      fieldHintText: 'Year/Month/Date',
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  Container otpContainer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
      height: 38,
      width: 120,
      child: TextFormField(
        textAlign: TextAlign.end,
        focusNode: _focusNode,
        controller: _controller,
        cursorColor: Colors.black,
        autofocus: false,
        maxLength: 6,
        onEditingComplete: () => _focusNode.unfocus(),
        style: TextStyle(fontSize: 18),
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            suffixText: '.00',
            prefixText: 'Rs.',
            contentPadding: EdgeInsets.only(left: 4, bottom: 4),
            border: InputBorder.none,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            counterText: ''),
      ),
    );
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

  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime =
      TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 15)));
  void _selectStartTime() async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );
    if (newTime != null) {
      setState(() {
        selectedStartTime = newTime;
        global.addEventStartTime= newTime.format(context).toString();
      });
    }
    else{
       global.addEventStartTime= TimeOfDay.now().format(context);
    }
  }

  void _selectEndTime() async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    );
    if (newTime != null) {
      setState(() {
        selectedEndTime = newTime;
        global.addEventEndTime= newTime.format(context).toString();
      });
    }
    else{
      global.addEventEndTime = TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 15))).format(context);
    }
    if (selectedStartTime.hour == selectedEndTime.hour) {
      if (selectedStartTime.minute >= selectedEndTime.minute) {
          showMessageDialog('Select valid end time');
        setState(() {
           selectedStartTime = TimeOfDay.now();
   selectedEndTime =
      TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 15)));
        });
      }
    }
   else if (selectedEndTime.hour < selectedStartTime.hour) {
      showMessageDialog('Select valid end time');
      setState(() {
         selectedStartTime = TimeOfDay.now();
   selectedEndTime =
      TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 15)));
      });
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
        leading: InkWell(
          onTap: Navigator.of(context).pop,
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.cyan[700],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.red,
              margin: EdgeInsets.only(top: 10, left: 5, bottom: 30),
              child: Text('data'),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Re-Occurring',
                        style: TextStyle(
                            color: Colors.cyan[700],
                            fontSize: 17,
                            fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: Switch(
                          value: reoccuringBool,
                          onChanged: (value) {
                            setState(() {
                              reoccuringBool = value;
                              print(reoccuringBool);
                            });
                          },
                          activeTrackColor: Colors.grey[300],
                          activeColor: Colors.cyan[600],
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                  reoccuringBool
                      ? Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Repeats Every',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 20),
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(2)),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        icon: Visibility(
                                            visible: false,
                                            child: Icon(Icons.arrow_downward)),
                                        value: dropdownDate,
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        dropdownColor: Colors.white,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownDate = newValue!;
                                          });
                                        },
                                        items: List<String>.generate(
                                                31,
                                                (int index) =>
                                                    (index + 1).toString())
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
                                    margin: EdgeInsets.only(left: 12),
                                    padding: EdgeInsets.only(left: 15),
                                    width: 90,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(2)),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        value: dropdownType,
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        dropdownColor: Colors.white,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownType = newValue!;
                                          });
                                        },
                                        items: ['Day', 'Week', 'Month', 'Year']
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
                                height: 15,
                              ),
                              Text(
                                'Ends',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Radio(
                                        value: 1,
                                        groupValue: _radioSelected,
                                        activeColor: Colors.cyan[700],
                                        onChanged: (int? value) {
                                          setState(() {
                                            _radioSelected = value!;
                                            _radioVal = 'Never';
                                          });
                                        },
                                      ),
                                      Text('Never')
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio(
                                        value: 2,
                                        groupValue: _radioSelected,
                                        activeColor: Colors.cyan[700],
                                        onChanged: (int? value) {
                                          setState(() {
                                            _radioSelected = value!;
                                            _radioVal = 'onDate';
                                          });
                                        },
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'On',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          ElevatedButton(
                                              style: ButtonStyle(
                                                  elevation:
                                                      MaterialStateProperty.all(
                                                          0),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.grey[200]),
                                                  foregroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.black)),
                                              child: _selectedDate == null
                                                  ? Text(
                                                      DateFormat.yMMMd().format(
                                                          DateTime.now()),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    )
                                                  : Text(
                                                      DateFormat.yMMMd().format(
                                                          _selectedDate!),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400)),
                                              onPressed: _pickDateDialog),
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio(
                                        value: 3,
                                        groupValue: _radioSelected,
                                        activeColor: Colors.cyan[700],
                                        onChanged: (int? value) {
                                          setState(() {
                                            _radioSelected = value!;
                                            _radioVal = 'onOccurance';
                                          });
                                        },
                                      ),
                                      Text(
                                        'On',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 20, right: 20),
                                        padding: EdgeInsets.only(left: 20),
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            icon: Visibility(
                                                visible: false,
                                                child:
                                                    Icon(Icons.arrow_downward)),
                                            value: dropdownDate,
                                            elevation: 16,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            dropdownColor: Colors.white,
                                            onChanged: null,
                                            items: List<String>.generate(
                                                    31,
                                                    (int index) =>
                                                        (index + 1).toString())
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'occurance',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(right: 30, bottom: 5, top: 5),
                          height: 300,
                          color: Colors.white,
                          child: TableCalendar(
                            headerStyle: HeaderStyle(
                                headerMargin: EdgeInsets.all(0),
                                headerPadding: EdgeInsets.only(bottom: 5),
                                formatButtonVisible: false,
                                titleCentered: true),
                            rowHeight: 40 + 5,
                            focusedDay: selectedDay,
                            firstDay: DateTime(1990),
                            lastDay: DateTime(2050),
                            startingDayOfWeek: StartingDayOfWeek.sunday,
                            daysOfWeekVisible: true,
                            calendarStyle: CalendarStyle(
                                todayDecoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[600])),
                            onDaySelected:
                                (DateTime selectDay, DateTime focusDay) {
                              setState(() {
                                selectedDay = selectDay;
                                focusedDay = focusDay;
                                global.addEventStartDate =
                                    DateFormat.yMMMMd().format(focusedDay);
                              });
                              print(focusedDay);
                            },
                            selectedDayPredicate: (DateTime date) {
                              return isSameDay(selectedDay, date);
                            },
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Starting Time',
                            style: TextStyle(
                                color: Colors.cyan[700],
                                fontSize: 17,
                                fontWeight: FontWeight.w400),
                          ),
                          TextButton(
                              onPressed: () {
                                _selectStartTime();
                              },
                              child: Text(
                                selectedStartTime.format(context).toString(),
                                style: TextStyle(
                                    color: Colors.cyan[700],
                                    fontSize: 19,
                                    fontWeight: FontWeight.w400),
                              )),
                        ]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ending Time',
                          style: TextStyle(
                              color: Colors.cyan[700],
                              fontSize: 17,
                              fontWeight: FontWeight.w400),
                        ),
                        TextButton(
                            onPressed: () {
                              _selectEndTime();
                            },
                            child: Text(
                              selectedEndTime.format(context).toString(),
                              style: TextStyle(
                                  color: Colors.cyan[700],
                                  fontSize: 19,
                                  fontWeight: FontWeight.w400),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        advancedOptionBool = !advancedOptionBool;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Advanced Options',
                          style: TextStyle(
                              color: Colors.cyan[700],
                              fontSize: 17,
                              fontWeight: FontWeight.w400),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            advancedOptionBool
                                ? Icons.arrow_drop_down
                                : Icons.arrow_drop_up,
                            size: 40,
                            color: Colors.cyan[700],
                          ),
                        )
                      ],
                    ),
                  ),
                  advancedOptionBool
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Paid Event',
                                    style: TextStyle(
                                        color: Colors.cyan[700],
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 18.0),
                                  child: Switch(
                                    value: paidEventBool,
                                    onChanged: (value) {
                                      setState(() {
                                        paidEventBool = value;
                                        print(paidEventBool);
                                      });
                                    },
                                    activeTrackColor: Colors.grey[300],
                                    activeColor: Colors.cyan[600],
                                    inactiveThumbColor: Colors.grey,
                                    inactiveTrackColor: Colors.grey[300],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Set Price',
                                    style: TextStyle(
                                        color: Colors.cyan[700],
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 18.0),
                                  child: otpContainer(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'VIP',
                                    style: TextStyle(
                                        color: Colors.cyan[700],
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 18.0),
                                  child: TextButton(
                                      onPressed: () {},
                                      child: Row(
                                        children: [
                                          Text(
                                            '+',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 30),
                                          ),
                                          Icon(Icons.person,
                                              color: Colors.grey, size: 30)
                                        ],
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : Container(),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 10, right: 10),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.cyan[700]),
                      alignment: Alignment.center,
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(AddEventLocation.routeName);
                            print(global.addEventStartDate);
                          },
                          icon: Icon(
                            Icons.arrow_forward_sharp,
                            color: Colors.white,
                          )),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
