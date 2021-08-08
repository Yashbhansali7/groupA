import 'dart:async';

import './location_model.dart';
import 'package:location/location.dart';

class LocationService {
  Location location = Location();
  LocationModel currentLocation = LocationModel(0, 0);
  Future<LocationModel> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      currentLocation = LocationModel(
          userLocation.latitude!, userLocation.longitude!.toDouble());
    } catch (e) {
      print('Could not find location');
    }
    return currentLocation;
  }

  StreamController<LocationModel> locationController =
      StreamController<LocationModel>.broadcast();
  Stream<LocationModel> getStreamData() => locationController.stream;
  LocationService() {
    location.requestPermission().then((locations) {
      if (locations == PermissionStatus.granted) {
        location.onLocationChanged.listen((locValue) async {          
            locationController
                .add(LocationModel(locValue.latitude!, locValue.longitude!));
          
        });
      }
    });
  }
}
