import 'package:flutter/material.dart';
import 'package:job_assessment/chats/singleChat_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:job_assessment/Global.dart' as global;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String toke = global.token;
  Map<String, dynamic> obj = {
    'isActive': true.toString(),
    'token': global.token,
    'sourceFrom': 25.toString(),
  };

  IO.Socket socket = IO.io(
      "http://65.2.117.202:5000/",
      IO.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect() // disable auto-connection
          .build());
  connect() {
    socket.connect();
    socket.on('connect', (_) {
      print('connect');
      socket.emitWithAck('Groupalike_isActive', json.encode(obj), ack: (data) {
        print('ack $data');
        if (data != null) {
          print(data);
        } else {
          print("NULL");
        }
      }, binary: false);
    });
  }

  List<Color> clrs = [Colors.teal, Colors.red, Colors.black];
  TextEditingController editingController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 10,
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Messages',
            style: TextStyle(
                color: Colors.teal[700],
                fontSize: 40,
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: new Padding(
        padding: const EdgeInsets.only(
          top: 0.0,
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(0),
          itemCount: 3,
          itemBuilder: (context, i) {
            return Container(
                color: Colors.white,
                padding: EdgeInsets.all(0),
                //height: 400,

                width: MediaQuery.of(context).size.width,
                //  color: clrs[index],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: i == 0 ? 140 : 0,
                          ),
                          Text(
                            'Active',
                            style: TextStyle(
                                color: i == 0 ? Colors.teal : Colors.grey,
                                fontSize: i == 0 ? 18 : 16),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text('Favourite',
                              style: TextStyle(
                                  color: i == 1 ? Colors.red : Colors.grey,
                                  fontSize: i == 1 ? 18 : 16)),
                          SizedBox(
                            width: 30,
                          ),
                          Text('Expired',
                              style: TextStyle(
                                  color: i == 2 ? Colors.black : Colors.grey,
                                  fontSize: i == 2 ? 18 : 16)),
                          SizedBox(
                            width: i == 2 ? 140 : 0,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      child: ListView.builder(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                onTap: () => Navigator.of(context)
                                    .pushNamed(SingleChatScreen.routeName),
                                leading: Stack(children: [
                                  Container(
                                    width: 60.0,
                                    height: 60.0,
                                    decoration: BoxDecoration(
                                        // color: Colors.grey[100],
                                        //  image: DecorationImage(
                                        //    image: NetworkImage('http://i.imgur.com/QSev0hg.jpg'),
                                        //    fit: BoxFit.cover,
                                        //  ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        border: Border.all(color: clrs[i])),
                                  ),
                                  Positioned(
                                    left: 35,
                                    top: 32,
                                    child: Container(
                                      child: Card(
                                          margin: EdgeInsets.all(0),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          elevation: 5,
                                          child: Center(
                                              child: Text(
                                            '3',
                                            style: TextStyle(color: clrs[i]),
                                          ))),
                                      width: 25.0,
                                      height: 25.0,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        //  image: DecorationImage(
                                        //    image: NetworkImage('http://i.imgur.com/QSev0hg.jpg'),
                                        //    fit: BoxFit.cover,
                                        //  ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                    ),
                                  )
                                ]),
                                // tileColor: Colors.grey,
                                //minVerticalPadding: 10,
                                title: Text('Christine Dhuna'),
                                subtitle: Text('I know right!'),
                                trailing: Container(
                                    width: 60,
                                    alignment: Alignment.center,
                                    child: Text('4:30 PM')),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        },
                      ),
                      height: MediaQuery.of(context).size.height - 300,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.grey[50],
                          // boxShadow: [
                          //   BoxShadow(
                          //       color: Colors.black12,
                          //       spreadRadius: 1,
                          //       blurRadius: 1)
                          // ],
                          // color: Colors.lightBlueAccent,
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          socket.disconnect();
                          socket.onDisconnect((data) => print('disconnected'));
                        },
                        child: Text('Disconnect'),
                      ),
                    )
                  ],
                ));
          },
          scrollDirection: Axis.horizontal,
          physics: PageScrollPhysics(),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.send),
        onPressed: () => connect(),
      ),
    );
  }
}
