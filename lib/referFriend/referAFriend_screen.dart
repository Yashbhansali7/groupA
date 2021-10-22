import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ReferAFriendContact extends StatefulWidget {
  static const routeName = '/referAFriendContact';
  @override
  _ReferAFriendContactState createState() => _ReferAFriendContactState();
}

class _ReferAFriendContactState extends State<ReferAFriendContact> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;
  List<String> selectedContacts = [];
  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission()) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts();
      setState(() => _contacts = contacts);
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
              'Select Contacts',
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w300),
            ),
            actions: [
              IconButton(
                padding: EdgeInsets.all(0),
                  icon: Icon(
                    Icons.search,
                    size: 30,
                    color: Colors.teal,
                  ),
                  onPressed: () {}),
              selectedContacts.length == 0
                  ? Container()
                  : Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 10),
                      child: Text('Done',
                        style: TextStyle(color: Colors.teal,fontSize: 18,)
                      ),
                    )
            ],
          ),
          body: _body(),),);

  Widget _body() {
    if (_permissionDenied) return Center(child: Text('Permission denied'));
    if (_contacts == null) return Center(child: CircularProgressIndicator());
    return Column(
      children: [
        Container(),
        Expanded(
          child: ListView.builder(
              itemCount: _contacts!.length,
              itemBuilder: (context, i) => ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(_contacts![i].displayName),
                  trailing: selectedContacts.contains(_contacts![i].id)
                      ? Icon(
                          Icons.done,
                          color: Colors.green,
                        )
                      : Text(
                          'Tap to Refer',
                          style: TextStyle(color: Colors.grey),
                        ),
                  onTap: () {
                    setState(() {
                      if (selectedContacts.contains(_contacts![i].id)) {
                        selectedContacts.remove(_contacts![i].id);
                      } else {
                        selectedContacts.add(_contacts![i].id);
                      }
                    });
                    
                    print(selectedContacts);
                    
                  })),
        ),
      ],
    );
  }
}

