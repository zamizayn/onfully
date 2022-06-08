import 'package:ecom_app/helper/constants.dart';
import 'package:flutter/material.dart';

class ShowLocationOnMap extends StatefulWidget {
  const ShowLocationOnMap({Key? key}) : super(key: key);

  @override
  _ShowLocationOnMapState createState() => _ShowLocationOnMapState();
}

class _ShowLocationOnMapState extends State<ShowLocationOnMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: deviceWidth * responsiveMargin()),
          child: SingleChildScrollView(
            child: Column(
              children: [
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
