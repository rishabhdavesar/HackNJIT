import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gong/bloc/blocFunction.dart';
import 'package:gong/helper/helper.dart';
import 'package:gong/screens/pickGong.dart';
import 'package:gong/widgets/style.dart';
import 'package:path_provider/path_provider.dart';
import '../widgets/appBar.dart';
import '../widgets/slidableWhiteButton.dart';
// TODO: add functionality to buttons

class GongCollectionScreen extends StatefulWidget {
  @override
  _GongCollectionScreenState createState() => _GongCollectionScreenState();
}

class _GongCollectionScreenState extends State<GongCollectionScreen> {
  gongs() {
    return FutureBuilder(
        future: getGongs(),
        builder: (context, snapshot) {
          return Expanded(
              child: ListView.builder(
                  itemCount: snapshot.data.keys.length,
                  itemBuilder: (context, index) {
                    return slidableWhiteButton(
                      text: snapshot.data.keys.toList()[index],
                      slideActions: "slide actions",
                      leftImage: snapshot.data.values.toList()[index]
                          ['leftImage'],
                      rightImage: "assets/images/play.png",
                      gongName: snapshot.data.values.toList()[index]['path'],
                      isAsset: snapshot.data.values.toList()[index]['isAsset'],
                    );
                  }));
        });
  }

  myGongs() {
    return FutureBuilder(
        future: getGongs(),
        builder: (context, snapshot) {
          return Expanded(
              child: ListView.builder(
                  itemCount: snapshot.data.keys.length,
                  itemBuilder: (context, index) {
                    return slidableWhiteButton(
                      text: snapshot.data.keys.toList()[index],
                      slideActions: "slide actions",
                      leftImage: snapshot.data.values.toList()[index]
                          ['leftImage'],
                      rightImage: "assets/images/play.png",
                      gongName: snapshot.data.values.toList()[index]['path'],
                      isAsset: snapshot.data.values.toList()[index]['isAsset'],
                      isFav: snapshot.data.values.toList()[index]['isFav'],
                    );
                  }));
        });
  }

  myFav() {
    return FutureBuilder(
        future: getGongs(),
        builder: (context, snapshot) {
          print('-----111111');
          print(snapshot.data);
          return Expanded(
              child: ListView.builder(
                  itemCount: snapshot.data.keys.length,
                  itemBuilder: (context, index) {
                    return snapshot.data.values.toList()[index]['isFav']
                        ? slidableWhiteButton(
                            text: snapshot.data.keys.toList()[index],
                            slideActions: "slide actions",
                            leftImage: snapshot.data.values.toList()[index]
                                ['leftImage'],
                            rightImage: "assets/images/play.png",
                            gongName: snapshot.data.values.toList()[index]
                                ['path'],
                            isAsset: snapshot.data.values.toList()[index]
                                ['isAsset'],
                          )
                        : Container();
                  }));
        });
  }

  int selected = 0;

  selectCollection() {
    switch (selected) {
      case 1:
        {
          return gongs();
        }
        break;
      case 2:
        {
          return myGongs();
        }
        break;
      case 3:
        {
          return myFav();
        }
        break;

      default:
        {
          return gongs();
        }
        break;
    }
  }

  getGongs() async {
    var data = await readcontent('gongData.json');
    return data['gongs'];
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    final mainBloc = BlocProvider.of<MainBloc>(context);
    return Scaffold(
      //TODO : increase boldness of the icon

      backgroundColor: Color(0xFFF7F7FF),
      body: BlocBuilder<MainBloc, States>(builder: (context, state) {
        return SafeArea(
            child: Stack(
              children: [
                Column(
          children: [
                Container(
                    margin: EdgeInsets.all(5),
                    child: appBar("Gong Collection", "All gongs", "allGongs",
                        context, false)),
                SizedBox(height: h / 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buttonBar("Gongs", context, 1),
                    buttonBar("My Gongs", context, 2),
                    buttonBar("My Favourites", context, 3),
                  ],
                ),
                SizedBox(
                  height: h / 20,
                ),
                selectCollection(),
          ],
        ),
         Container(
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.only(right: w / 15, bottom: w / 12),
            child: SizedBox(
              width: w / 5.5,
              height: w / 5.5,
              child: FloatingActionButton(
                  backgroundColor: Color(0xFFFEB740),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PickGong()),
                    );
                  },
                  child: Icon(Icons.add, size: 45)),
            ),
          ),
              ],
            ));
      }),
    );
  }

  buttonBar(String data, context, int i) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Container(
      width: w / 3.1,
      child: RaisedButton(
        padding: EdgeInsets.all(w / 25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(38)),
        elevation: 0,
        focusElevation: 0,
        disabledElevation: 0,
        focusColor: Colors.transparent,
        highlightElevation: 0,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        color: selected == i ? lightYellow : Colors.transparent,
        onPressed: () {
          setState(() {
            selected = i;
          });
          print('yr98347r347ryuiwfhuehrfiuerhfiuerhgr');
          print(selected);
        },
        child: Text(data),
      ),
    );
  }
}
