import 'package:flutter/material.dart';

class CustomizeUserProfile extends StatefulWidget {
  static const routeName = 'customizeUserProfile';

  @override
  _CustomizeUserProfileState createState() => _CustomizeUserProfileState();
}

List<bool> _isOpen = [false, false, false, false, false, false];
bool showMessagePublic=true;
bool showMutualGroupPublic=true;
bool showFeedbackPublic=true;
bool showReviewsPublic=true;
bool showTripPublic=true;
bool showOnlinePublic=true;
bool showMessageGlobal=true;
bool showMutualGroupGlobal=true;
bool showFeedbackGlobal=true;
bool showReviewsGlobal=true;
bool showTripGlobal=true;


Container heading(String data) {
  return Container(
    //   width: double.infinity,
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Text(data,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black87,
          letterSpacing: .6,
          fontWeight: FontWeight.w400,
          
        )),
  );
}
Container subHeading(String data) {
  return Container(
    //   width: double.infinity,
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),
    child: Text(data,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
          letterSpacing: .6,
          fontWeight: FontWeight.w400,          
        )),
  );
}



class _CustomizeUserProfileState extends State<CustomizeUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: Navigator.of(context).pop,
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.teal,
            size: 28,
          ),
        ),
        elevation: 0,
        titleSpacing: 3,
        title: Text(
          'Customize Profile',
          style: TextStyle(
              fontSize: 22, color: Colors.black, fontWeight: FontWeight.w300),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ExpansionPanelList(
            expandedHeaderPadding: EdgeInsets.symmetric(vertical: 6),
            elevation: 0,
            dividerColor: Colors.white,
            expansionCallback: (panelIndex, isExpanded) {
              setState(() {
                _isOpen = [false, false, false, false, false, false];
                _isOpen[panelIndex] = !isExpanded;
              });
            },
            children: [              
              ExpansionPanel(                
                  isExpanded: _isOpen[0],
                  canTapOnHeader: true,
                  headerBuilder: (context, isExpanded) {
                    return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),padding: EdgeInsets.only(left:5),child: Text('Show message button',style: TextStyle(color: Colors.cyan[700],fontSize: 20 ),),alignment: Alignment.centerLeft,);
                  },
                  body: Column(
                    children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      heading('Public Users'),
                       Switch(
                        value: showMessagePublic,
                        onChanged: (value) {
                          setState(() {
                            showMessagePublic = value;
                            print(showMessagePublic);
                          });
                        },
                        activeTrackColor: Colors.grey[300],
                        activeColor: Colors.cyan[600],
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ],),
                    subHeading('Any Groupalike user can send you a direct messages'),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      heading('Global Members'),
                       Switch(
                        value: showMessageGlobal,
                        onChanged: (value) {
                          setState(() {
                            showMessageGlobal = value;
                            print(showMessageGlobal);
                          });
                        },
                        activeTrackColor: Colors.grey[300],
                        activeColor: Colors.cyan[600],
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ],),
                    subHeading('Group members can send you a direct messages')
                    ],
                  )),
              ExpansionPanel(
                canTapOnHeader: true,
                  isExpanded: _isOpen[1],
                  headerBuilder: (context, isExpanded) {
                    return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),padding: EdgeInsets.only(left:5),child: Text('Show mutual group button',style: TextStyle(color: Colors.cyan[700],fontSize: 20 ),),alignment: Alignment.centerLeft,);
                  },
                  body: Column(
                    children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      heading('Public Users'),
                       Switch(
                        value: showMutualGroupPublic,
                        onChanged: (value) {
                          setState(() {
                            showMutualGroupPublic = value;
                            print(showMutualGroupPublic);
                          });
                        },
                        activeTrackColor: Colors.grey[300],
                        activeColor: Colors.cyan[600],
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ],),
                    subHeading('Any groupalike user can see mutual groups between them and you.'),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      heading('Global Members'),
                       Switch(
                        value: showMutualGroupGlobal,
                        onChanged: (value) {
                          setState(() {
                            showMutualGroupGlobal = value;
                            print(showMutualGroupGlobal);
                          });
                        },
                        activeTrackColor: Colors.grey[300],
                        activeColor: Colors.cyan[600],
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ],),
                    subHeading('Group members can see mutual groups between them and you.')
                    ],
                  )),
              ExpansionPanel(
                canTapOnHeader: true,
                  isExpanded: _isOpen[2],
                  headerBuilder: (context, isExpanded) {
                    return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),padding: EdgeInsets.only(left:5),child: Text('Show feedback tab',style: TextStyle(color: Colors.cyan[700],fontSize: 20 ),),alignment: Alignment.centerLeft,);
                  },
                  body: Column(
                    children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      heading('Public Users'),
                       Switch(
                        value: showFeedbackPublic,
                        onChanged: (value) {
                          setState(() {
                            showFeedbackPublic = value;
                            print(showFeedbackPublic);
                          });
                        },
                        activeTrackColor: Colors.grey[300],
                        activeColor: Colors.cyan[600],
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ],),
                    subHeading('Allow public users to see the feedback section on your profile.'),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      heading('Global Members'),
                       Switch(
                        value: showFeedbackGlobal,
                        onChanged: (value) {
                          setState(() {
                            showFeedbackGlobal = value;
                            print(showFeedbackGlobal);
                          });
                        },
                        activeTrackColor: Colors.grey[300],
                        activeColor: Colors.cyan[600],
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ],),
                    subHeading('Group members will always be able to see feedback section on your profile.')
                    ],
                  )),
              ExpansionPanel(
                canTapOnHeader: true,
                  isExpanded: _isOpen[3],
                  headerBuilder: (context, isExpanded) {
                    return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),padding: EdgeInsets.only(left:5),child: Text('Show reviews tab',style: TextStyle(color: Colors.cyan[700],fontSize: 20 ),),alignment: Alignment.centerLeft,);
                  },
                  body: Column(
                    children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      heading('Public Users'),
                       Switch(
                        value: showReviewsPublic,
                        onChanged: (value) {
                          setState(() {
                            showReviewsPublic = value;
                            print(showReviewsPublic);
                          });
                        },
                        activeTrackColor: Colors.grey[300],
                        activeColor: Colors.cyan[600],
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ],),
                    subHeading('Public users can see the reviews section on your profile.'),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      heading('Global Members'),
                       Switch(
                        value: showReviewsGlobal,
                        onChanged: (value) {
                          setState(() {
                            showReviewsGlobal = value;
                            print(showReviewsGlobal);
                          });
                        },
                        activeTrackColor: Colors.grey[300],
                        activeColor: Colors.cyan[600],
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ],),
                    subHeading('Group members can see the reviews section on your profile.'),
                    subHeading('(If you disable this, you\'ll also not be able to see the reviews section on your group members profile.)')
                    ],
                  )),
              ExpansionPanel(
                canTapOnHeader: true,
                  isExpanded: _isOpen[4],
                  headerBuilder: (context, isExpanded) {
                    return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),padding: EdgeInsets.only(left:5),child: Text('Show trip tab',style: TextStyle(color: Colors.cyan[700],fontSize: 20 ),),alignment: Alignment.centerLeft,);
                  },
                  body: Column(
                    children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      heading('Public Users'),
                       Switch(
                        value: showTripPublic,
                        onChanged: (value) {
                          setState(() {
                            showTripPublic = value;
                            print(showTripPublic);
                          });
                        },
                        activeTrackColor: Colors.grey[300],
                        activeColor: Colors.cyan[600],
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ],),
                    subHeading('Public users can see the trip section on your profile.'),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      heading('Global Members'),
                       Switch(
                        value: showTripGlobal,
                        onChanged: (value) {
                          setState(() {
                            showTripGlobal = value;
                            print(showTripGlobal);
                          });
                        },
                        activeTrackColor: Colors.grey[300],
                        activeColor: Colors.cyan[600],
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ],),
                    subHeading('Group members can see the trips section on your profile.'),
                    subHeading('(If you disable this, you\'ll also not be able to see the trips section on your group members profile)')
                    ],
                  )),
              ExpansionPanel(
                canTapOnHeader: true,
                  isExpanded: _isOpen[5],
                  headerBuilder: (context, isExpanded) {
                    return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),padding: EdgeInsets.only(left:5),child: Text('Show online status',style: TextStyle(color: Colors.cyan[700],fontSize: 20 ),),alignment: Alignment.centerLeft,);
                  },
                  body: Column(
                    children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      heading('Public Users'),
                       Switch(
                        value: showOnlinePublic,
                        onChanged: (value) {
                          setState(() {
                            showOnlinePublic = value;
                            print(showOnlinePublic);
                          });
                        },
                        activeTrackColor: Colors.grey[300],
                        activeColor: Colors.cyan[600],
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ],),
                    subHeading('Any Groupalike user can see your online availability.'),                    
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
