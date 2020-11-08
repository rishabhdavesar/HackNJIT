import 'package:flutter/material.dart';

/*
* This is widget is to be used for buttons in create preset, add gong page, credenital etc. 

*/

Widget bottomYellowButton(String text, void Function() onpress, BuildContext context) {
  double w = MediaQuery.of(context).size.width;
  double h = MediaQuery.of(context).size.height;
  return ButtonTheme(
    minWidth: w/1.2,
    height: h/15,
      child: RaisedButton(elevation: 0, color: Color(0xFFFEB740),onPressed: onpress,child: Text(text, style: TextStyle(fontSize: 16,
                  fontFamily: 'Poppins'),),textColor: Colors.white, shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0))),
  );
}