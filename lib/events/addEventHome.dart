import 'dart:io';

import 'package:job_assessment/Global.dart' as global;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_assessment/events/addEventDnT.dart';

class AddEventHome extends StatefulWidget {
  static const routeName = '/addEventHome';

  @override
  _AddEventHomeState createState() => _AddEventHomeState();
}

class _AddEventHomeState extends State<AddEventHome> {
  File? _profileImg = null;
  int _radioSelected = 1;
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController tagsController = TextEditingController();

  void _pickImg(ImageSource imageSource) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: imageSource,
    );
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _profileImg = pickedImageFile;
    });
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
          onTap: () {
            Navigator.of(context).pop();
            setState(() {
              global.addEventName = '';
              global.addEventDesc = '';
              global.addEventTags = [];
              global.addEventStartTime = '';
              global.addEventEndTime = '';
              global.addEventStartDate = '';
              global.addEventLat = '';
              global.addEventLong = '';
              global.addEventType = '';
            });
          },
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
              margin: EdgeInsets.only(top: 10, left: 200, bottom: 30),
              child: Text('data'),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: TextStyle(
                        color: Colors.cyan[700],
                        fontSize: 17,
                        fontWeight: FontWeight.w400),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 5, right: 20, bottom: 10),
                    padding: EdgeInsets.only(bottom: 10),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      // maxLength: maxLength,
                      controller: nameController..text = global.addEventName,
                      onEditingComplete: () {
                        setState(() {
                          global.addEventName = nameController.text;
                        });
                        FocusScope.of(context).unfocus();
                      },
                      keyboardType: TextInputType.name,
                      style: TextStyle(fontSize: 21),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                          helperText: '50 chars',
                          counterText: '',
                          //prefix: Text(''),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                          labelText: 'Event Name',
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          // border: InputBorder.none,
                          labelStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400)),
                    ),
                  ),
                  Text(
                    'Upload an Image',
                    style: TextStyle(
                        color: Colors.cyan[700],
                        fontSize: 17,
                        fontWeight: FontWeight.w400),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 15),
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.grey[100],
                      backgroundImage:
                          _profileImg == null ? null : FileImage(_profileImg!),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10.0)), //this right here
                                  child: Container(
                                    height: 200,
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              'Add photo',
                                              style: TextStyle(
                                                  color: Colors.cyan[800],
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                _pickImg(ImageSource.camera);
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                '  Take photo',
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                _pickImg(ImageSource.gallery);
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                '  Choose from gallery',
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        child: _profileImg == null
                            ? Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.cyan[700],
                              )
                            : null,
                      ),
                    ),
                  ),
                  Text(
                    'Description',
                    style: TextStyle(
                        color: Colors.cyan[700],
                        fontSize: 17,
                        fontWeight: FontWeight.w400),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 15, right: 20, bottom: 10),
                    padding: EdgeInsets.only(bottom: 10),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      minLines: 1,
                      
                      controller: descController..text = global.addEventDesc,
                      onEditingComplete: () {
                        setState(() {
                          global.addEventDesc = descController.text;
                        });
                        FocusScope.of(context).unfocus();
                      },
                      maxLines: 4,
                      keyboardType: TextInputType.name,
                      style: TextStyle(fontSize: 17),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        helperText: '150 chars',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                        border: OutlineInputBorder(
                            gapPadding: 5,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                  Text(
                    'Event Type',
                    style: TextStyle(
                        color: Colors.cyan[700],
                        fontSize: 17,
                        fontWeight: FontWeight.w400),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Activity'),
                      Radio(
                        value: 1,
                        groupValue: _radioSelected,
                        activeColor: Colors.cyan[700],
                        onChanged: (int? value) {
                          setState(() {
                            _radioSelected = value!;
                            global.addEventType = '11';
                          });
                        },
                      ),
                      Text('General'),
                      Radio(
                        value: 2,
                        groupValue: _radioSelected,
                        activeColor: Colors.cyan[700],
                        onChanged: (int? value) {
                          setState(() {
                            _radioSelected = value!;
                            global.addEventType= '12';
                          });
                        },
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 100,
                        margin: EdgeInsets.only(top: 5, bottom: 10),
                        padding: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          // maxLength: maxLength,
                          controller: tagsController,
                          keyboardType: TextInputType.name,
                          style: TextStyle(fontSize: 21),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              labelText: 'Tags',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              // border: InputBorder.none,
                              labelStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.cyan[700],
                                  fontWeight: FontWeight.w400)),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          child: IconButton(
                              onPressed: tagsController.text == ''
                                  ? null
                                  : () {
                                      setState(() {
                                        global.addEventTags
                                            .add('#' + tagsController.text);
                                        tagsController.text = '';
                                      });
                                    },
                              icon: Icon(Icons.done_rounded)))
                    ],
                  ),
                  global.addEventTags.length == 0
                      ? Container()
                      : SizedBox(
                          height: 35,
                          child: ListView.builder(
                            padding: EdgeInsets.only(bottom: 5),
                            itemCount: global.addEventTags.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20))),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.cyan[700])),
                                    onPressed: () {},
                                    child: Text(
                                      global.addEventTags[index],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16),
                                    )),
                              );
                            },
                          ),
                        ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 10, right: 10),
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.cyan[700]),
                      alignment: Alignment.center,
                      child: IconButton(
                          onPressed: () {
                            if (nameController.text.length < 2) {
                              showMessageDialog('Enter a valid name');
                            } else if (descController.text.length < 2) {
                              showMessageDialog('Enter a valid description');
                            }else {
                              setState(() {
                                global.addEventName = nameController.text;
                                global.addEventDesc = descController.text;
                                
                              });
                              Navigator.of(context)
                                  .pushNamed(AddEventDnT.routeName);
                            }
                          },
                          icon: Icon(
                            Icons.arrow_forward_sharp,
                            color: Colors.white,
                            size: 28,
                          )),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
