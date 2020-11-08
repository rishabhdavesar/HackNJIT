import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gong/bloc/blocFunction.dart';
import 'package:gong/data/gongData.dart';
import 'package:gong/helper/helper.dart';
import 'package:gong/screens/editPreset.dart';

import 'style.dart';

/*
* This is widget is to be used for buttons in transfer statistics page, add gong page and for gong collection 
* text : text in the button 
* onpress : the function to called on pressing the button , spans throughout the entire button
* slideactions : Icons that appear on sliding, useful for gong collection, by default it activated, give "null" as argument to deactivateb for say add gong page
* leftImage : image to the left of text mainly for gong collection
* rightImage : image to the right end for add gong and transfer statistics
*/

// TODO: the button is spanning across the entire width, it shouldn't. This needs to be fixed
// TODO: the action buttons that appear on sliding need to be resized and restyled  according to provided design

class slidableWhiteButton extends StatefulWidget {
  final text;
  final slideActions;
  final leftImage;
  final rightImage;
  final gongName;
  final isAsset;
  final isFav;
  final isMine;

  const slidableWhiteButton(
      {Key key,
      this.text,
      this.slideActions,
      this.leftImage,
      this.rightImage,
      this.gongName,
      this.isAsset,
      this.isFav,
      this.isMine})
      : super(key: key);
  @override
  _slidableWhiteButtonState createState() => _slidableWhiteButtonState();
}

class _slidableWhiteButtonState extends State<slidableWhiteButton> {
  bool _isplaying = false;
  bool isFav;

  getFavData() async {
    var data = await readcontent('gongData.json');
    print('----------------');
    print(data['gongs'][widget.text]['isFav']);
    setState(() {
      isFav = data['gongs'][widget.text]['isFav'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFavData();
  }

  final assetsAudioPlayer = AssetsAudioPlayer();
  playLocal(String location) {
    print('---------------');
    print(location);
    if (widget.isAsset) {
      assetsAudioPlayer.open(Audio(location));
    } else {
      assetsAudioPlayer.open(
        Audio.file(location),
      );
    }

    //on Audio Playing Listner
    assetsAudioPlayer.isPlaying.listen((event) {
      setState(() {
        _isplaying = true;
      });
    });
//on Audio Finished Listner
    assetsAudioPlayer.playlistAudioFinished.listen((event) {
      setState(() {
        _isplaying = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    final mainBloc = BlocProvider.of<MainBloc>(context);
    return isFav == null
        ? Container()
        : Container(
            margin: EdgeInsets.all(15),
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actions: <Widget>[
                new IconSlideAction(
                  caption: "hello",
                  icon: Icons.favorite,
                  closeOnTap: true,
                  onTap: () async {
                    var data = await readcontent('gongData.json');
                    if (isFav) {
                      data['gongs'][widget.text]['isFav'] = false;
                      setState(() {
                        isFav = false;
                      });
                    } else {
                      data['gongs'][widget.text]['isFav'] = true;
                      setState(() {
                        isFav = true;
                      });
                    }
                  },
                )
              ],
              // icon buttons that appear on sliding
              secondaryActions: widget.slideActions == "null"
                  ? []
                  : [
                      Container(
                          height: h / 10,
                          margin: EdgeInsets.only(left: 25, right: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: RaisedButton(
                            color: Colors.transparent,
                            elevation: 0,
                            onPressed: () async {
                              var data = await readcontent('gongData.json');
                              print('----asdasdasdas');
                              print(widget.gongName);
                              print(data['gongs']);
                              if (isFav) {
                                data['gongs'][widget.text]['isFav'] = false;
                                setState(() {
                                  isFav = false;
                                });
                              } else {
                                data['gongs'][widget.text]['isFav'] = true;
                                setState(() {
                                  isFav = true;
                                });
                              }
                              writeContent('gongData.json', data);
                            },
                            child: Icon(
                              Icons.favorite,
                              color: isFav ? Colors.red : Colors.grey[500],
                            ),
                          )),
                      Container(
                          height: h / 10,
                          margin: EdgeInsets.only(left: 25, right: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Card(
                            color: Colors.transparent,
                            elevation: 0,
                            child: IconButton(
                              icon: Icon(Icons.clear),
                              color: Colors.grey[500],
                              onPressed: () {
                                mainBloc.add(DeleteGong(widget.text));
                              },
                            ),
                          )),
                    ],
              actionExtentRatio: 0.25,
              child: ButtonTheme(
                minWidth: w / 3.5,
                height: h / 15,
                // button properites
                child: Card(
                    elevation: 0,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(w / 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                widget.leftImage == null
                                    ? Icon(Icons.ac_unit)
                                    : Image.asset(
                                        widget.leftImage,
                                        scale: 2.7,
                                      ),
                                SizedBox(
                                  width: w / 30,
                                ),
                                Text(
                                  widget.text,
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Poppins'),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                playLocal(widget.gongName);
                                print(_isplaying);
                              },
                              child: !_isplaying
                                  ? Image.asset(
                                      widget.rightImage,
                                      scale: 3,
                                    )
                                  : Image.asset(
                                      'assets/images/pause.png',
                                      scale: 3,
                                    ))
                        ],
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0))),
              ),
            ),
          );
  }
}

// Slidable White button for presets

Widget slidableWhiteButtonPresets(String slideActions, String presetName,
    String time, String frequency, String gongName, BuildContext context) {
  double w = MediaQuery.of(context).size.width;
  double h = MediaQuery.of(context).size.height;
  final mainBloc = BlocProvider.of<MainBloc>(context);
  return Container(
    margin: EdgeInsets.all(15),
    child: Slidable(
      actionPane: SlidableDrawerActionPane(),
      // icon buttons that appear on sliding
      closeOnScroll: true,

      secondaryActions: slideActions == "null"
          ? []
          : [
              Container(
                  height: h / 10,
                  margin: EdgeInsets.only(left: 25, right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Card(
                    color: Colors.transparent,
                    elevation: 0,
                    child: IconButton(
                      icon: Icon(
                        Icons.edit,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditPreset(
                                    presetName: presetName,
                                    gongName: gongName,
                                    duration: double.parse(time),
                                    frequency: double.parse(frequency),
                                  )),
                        );
                      },
                      color: yellow,
                    ),
                  )),
              Container(
                  height: h / 10,
                  margin: EdgeInsets.only(left: 25, right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: RaisedButton(
                    color: Colors.transparent,
                    elevation: 0,
                    onPressed: () {
                      mainBloc.add(DeletePreset(presetName));
                      slideActions = 'null';
                    },
                    child: Icon(
                      Icons.delete,
                      color: Color(0xff914204),
                    ),
                  )),
            ],
      actionExtentRatio: 0.25,
      child: ButtonTheme(
        minWidth: w / 5.5,

        height: h / 15,

        // button properites
        child: RaisedButton(
            elevation: 0,
            color: Colors.white,
            onPressed: () {},
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    presetName,
                    style: mediaDescStyle3,
                  ),
                  Text(
                    "Time",
                    style: mediaDescStyle4,
                  ),
                  Text(time),
                  Text("Min", style: mediaDescLowStyle),
                  Text("Frequency", style: mediaDescStyle4),
                  Text(
                    "1 per",
                    style: mediaDescLowStyle,
                  ),
                  Text(frequency),
                  Text(
                    "min",
                    style: mediaDescLowStyle,
                  )
                ],
              ),
            ),
            textColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0))),
      ),
    ),
  );
}
