import 'package:flutter/material.dart';
import 'package:gong/screens/home.dart';
import 'package:gong/screens/splash.dart';
import '../main.dart';
import '../screens/gongCollection.dart';
Widget appBar(String title, String subTitle, String screen,BuildContext context,bool backbutton) {
  //double h = MediaQuery.of(context).size.height;
  double w = MediaQuery.of(context).size.width;
  return Container(
    child: Row(
      children: [
        SizedBox(
          width: w / 70,
        ),
  backbutton?  IconButton(
          onPressed: () {
            if (screen == "addGong"){
              Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => GongCollectionScreen()));
            }
            else {
       Navigator.of(context).pop();
         
            }
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xffFEB740),
          ),
        ):Container(),
        SizedBox(
          width: w / 80,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  color: Color(0xffFEB740),
                  fontSize: 24,
                  fontFamily: 'Poppins'),
            ),
            Text(
              subTitle,
              style: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 16,
                  fontFamily: 'Poppins'),
            )
          ],
        ),
      ],
    ),
  );
}