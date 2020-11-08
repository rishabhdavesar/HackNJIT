import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gong/data/gongData.dart';
import 'package:gong/data/presetData.dart';
import 'package:path_provider/path_provider.dart';
import '../main.dart';
import '../helper/helper.dart';
import '../data/statisticsData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initializeData();
    Timer(
        Duration(seconds: 1),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => MyHomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        'assets/images/Splash.jpg',
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }

  initializeData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getInt('lastDate') == null) {
      pref.setInt('lastDate', -1);
    }
    String dir = (await getExternalStorageDirectory()).path + '/sounds';
    Directory(dir).exists().then((value) {
      if (!value) {
        Directory(dir).create();
      }
    });

    var path = await localPath;
    File(path + '/presetsData.json').exists().then((value) {
      if (!value) {
        writeContent('presetsData.json', presetData);
        writeContent('gongData.json', gongData);
        writeContent('statistics.json', statisticsData);
      } else {
        readcontent('presetsData.json');
      }
    });
  }
}
