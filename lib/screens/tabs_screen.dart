import 'package:flutter/material.dart';
import 'package:job_assessment/chats/chat_screen.dart';
import 'package:job_assessment/screens/discover_screen.dart';
import 'package:http/http.dart' as http;
import 'package:job_assessment/groups/groups_screen.dart';
import 'dart:convert';

import '../events/event_screen.dart';
import '../screens/home_screen.dart';
import 'package:job_assessment/Global.dart' as global;
//import '../screens/people_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/TabScreen';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

List<String> mainCatsName = [];
List mainCatsId = [];

class _TabsScreenState extends State<TabsScreen> {
  final List<Widget> _pages = [
    HomeScreen(),
    DiscoverScreen(mainCatsName, mainCatsId),
    GroupsScreen(),
    ChatScreen(),
    EventScreen()
  ];
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 0), () async {
      if(mainCatsName.length==0){
      final url = Uri.parse('http://65.2.117.202:5000/api/v2/topCategories');
      // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var headers = {'x-access-token': global.token, 'sourceFrom': '25'};
      var res = await http.get(url, headers: headers);
      if (res.statusCode == 200) {
        print('hello');
        var jsonResponse;
        jsonResponse = json.decode(res.body);
        // print('Response Status: ${res.statusCode}');
        print('Response Status: ${res.body.toString()}');
        print(jsonResponse.length);
        
        for (int a = 0; a < jsonResponse.length; a++) {
          mainCatsName.add(jsonResponse[a]['name']);
          mainCatsId.add(jsonResponse[a]['groupId']);
        }
        
        print(mainCatsName);
        print(mainCatsId);
      } else {
        print(global.token);
        print(res.reasonPhrase);
        print(res.body.toString());
      }
    }});
    
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        onTap: _selectPage,
        backgroundColor: Colors.grey[100],
        unselectedItemColor: Colors.black26,
        selectedItemColor: Colors.teal[300],
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: 40,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.explore,
              size: 40,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people_outline,
              size: 40,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message_outlined,
              size: 40,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today_outlined,
              size: 37,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
