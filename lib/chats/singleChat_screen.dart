import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_assessment/models/message_model.dart';
import 'package:job_assessment/widgets/ownMessageCard.dart';
import 'package:job_assessment/widgets/replyCard.dart';

class SingleChatScreen extends StatefulWidget {
  static const routeName = '/singleChatScreen';
  @override
  _SingleChatScreenState createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends State<SingleChatScreen> {
  @override
  Widget build(BuildContext context) {
    File? _profileImg = null;
    showReportDialog() {
      showDialog(
          barrierColor: Colors.black26,
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)), //this right here
              child: Container(
                height: 220,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(top: 3, left: 7),
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 30,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: null,
                        child: Text(
                          'Why are you reporting?',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            'It\'s a Spam',
                            style: TextStyle(
                                color: Colors.cyan[700],
                                fontSize: 20,
                                fontWeight: FontWeight.w400),
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            'It\'s Inappropriate',
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

    showInappDialog() {
      showDialog(
          barrierColor: Colors.black26,
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)), //this right here
              child: Container(
                height: 420,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(top: 3, left: 7),
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 30,
                          ),
                        ),
                      ),
                      Expanded(child: ListView.builder(
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          return Card();
                        },
                      ))
                    ],
                  ),
                ),
              ),
            );
          });
    }

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
    List<MessageModel> messages = [
      MessageModel(type: 'source', message: 'Hello Yash', time: '18:30'),
      MessageModel(
          type: 'x',
          message: 'Hellooooooooooooooooooooooooooooo',
          time: '18:30')
    ];
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Person Name',
                          style: TextStyle(
                            fontSize: 18.5,
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          "Online 10 minutes ago",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
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
                      Container(
                        height: 45,
                        width: 45,
                        margin: EdgeInsets.only(left: 8, right: 2),
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(25)),
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
                                                  showReportDialog();
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
                child: ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: messages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == messages.length) {
                      return Container(
                        height: 70,
                      );
                    }
                    if (messages[index].type == "source") {
                      return OwnMessageCard(
                        message: messages[index].message,
                        time: messages[index].time,
                        isAttach: '',
                      );
                    } else {
                      return ReplyCard(
                        message: messages[index].message,
                        time: messages[index].time,
                        isAttach: '',
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
                            //color: Colors.red,
                            width: MediaQuery.of(context).size.width - 60,
                            child: Card(
                              elevation: 0,
                              margin:
                                  EdgeInsets.only(left: 4, right: 2, bottom: 8),
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(25),
                              // ),
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
