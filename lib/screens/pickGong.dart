import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gong/helper/helper.dart';
import 'package:gong/screens/gongCollection.dart';
import 'package:gong/widgets/appBar.dart';
import 'package:gong/widgets/bottomYellowButtom.dart';
import 'package:gong/widgets/style.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PickGong extends StatefulWidget {
  @override
  _PickGongState createState() => _PickGongState();
}

class _PickGongState extends State<PickGong> {
  String gongName;

  bool isMine = true;
  var bytes;
  bool _isplaying = false;
  String pickedGongPath;
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  Timer _timer;
  int tick = 0;
  int totalDuration;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF7F7FF),
        body: SingleChildScrollView(
          child: Column(
            children: [
              appBar(
                  "Add Gong", "Add your own sound", "allGongs", context, true),
              Container(
                height: h / 15,
                margin: EdgeInsets.all(w / 25),
                padding: EdgeInsets.only(left: w / 55),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: TextField(
                  decoration: InputDecoration(
                      hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          color: Colors.grey[700]),
                      hintText: "Gong name",
                      border: InputBorder.none),
                  onChanged: (val) {
                    gongName = val;
                  },
                ),
              ),
              InkWell(
                onTap: () async {
                  FilePickerResult result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['mp3'],
                      withData: true);
                  var b = result.files.first.bytes;

                  setState(() {
                    bytes = b;
                    pickedGongPath = result.files.first.path;
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: h / 15,
                  margin: EdgeInsets.all(w / 25),
                  padding: EdgeInsets.only(left: w / 55, right: w / 55),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select gong',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            color: Colors.grey[700]),
                      ),
                      Icon(
                        Icons.upload_sharp,
                        color: yellow,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(w / 25),
                // padding: EdgeInsets.only(left: w / 55),
                height: h / 2.3,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Center(
                  child: CircularPercentIndicator(
                    progressColor: yellow,
                    backgroundColor: Colors.grey[50],
                    curve: Curves.easeIn,
                    circularStrokeCap: CircularStrokeCap.round,
                    radius: w / 2,
                    lineWidth: 12.0,
                    percent: totalDuration == null
                        ? 0
                        : tick / totalDuration > 1 ? 1 : tick / totalDuration,
                    center: Center(
                      child: InkWell(
                        child: _isplaying
                            ? Container(
                                height: w / 8,
                                width: w / 8,
                                child: Image.asset('assets/images/pause.png',
                                    fit: BoxFit.contain))
                            : Container(
                                height: w / 8,
                                width: w / 8,
                                child: Image.asset('assets/images/play.png',
                                    fit: BoxFit.contain)),
                        onTap: pickedGongPath == null
                            ? () {}
                            : () {
                                if (_isplaying == false) {
                                  setState(() {
                                    _isplaying = true;
                                  });
                                  assetsAudioPlayer
                                      .open(Audio.file(pickedGongPath));
                                  assetsAudioPlayer.current.listen((event) {
                                    if (event != null) {
                                      print('----0--');

                                      totalDuration =
                                          event.audio.duration.inSeconds;
                                    }
                                  });
                                  const oneSec = const Duration(seconds: 1);
                                  _timer = new Timer.periodic(
                                    oneSec,
                                    (Timer timer) => setState(
                                      () {
                                        tick = tick + 1;
                                        _isplaying = true;
                                        if (tick > totalDuration) {
                                          _timer.cancel();
                                          tick = 0;
                                          _isplaying = false;
                                        }
                                      },
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    _timer.cancel();
                                    _isplaying = false;
                                    tick = 0;
                                    assetsAudioPlayer.stop();
                                  });
                                }
                              },
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: h / 30,
              ),
              bottomYellowButton("Save Gong", () async {
                String dir = (await getExternalStorageDirectory()).path +
                    '/sounds/' +
                    gongName +
                    '.mp3';

                File gongFile = File(dir);
                gongFile.writeAsBytes(bytes);
                var data = await readcontent('gongData.json');
                data['gongs'][gongName] = {
                  'path': dir,
                  'isMine': isMine,
                  'leftImage': null,
                  'isAsset': false,
                  'isFav': false
                };
                await writeContent('gongData.json', data);
                print(data);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => GongCollectionScreen()),
                    (Route<dynamic> route) => false);
              }, context),
            ],
          ),
        ),
      ),
    );
  }
}
