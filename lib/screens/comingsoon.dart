import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/helper/customwidgets.dart';
import 'package:flutter/material.dart';

class ComingSoon extends StatefulWidget {
  const ComingSoon({Key? key}) : super(key: key);

  @override
  _ComingSoonState createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: appBarContent("UNDER CONSTRUCTION"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
             // customHeader(context, "UNDER CONSTRUCTION"),
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Text("COMING SOON"),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
