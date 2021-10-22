import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:job_assessment/Global.dart' as global;

class DiscoverScreen extends StatefulWidget {
  final List mainCatsName;
  final List mainCatsId;
  DiscoverScreen(this.mainCatsName, this.mainCatsId);

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String switchMode = 'Discover';
  bool finalCatmode = false;
  var groupId;
  var groupName;
  var subGroupId;
  var subGroupName;
  List subCatsName = [];
  List subCatsId = [];
  var finalGroupId;
  var finalGroupName;
  List finalCatsName = [];
  List finalCatsId = [];

  _generateSubCats( groupId) async {
    final url = Uri.parse(
        'http://65.2.117.202:5000/api/v2/subCategories?groupId=$groupId');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {'x-access-token': global.token, 'sourceFrom': '25'};
    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      setState(() {
        switchMode = 'mainCategory';
      });
      print('hello');
      var jsonResponse;
      jsonResponse = json.decode(res.body);
      print('Response Status: ${res.body.toString()}');
      print(jsonResponse);
      for (int a = 0; a < jsonResponse.length; a++) {
        subCatsName.add(jsonResponse[a]['name']);
        subCatsId.add(jsonResponse[a]['id']);
      }
    } else {
      print(res.reasonPhrase);
      print(res.body.toString());
    }
  }

  _generateSubSubCats( subGroupId) async {
    final url = Uri.parse(
        'http://65.2.117.202:5000/api/v2/subCategories?groupId=$subGroupId');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {'x-access-token': global.token, 'sourceFrom': '25'};
    var res = await http.get(url, headers: headers);
    if (res.statusCode == 200) {
      setState(() {
        finalCatmode = true;
      });
      var jsonResponse;
      jsonResponse = json.decode(res.body);
      // print('Response Status: ${res.statusCode}');
      print('Response Status: ${res.body.toString()}');
      print(jsonResponse);

      for (int a = 0; a < jsonResponse.length; a++) {
        finalCatsName.add(jsonResponse[a]['name']);
        finalCatsId.add(jsonResponse[a]['id']);
      }
    } else {
      print(finalGroupId);
      print(res.reasonPhrase);
      print(res.body.toString());
    }
  }

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
          child: Text('Discover',style: TextStyle(color: Colors.teal[700],fontSize: 40,fontWeight: FontWeight.w400),),
        ),
      ),
      body: switchMode == 'Discover'
          ? Column(          
              children: [
                Flexible(
                    fit: FlexFit.tight,
                    flex: 2,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Top level categories',
                            style: TextStyle(
                                color: Colors.cyan[600],
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 100.0),
                            child: Text('Select one to get started',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                )),
                          ),
                          
                        ],
                      ),
                      color: Colors.white,
                    )),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 10,
                  child: Container(
                    //margin: EdgeInsets.only(bottom: 100),
                    child: ListView.builder(
                      //  physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(1),
                      itemCount: widget.mainCatsName.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 3),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  groupId = widget.mainCatsId[index];
                                  groupName = widget.mainCatsName[index];
                                });
                                _generateSubCats(groupId);
                              },
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 6),
                              horizontalTitleGap: 6,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('298'),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Icon(Icons.people),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text('12'),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Icon(Icons.calendar_today),
                                  SizedBox(
                                    width: 8,
                                  ),
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              leading: Icon(
                                Icons.sports,
                                size: 35,
                                color: Colors.blue,
                              ),
                              title: Text(
                                widget.mainCatsName[index],
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontSize: 16),
                              ),
                              tileColor: Colors.white,
                              minVerticalPadding: 6,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Flexible(
                    fit: FlexFit.tight,
                    flex: 2,
                    child: Container(
                        margin: EdgeInsets.only(top: 5,bottom: 20),
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.cyan[600]),
                        height: 50,
                        width: 350,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              elevation: MaterialStateProperty.all(0)),
                          onPressed: () {},
                          child: Text(
                            'Suggest a new top level category',
                            style: TextStyle(fontSize: 18),
                          ),
                        )))
              ],
            )
          : Column(
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                finalCatmode
                                    ? groupName + ' > ' + subGroupName
                                    : groupName + ' >',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.cyan[700]),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: GestureDetector(
                                child: Text(
                                  '<',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.cyan[700]),
                                ),
                                onTap: () {
                                  finalCatmode
                                      ? setState(() {
                                          finalCatmode = false;
                                          finalCatsName.clear();
                                          finalCatsId.clear();
                                        })
                                      : setState(() {
                                          switchMode = 'Discover';
                                          subCatsName.clear();
                                          subCatsId.clear();
                                        });
                                },
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height:  180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(color: Colors.grey, blurRadius: 5)
                              ]),
                          margin: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          padding: EdgeInsets.only(top: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.panorama,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      finalCatmode ? subGroupName : groupName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20),
                                    ),
                                  ],
                                )),
                                Divider(
                                  color: Colors.grey[400],
                                ),
                                Text('Conversations',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.cyan[700])),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text('Events',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.cyan[700])),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: finalCatmode
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 100.0),
                                      child: Text('Select one to get started',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                          )),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sub-Categories',
                                      style: TextStyle(
                                          color: Colors.cyan[700],
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 100.0),
                                      child: Text('Select one to get started',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                          )),
                                    ),
                                  ],
                                ),
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  fit: FlexFit.tight,
                  flex: 9,
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(left: 30, right: 30, top: 0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(color: Colors.grey, blurRadius: 5)
                        ]),
                    child: ListView.builder(
                      //  physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(1),
                      itemCount: finalCatmode
                          ? finalCatsName.length
                          : subCatsName.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              onTap: finalCatmode
                                  ? () {
                                      setState(() {
                                        finalGroupId = finalCatsId[index];
                                        finalGroupName = finalCatsName[index];
                                      });
                                      print('Success you selected $finalGroupId $finalGroupName');
                                    }
                                  : () {
                                      setState(() {
                                        subGroupId = subCatsId[index];
                                        subGroupName = subCatsName[index];
                                      });
                                      _generateSubSubCats( subGroupId);
                                    },
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              horizontalTitleGap: 0,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('298'),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Icon(Icons.people),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text('12'),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Icon(Icons.calendar_today),
                                  SizedBox(
                                    width: 8,
                                  ),
                                ],
                              ),
                              title: Text(
                               finalCatmode? finalCatsName[index]:subCatsName[index],
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.cyan[700],
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  fit: FlexFit.tight,
                  flex: finalCatmode ? 4 : 3,
                ),
                Flexible(
                  child: Container(
                      margin: EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.cyan[600]),
                      height: 50,
                      width: 350,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            elevation: MaterialStateProperty.all(0)),
                        onPressed: () {},
                        child: Text(
                          finalCatmode? 'Suggest a new $subGroupName sub-category':'Suggest a new $groupName sub-category',
                          style: TextStyle(fontSize: 15),
                        ),
                      )),
                  fit: FlexFit.tight,
                  flex: 2,
                ),
              ],
            ),
    );
  }
}
