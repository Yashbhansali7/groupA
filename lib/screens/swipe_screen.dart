import 'package:flutter/material.dart';
import '../appbar.dart';

class SwipeScreen extends StatelessWidget {
  static const routeName = '/swipeScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomAppbar(),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,        
      ),
      body: Center(child: ElevatedButton(onPressed:()=> Navigator.of(context).pushReplacementNamed('/'),child: Text('Back To Home'),),),
    );
  }
}
