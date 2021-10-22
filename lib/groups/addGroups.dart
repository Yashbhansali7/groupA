import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_assessment/Global.dart' as global;
import 'package:http/http.dart' as http;

class AddGroups extends StatefulWidget {
  static const routeName = 'addGroup';

  @override
  _AddGroupsState createState() => _AddGroupsState();
}

class _AddGroupsState extends State<AddGroups> {
  File? _profileImg = null;

  int _radioSelected = 1;
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  TextEditingController memberController = TextEditingController();
  TextEditingController inviteEmailController = TextEditingController();

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

  initState() {
    _getInterests();
    super.initState();
  }

  var memberResponse;
  onchangedMember(String name) async {
    final url =
        Uri.parse('http://65.2.117.202:5000/api/v2/findMember?referCode=$name');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {'x-access-token': global.token, 'sourceFrom': '25'};
    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      setState(() {
        controller.add('ok');
        memberResponse = json.decode(res.body);
      });
    } else {
      print(res.reasonPhrase);
      print(res.body.toString());
    }
  }

  StreamController<String> controller = StreamController<String>.broadcast();
  showAddMemberDialog() {
    showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, ss) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)), //this right here
              child: Container(
                height: 380,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(top: 3, right: 7),
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(() {
                              memberController.text = '';
                            });
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 30,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            controller: memberController,
                            style: TextStyle(fontSize: 22),
                            onChanged: (abc) => onchangedMember(abc),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                                counterText: '',
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 15),
                                labelText: 'Search by Member username',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                border: InputBorder.none,
                                labelStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                          height: WidgetsBinding
                                      .instance!.window.viewInsets.bottom ==
                                  0
                              ? 220
                              : 300,
                          child: memberResponse == null
                              ? Container()
                              : StreamBuilder(
                                  stream: controller.stream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    return ListView.builder(
                                      itemCount:
                                          memberResponse['members'].length,
                                      itemBuilder: (context, i) {
                                        String bro = memberResponse['members']
                                            [i]['referCode'];
                                        return snapshot.hasData
                                            ? Card(
                                                elevation: 4,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                                child: ListTile(
                                                    onTap: () {
                                                      setState(() {
                                                        if (global
                                                            .addGroupMember
                                                            .contains(bro)) {
                                                          ss(() {
                                                            global
                                                                .addGroupMember
                                                                .remove(bro);
                                                          });
                                                        } else {
                                                          ss(() {
                                                            global
                                                                .addGroupMember
                                                                .add(memberResponse[
                                                                        'members'][i]
                                                                    [
                                                                    'referCode']);
                                                          });
                                                        }
                                                        print(global
                                                            .addGroupMember);
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    leading: CircleAvatar(
                                                        backgroundImage: memberResponse['members'][i]
                                                                        ['userProfiles'][0]
                                                                    ['image'] ==
                                                                null
                                                            ? null
                                                            : NetworkImage(
                                                                memberResponse['members'][i]
                                                                        ['userProfiles'][0]
                                                                    ['image']),
                                                        child: memberResponse['members']
                                                                            [i]
                                                                        ['userProfiles'][0]
                                                                    ['image'] ==
                                                                null
                                                            ? Icon(Icons.person)
                                                            : null),
                                                    subtitle: Text(memberResponse['members'][i]['referCode']),
                                                    title: Text(memberResponse['members'][i]['name'])),
                                              )
                                            : Container();
                                      },
                                    );
                                  }))
                    ],
                  ),
                ),
              ),
            );
          });
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
              child: Container(
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
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 20),
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
                                foregroundColor: global.addGroupInterest
                                        .contains(bro)
                                    ? MaterialStateProperty.all(
                                        Colors.cyan[800])
                                    : MaterialStateProperty.all(Colors.grey),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: global.addGroupInterest
                                                  .contains(bro)
                                              ? Colors.teal
                                              : Colors.white,
                                          width: 2)),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (global.addGroupInterest.contains(bro)) {
                                    ss(() {
                                      global.addGroupInterest.remove(bro);
                                    });
                                  } else {
                                    if (global.addGroupInterest.length >= 1) {
                                      Navigator.of(context).pop();
                                    }
                                    ss(() {
                                      global.addGroupInterest
                                          .add(response['interest'][i]['name']);
                                    });
                                  }
                                  print(global.addGroupInterest);
                                });
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  response['interest'][i]['gimage'] == null
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
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
                                        color: global.addGroupInterest
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

  var createResponse;
  _createGroups() async {
    final url = Uri.parse('http://65.2.117.202:5000/api/v2/agora/token');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {
      'sourceFrom': '25',
      'Content-Type': 'application/x-www-form-urlencoded',
      'x-access-token': global.token
    };

    Map body = {
      "sourceLatitude": global.lat.toString(),
      "sourceLongitude": global.long.toString(),
      "groupName": global.addGroupName,
      "description": global.addGroupDesc,
      "memberList": global.addGroupMember.toString(),
      "emailList": global.addGroupMemberEmail.toString(),
      "interestList": global.addGroupInterest.toString(),
      "tagList": global.addGroupTags.toString(),
      "isPublic":
          global.addGroupType == '1' ? true.toString() : false.toString()
    };

    var res = await http.post(url, body: body, headers: headers);

    if (res.statusCode == 200) {
      createResponse = json.decode(res.body);
      showValidationDialog('Group Created Successfully');
      print(createResponse);
      setState(() {
        global.addGroupName = '';
        global.addGroupDesc = '';
        global.addGroupMember = [];
        global.addGroupMemberEmail = [];
        global.addGroupInterest = [];
        global.addGroupTags = [];
        global.addGroupType = '1';
      });
    } else {
      createResponse = json.decode(res.body);
      print(res.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 40,
            color: Colors.cyan[700],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 30, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 15, bottom: 15),
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.grey[100],
                        backgroundImage: _profileImg == null
                            ? null
                            : FileImage(_profileImg!),
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
                                                    fontWeight:
                                                        FontWeight.w400),
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
                      'Name',
                      style: TextStyle(
                          color: Colors.cyan[700],
                          fontSize: 19,
                          fontWeight: FontWeight.w400),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 5, right: 20, bottom: 10),
                      padding: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        // maxLength: maxLength,
                        controller: nameController..text = global.addGroupName,
                        onEditingComplete: () {
                          setState(() {
                            global.addGroupName = nameController.text;
                          });
                          FocusScope.of(context).unfocus();
                        },
                        keyboardType: TextInputType.name,
                        style: TextStyle(fontSize: 21),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            counterText: '',
                            //prefix: Text(''),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            labelText: 'Group Name',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            // border: InputBorder.none,
                            labelStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400)),
                      ),
                    ),
                    Text(
                      'Description',
                      style: TextStyle(
                          color: Colors.cyan[700],
                          fontSize: 19,
                          fontWeight: FontWeight.w400),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 15, right: 20, bottom: 10),
                      padding: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        minLines: 1,
                        controller: descController..text = global.addGroupDesc,
                        onEditingComplete: () {
                          setState(() {
                            global.addGroupDesc = descController.text;
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
                      'Select Group Type',
                      style: TextStyle(
                          color: Colors.cyan[700],
                          fontSize: 19,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Public',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.w400),
                        ),
                        Radio(
                          value: 1,
                          groupValue: _radioSelected,
                          activeColor: Colors.cyan[700],
                          onChanged: (int? value) {
                            setState(() {
                              _radioSelected = value!;
                              global.addGroupType = '1';
                            });
                          },
                        ),
                        Text(
                          'Private',
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.w400),
                        ),
                        Radio(
                          value: 2,
                          groupValue: _radioSelected,
                          activeColor: Colors.cyan[700],
                          onChanged: (int? value) {
                            setState(() {
                              _radioSelected = value!;
                              global.addGroupType = '2';
                            });
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Select Interest',
                      style: TextStyle(
                          color: Colors.cyan[700],
                          fontSize: 19,
                          fontWeight: FontWeight.w400),
                    ),
                    GestureDetector(
                      onTap: global.addGroupInterest.length == 0 ||
                              global.addGroupInterest.length == 1
                          ? () {
                              showInterestDialog();
                            }
                          : () {},
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 20, bottom: 10, right: 30),
                        //padding: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                          'Select any two Interest',
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        )),
                      ),
                    ),
                    global.addGroupInterest.length == 0
                        ? Container()
                        : SizedBox(
                            height: 50,
                            child: ListView.builder(
                              padding: EdgeInsets.only(bottom: 5),
                              itemCount: global.addGroupInterest.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 10, top: 10),
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 10)),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20))),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.cyan[700])),
                                      onPressed: () {
                                        setState(() {
                                          global.addGroupInterest
                                              .removeAt(index);
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            global.addGroupInterest[index],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Icon(Icons.close, size: 18)
                                        ],
                                      )),
                                );
                              },
                            ),
                          ),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width - 120,
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
                                    fontSize: 18,
                                    color: Colors.cyan[700],
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        CircleAvatar(
                            backgroundColor: tagsController.text == ''
                                ? Colors.grey[300]
                                : Colors.teal[300],
                            child: IconButton(
                                onPressed: tagsController.text == ''
                                    ? null
                                    : () {
                                        setState(() {
                                          global.addGroupTags
                                              .add('#' + tagsController.text);
                                          tagsController.text = '';
                                        });
                                      },
                                icon: Icon(Icons.done_rounded,
                                    color: tagsController.text == ''
                                        ? Colors.black
                                        : Colors.white)))
                      ],
                    ),
                    global.addGroupTags.length == 0
                        ? Container()
                        : SizedBox(
                            height: 40,
                            child: ListView.builder(
                              padding: EdgeInsets.only(bottom: 5),
                              itemCount: global.addGroupTags.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 10)),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20))),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.cyan[700])),
                                      onPressed: () {
                                        setState(() {
                                          global.addGroupTags.removeAt(index);
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            global.addGroupTags[index],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Icon(Icons.close, size: 18)
                                        ],
                                      )),
                                );
                              },
                            ),
                          ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Add Member',
                      style: TextStyle(
                          color: Colors.cyan[700],
                          fontSize: 19,
                          fontWeight: FontWeight.w400),
                    ),
                    GestureDetector(
                      onTap: () {
                        showAddMemberDialog();
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 20, bottom: 10, right: 30),
                        //padding: EdgeInsets.only(bottom: 10),
                        child: Center(
                            child: Text(
                          'Invite members Username',
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        )),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    global.addGroupMember.length == 0
                        ? Container()
                        : SizedBox(
                            height: 50,
                            child: ListView.builder(
                              padding: EdgeInsets.only(bottom: 5),
                              itemCount: global.addGroupMember.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 10, top: 10),
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 10)),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20))),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.black54)),
                                      onPressed: () {
                                        setState(() {
                                          global.addGroupMember.removeAt(index);
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            global.addGroupMember[index],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Icon(Icons.close, size: 18)
                                        ],
                                      )),
                                );
                              },
                            ),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 100,
                          alignment: Alignment.center,
                          height: 50,
                          margin:
                              EdgeInsets.only(top: 10, bottom: 10, right: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            controller: inviteEmailController,
                            style: TextStyle(
                              fontSize: 22,
                            ),
                            //  onChanged: (abc) => onchangedMember(abc),
                            textAlignVertical: TextAlignVertical.center,
                            //textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                counterText: '',
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 15),
                                labelText: 'Invite members Email',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                border: InputBorder.none,
                                labelStyle: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16)),
                          ),
                        ),
                        CircleAvatar(
                            backgroundColor: inviteEmailController.text == ''
                                ? Colors.grey[300]
                                : Colors.teal[300],
                            child: IconButton(
                                onPressed: inviteEmailController.text == ''
                                    ? null
                                    : () {
                                        if (!inviteEmailController.text
                                            .endsWith('.com')) {
                                          showValidationDialog(
                                              'Enter correct email address');
                                        } else {
                                          setState(() {
                                            global.addGroupMemberEmail.add(
                                                inviteEmailController.text);
                                            inviteEmailController.text = '';
                                          });
                                        }
                                      },
                                icon: Icon(Icons.done_rounded,
                                    color: inviteEmailController.text == ''
                                        ? Colors.black
                                        : Colors.white)))
                      ],
                    ),
                    global.addGroupMemberEmail.length == 0
                        ? Container()
                        : SizedBox(
                            height: 40,
                            child: ListView.builder(
                              padding: EdgeInsets.only(bottom: 5),
                              itemCount: global.addGroupMemberEmail.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 10)),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20))),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.black54)),
                                      onPressed: () {
                                        setState(() {
                                          global.addGroupMemberEmail
                                              .removeAt(index);
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            global.addGroupMemberEmail[index],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Icon(Icons.close, size: 18)
                                        ],
                                      )),
                                );
                              },
                            ),
                          ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(right: 30, top: 20, bottom: 10),
                        child: TextButton(
                            child: Text(
                              'Create',
                              style: TextStyle(
                                color: Colors.cyan[700],
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onPressed: () {
                              if (global.addGroupName == '')
                                showValidationDialog('Please enter your name');
                              else if (global.addGroupMember == [] &&
                                  global.addGroupMemberEmail == [])
                                showValidationDialog(
                                    'Please add members to this group');
                              else if (global.addGroupInterest == [] ||
                                  global.addGroupInterest.length == 1)
                                showValidationDialog(
                                    'Please select at least 2 interest');
                              else if (global.addGroupTags == [])
                                showValidationDialog(
                                    'Please give tag to the group');
                              else {
                                _createGroups();
                              }
                            }),
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                  color: Colors.black12)
                            ],
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                          right: 30,
                        ),
                        child: Text('-10 points')),
                  ],
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    right: 0,
                  ),
                  child: Text(
                      'Group will be deleted in 24 hours if number of users are less than three.',
                      style: TextStyle(fontSize: 12))),
            ],
          ),
        ),
      ),
    );
  }
}
