import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import '../widgets/appBar.dart';
import '../widgets/bottomYellowButtom.dart';

class CredentialsScreen extends StatefulWidget {
  @override
  _CredentialsScreenState createState() => _CredentialsScreenState();
}

class _CredentialsScreenState extends State<CredentialsScreen> {
 final InAppReview _inAppReview = InAppReview.instance;
  String _appStoreId = '';
  bool _isAvailable;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Platform.isIOS || Platform.isMacOS) {
        _inAppReview.isAvailable().then((bool isAvailable) {
          setState(() {
            _isAvailable = isAvailable;
          });
        });
      } else {
        setState(() {
          _isAvailable = false;
        });
      }
    });
  }

  void _setAppStoreId(String id) => _appStoreId = id; //write the play/appstore id here

  Future<void> _requestReview() => _inAppReview.requestReview();

  Future<void> _openStoreListing() =>
      _inAppReview.openStoreListing(appStoreId: _appStoreId); //use this function to open play/appstore listing


  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
  double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFF7F7FF),
      body: SafeArea(child: Column(children: [
        appBar( "Credentials","An app by Thinkaholic","credentials",context,true),
        SizedBox(height: h/20),
        Container(
          padding: EdgeInsets.all(16.0),
          height: h/1.6,
          width: w/1.2,
          decoration: BoxDecoration(borderRadius:BorderRadius.circular(5),color: Colors.white,),
          
          child: SingleChildScrollView(
                      child: Text(
              "Hi there! \n We hope you like the app and that it creates \n some peace and tranquility in your life. \n\nWe are Thinkaholic, a Dutch IT company. \nOur vision is not to be the biggest player in\nthe game, but to let people live more freely\nand consciously through technology.\n\nInstead of reinvesting our profit to make\nmore money, we invest it in useful apps\nlike Gong.\n\nIf you want to support us, please leave a\nreview in the App Store.\n\nWe are continuously improving the app.\n\nIf you have tips or found a bug, please\nsend us an email at develop@thinkaholic.nl.\nHave a calm day,\n\nTeam Thinkaholic",
              style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Poppins')
              ),
          ),
        ),
        SizedBox(height: h/20),
        bottomYellowButton("Write a review", (){
          _requestReview();
        }, context)
      ],)
      ),
    );
  }
}