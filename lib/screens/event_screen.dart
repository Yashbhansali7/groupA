import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../location/location_model.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
    bool showLocationBool = false;
  @override
  Widget build(BuildContext context) {
    var locationModel = Provider.of<LocationModel>(context);
    int curLat = locationModel.latitude.round();
    int curLong = locationModel.longitude.round();
    return Scaffold(
      body:  showLocationBool ?  Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Your current Latitude is $curLat'),
          Text('Your current Longitude is $curLong'),
        ],
      ): Center(child: Text('Hello'),),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          setState(() {
            showLocationBool = !showLocationBool;
          });
        } ,
        label: Text(showLocationBool?'Hide Location ': 'Get Location'),
      ),
    );
  }
  

}
