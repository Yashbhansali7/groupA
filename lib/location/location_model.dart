import 'package:flutter/material.dart';

class LocationModel with ChangeNotifier {
  final double latitude;
  final double longitude;
  LocationModel(this.latitude,this.longitude);   
}

