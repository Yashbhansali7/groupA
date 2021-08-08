import 'package:flutter/material.dart';
import 'package:job_assessment/dummydata.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../screens/swipe_screen.dart';
import '../widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _value = 0;
  String textValue = 'Slide To Match';
  bool localMode = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 90.0),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: SfSliderTheme(
                data: SfSliderThemeData(
                  activeTrackColor: Colors.white,
                  inactiveDividerStrokeWidth: 70,
                  activeDividerStrokeWidth: 70,
                  inactiveTrackHeight: 70,
                  activeTrackHeight: 70,
                  trackCornerRadius: 10,
                  inactiveTrackColor: Colors.white,
                  thumbRadius: 30,
                ),
                child: Container(
                  height: 80,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal, width: 3),
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  padding: EdgeInsets.all(0),
                  child: Stack(
                    children: [
                      SfSlider(
                        min: 0,
                        max: 1,
                        minorTicksPerInterval: 1,
                        interval: 1,
                        thumbIcon: Image.network(
                          'https://api.startupindia.gov.in/sih/api/file/user/image/Startup?fileName=5071c7a9-0248-42ae-9181-5434454f6824.png',
                        ),
                        //showLabels: true,
                        value: _value,
                        onChanged: (dynamic newValue) {
                          setState(() {
                            _value = newValue;
                            if (newValue >= 0.6) {
                              textValue = 'GroupALike';
                              Future.delayed(Duration(milliseconds: 500), () {
                                Navigator.of(context).pushReplacementNamed(
                                    SwipeScreen.routeName);
                              });
                            }
                            if (newValue == 0) textValue = 'Slide To Match';
                          });
                        },
                      ),
                      Center(
                        child: Text(
                          textValue,
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.teal,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {                          
                        localMode = true;
                        });
                      },
                      child: Text(
                        'Local Mode',
                        style: TextStyle(color: localMode? Colors.teal:Colors.grey),
                      )),
                  TextButton(
                      onPressed: () {
                        setState(() {                          
                        localMode = false;
                        });
                      },
                      child: Text('Global Mode',style: TextStyle(color: localMode?Colors.grey: Colors.teal),),),
                ],
              ),
            ),
            flex: 2,
          ),
          Expanded(
            flex: 14,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0),
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: .9,
                      crossAxisCount: 1),
                  itemCount: localMode? LOCAL_DATA.length: GLOBAL_DATA.length,
                  itemBuilder: (context, index) {
                    return PostCard(index,localMode);
                  },
                )),
          )
        ],
      ),
    ));
  }
}
