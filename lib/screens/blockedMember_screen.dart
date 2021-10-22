import 'package:flutter/material.dart';

class BlockedMemberScreen extends StatefulWidget {
  static const routeName = '/blockedMemberScreen';
  @override
  _BlockedMemberScreenState createState() => _BlockedMemberScreenState();
}

class _BlockedMemberScreenState extends State<BlockedMemberScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          enableFeedback: false,
          splashFactory: NoSplash.splashFactory,
                  onTap: Navigator.of(context).pop,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.teal,
                    size: 30,
                  ),
                ),
        elevation: 1,
        titleSpacing: 3,
        title: Text(
          'Blocked Members',
          style: TextStyle(
              fontSize: 24, color: Colors.black, fontWeight: FontWeight.w300),
        ),
        actions: [
          TextButton(
              style: ButtonStyle(
                  padding:
                      MaterialStateProperty.all(EdgeInsets.only(right: 12))),
              onPressed: () {},
              child: Text(
                'Approve all',
                style: TextStyle(color: Colors.grey),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListView.builder(
          itemCount: 6,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: ListTile(
                  title: Column(
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
                        "10 minutes ago",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                      radius: 25,
                      child: Icon(
                        Icons.person,
                        color: Colors.grey,
                        size: 30,
                      )),
                 trailing: TextButton(onPressed: (){}, child: Text('Unblock',style: TextStyle(color: Colors.cyan[700],fontSize: 18),)),
                  ),
            );
          },
        ),
      ),
    );
  }
}
