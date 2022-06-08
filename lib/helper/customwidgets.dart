import 'package:ecom_app/helper/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final TextInputType inputType;
  final List<TextInputFormatter> formatters;
  final TextEditingController controller;
  final bool isEnabled;

  CustomTextField(
      {required this.hint,
      required this.inputType,
      required this.formatters,
      required this.controller,
      required this.isEnabled});
  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: TextField(
        keyboardType: widget.inputType,
        controller: widget.controller,
        inputFormatters: widget.formatters,
        enabled: widget.isEnabled,
        decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            labelText: widget.hint,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            disabledBorder: InputBorder.none,
            labelStyle: TextStyle(color: purple),
            // hintText: widget.hint,
            alignLabelWithHint: true,
            hintStyle: TextStyle(fontSize: 14),
            contentPadding: EdgeInsets.all(10)),
      ),
    );
  }
}

Container customHeader(BuildContext context, String text) {
  return Container(
    height: 60,
    color: Colors.white,
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 2),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        Text(
          text,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

 Container showIndicator(BuildContext context) {
    return Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: purple,
                        ),
                      ),
                    );
  }
  MaterialStateProperty<RoundedRectangleBorder> materialShape =
    MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10.0),
));

  void navigate(Widget widget, BuildContext context) {
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(builder: (context) => widget),

  // );
  Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => widget,
        transitionDuration: Duration(milliseconds: 0),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
      ));
}


void getLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: Neumorphic(
          child: Container(
            height: 200,
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/onfully.png",
                  height: 40,
                ),
                SizedBox(
                  height: 15,
                ),
                new CircularProgressIndicator(
                  color: purple,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Loading , Please Wait...",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

class CustomIcon extends StatefulWidget {
  final Icon icon;
  CustomIcon({required this.icon});

  @override
  _CustomIconState createState() => _CustomIconState();
}

class _CustomIconState extends State<CustomIcon> {
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: widget.icon,
      ),
    );
  }
}
