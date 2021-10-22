import 'dart:convert';
import 'dart:io';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:intl/intl.dart';
import 'package:job_assessment/Global.dart' as global;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_assessment/groups/groupCall.dart';

import 'package:job_assessment/widgets/ownMessageCard.dart';
import 'package:job_assessment/widgets/replyCard.dart';
import 'package:permission_handler/permission_handler.dart';

class GroupChat extends StatefulWidget {
  static const routeName = 'groupChat';

  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  File? _profileImg = null;

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

  TextEditingController _controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  ScrollController _scrollController = ScrollController();
  String isAttachment = '';

  var catGroupMessageRepsonse;
  initState() {
    _generateCatMessage(global.loadMessagesGroupId);
    super.initState();
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  _generateCatMessage(id) async {
    final url =
        Uri.parse('http://65.2.117.202:5000/api/v2/groupmessages?groupId=$id');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {'x-access-token': global.token, 'sourceFrom': '25'};
    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      setState(() {
        catGroupMessageRepsonse = json.decode(res.body);
      });
      print(catGroupMessageRepsonse);
    } else {
      print(res.reasonPhrase);
      print(res.body.toString());
    }
  }

  var jsonResponse;

  getAgoraToken() async {
    final url = Uri.parse('http://65.2.117.202:5000/api/v2/agora/token');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {
      'sourceFrom': '25',
      'Content-Type': 'application/x-www-form-urlencoded',
      'x-access-token': global.token
    };
    Map body = {
      "uid": 0.toString(),
      "role": 1.toString(),
      "channelName": global.loadMessagesGroupName
    };
    var res = await http.post(url, body: body, headers: headers);

    if (res.statusCode == 200) {
      jsonResponse = json.decode(res.body);
      setState(() {
        global.agoraToken = jsonResponse['token'];
        print(global.agoraToken);
      });
      if (global.agoraToken != '') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupCall(
              channelName: global.loadMessagesGroupName,
              role: ClientRole.Broadcaster,
            ),
          ),
        );
      }
      print('Response Status: ${res.body.toString()}');
    } else {
      jsonResponse = json.decode(res.body);
      print(res.reasonPhrase);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: //leadingWidth: 30,
          PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: AppBar(
                leadingWidth: 50,
                titleSpacing: 0,
                leading: InkWell(
                  onTap: Navigator.of(context).pop,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.teal,
                    size: 30,
                  ),
                ),
                title: InkWell(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.only(top: 6),
                    child: Text(
                      global.loadMessagesGroupName,
                      style: TextStyle(
                        fontSize: 18.5,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                      icon: Icon(
                        Icons.favorite_outline,
                        color: Colors.red,
                        size: 30,
                      ),
                      onPressed: () {}),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(7),
                        margin: EdgeInsets.only(top: 5),
                        height: 40,
                        width: 90,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Search',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Icon(
                              Icons.search,
                              color: Colors.grey,
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: IconButton(
                            onPressed: () async {
                              await _handleCameraAndMic(Permission.camera);
                              await _handleCameraAndMic(Permission.microphone);

                              await getAgoraToken();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GroupCall(
                                    channelName: global.loadMessagesGroupName,
                                    role: ClientRole.Broadcaster,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.call,
                              color: Colors.cyan[800],
                              size: 30,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                barrierColor: Colors.black26,
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            25.0)), //this right here
                                    child: Container(
                                      height: 220,
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.only(
                                                  top: 3, left: 7),
                                              alignment: Alignment.centerLeft,
                                              child: GestureDetector(
                                                onTap: () =>
                                                    Navigator.of(context).pop(),
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.grey,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  //   showReportDialog();
                                                },
                                                child: Text(
                                                  'Report User',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            TextButton(
                                                onPressed: () {},
                                                child: Text(
                                                  'Block chat from this user',
                                                  style: TextStyle(
                                                      color: Colors.cyan[700],
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            TextButton(
                                                onPressed: () {},
                                                child: Text(
                                                  'Clear chat history',
                                                  style: TextStyle(
                                                      color: Colors.cyan[700],
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
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.teal,
                            size: 30,
                          ),
                        ),
                      )
                    ],
                  )
                ],
                elevation: 4,
                backgroundColor: Colors.white,
              )),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                // height: MediaQuery.of(context).size.height - 150,
                child: catGroupMessageRepsonse == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: catGroupMessageRepsonse['messages'].length,
                        itemBuilder: (context, index) {
                          if (catGroupMessageRepsonse['messages'].length == 0) {
                            return Container(
                              height: 70,
                            );
                          }
                          if (catGroupMessageRepsonse['messages'][index]['user']
                                  ['uuid'] ==
                              global.currentUserUID) {
                            return OwnMessageCard(
                              message: catGroupMessageRepsonse['messages']
                                  [index]['body'],
                              time: DateFormat.yMMMMd().format(DateTime.parse(
                                  catGroupMessageRepsonse['messages'][index]
                                          ['createdAt']
                                      .substring(0, 10))),
                              isAttach: catGroupMessageRepsonse['messages']
                                          [index]['attachment'] ==
                                      null
                                  ? ''
                                  : catGroupMessageRepsonse['messages'][index]
                                      ['attachment'],
                            );
                          } else {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black12,
                                    radius: 24,
                                    backgroundImage: catGroupMessageRepsonse[
                                                    'messages'][index]['user']
                                                ['userProfiles'][0]['image'] ==
                                            null
                                        ? null
                                        : NetworkImage(
                                            catGroupMessageRepsonse['messages']
                                                    [index]['user']
                                                ['userProfiles'][0]['image']),
                                    child: catGroupMessageRepsonse['messages']
                                                    [index]['user']
                                                ['userProfiles'][0]['image'] !=
                                            null
                                        ? null
                                        : Icon(
                                            Icons.person,
                                            color: Colors.cyan[800],
                                            size: 34,
                                          ),
                                  ),
                                ),
                                ReplyCard(
                                  message: catGroupMessageRepsonse['messages']
                                      [index]['body'],
                                  time: catGroupMessageRepsonse['messages']
                                          [index]['createdAt']
                                      .substring(11, 16),
                                  isAttach: catGroupMessageRepsonse['messages']
                                              [index]['attachment'] ==
                                          null
                                      ? ''
                                      : catGroupMessageRepsonse['messages']
                                          [index]['attachment'],
                                ),
                              ],
                            );
                          }
                        },
                      ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.red,
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 60,
                            child: Card(
                              elevation: 0,
                              margin:
                                  EdgeInsets.only(left: 4, right: 2, bottom: 8),
                              child: TextFormField(
                                controller: _controller,
                                focusNode: focusNode,
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                minLines: 1,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type Your Message Here",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  prefixIcon: IconButton(
                                    icon: Icon(
                                      Icons.photo_filter_outlined,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          barrierColor: Colors.black26,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.0)), //this right here
                                              child: Container(
                                                height: 200,
                                                width: double.infinity,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      TextButton(
                                                          onPressed: () {
                                                            _pickImg(ImageSource
                                                                .camera);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            'Take photo',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .cyan[700],
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          )),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      TextButton(
                                                          onPressed: () {
                                                            _pickImg(ImageSource
                                                                .camera);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            'Take video',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .cyan[700],
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          )),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      TextButton(
                                                          onPressed: () {
                                                            _pickImg(ImageSource
                                                                .gallery);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            'Choose from gallery',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .cyan[700],
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.mic_none_outlined,
                                      size: 30,
                                    ),
                                    onPressed: () {},
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 8,
                              right: 2,
                              left: 2,
                            ),
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: Color(0xFF128C7E),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 26,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
