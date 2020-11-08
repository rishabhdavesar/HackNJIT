import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gong/bloc/blocFunction.dart';
import 'package:gong/helper/helper.dart';
import 'package:gong/screens/credentials.dart';
import 'package:gong/widgets/style.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'createPreset.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isplaying = false;
  String currentGong;
  int totalTime;
  int frequency;
  int currentIndex = -1;
  int tick = 0;
  Timer _timer;
  int startTime = 0;
  String currentPreset;
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final mainBloc = BlocProvider.of<MainBloc>(context);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(h / 7),
          child: Container(
            margin: EdgeInsets.all(w / 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/gong_logo.png',
                      scale: 3,
                    ),
                    Text(
                      "Rest Your Mind",
                      style: TextStyle(
                          color: Color(0xff707070),
                          fontSize: 16,
                          fontFamily: 'Poppins'),
                    )
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            CredentialsScreen()));
                  },
                  child: Image.asset(
                    'assets/images/heart.png',
                    scale: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: bgcolor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: h / 10,
            ),
            Container(
                child: Center(
              child: mediaPlayerWidget(context, mainBloc),
            )),
            Container(
              margin: EdgeInsets.all(w / 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Presets',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              CreatePresetScreen()));
                    },
                    child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: yellow.withOpacity(.15),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.add,
                              color: yellow,
                              size: 20,
                            ),
                            Text(
                              ' Add New  ',
                              style: TextStyle(color: yellow),
                            ),
                          ],
                        )),
                  )
                ],
              ),
            ),
            BlocBuilder<MainBloc, States>(builder: (context, state) {
              if (state is AllPreset) {
                return Container(
                  margin: EdgeInsets.only(left: w / 30),
                  height: h / 9,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.data.keys.toList().length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(w / 65),
                          child: RaisedButton(
                              onPressed: () {
                                print('---------------------');
                                print(state.data);
                                if (startTime != 0) {
                                  updateStats(currentPreset, startTime - tick,
                                      mainBloc);
                                }
                                setState(() {
                                  currentIndex = index;
                                  currentPreset =
                                      state.data.keys.toList()[index];
                                  currentGong = state
                                          .data[state.data.keys.toList()[index]]
                                      ['Gong'];
                                  frequency = state
                                      .data[state.data.keys.toList()[index]]
                                          ['Frequency']['val']
                                      .toInt();
                                  totalTime = state
                                      .data[state.data.keys.toList()[index]]
                                          ['Total Time']['val']
                                      .toInt();
                                  tick = totalTime;
                                  _isplaying = false;
                                  assetsAudioPlayer.stop();
                                  if (_timer != null) {
                                    _timer.cancel();
                                  }
                                });

                                startTime = totalTime;
                              },
                              color:
                                  index != currentIndex ? Colors.white : yellow,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              elevation: 0,
                              child: Text(
                                state.data.keys.toList()[index],
                                style: TextStyle(
                                    fontSize: 12,
                                    color: index != currentIndex
                                        ? Colors.black
                                        : Colors.white),
                              )),
                        );
                      }),
                );
              } else {
                mainBloc.add(FetchPreset());
              }
            })
          ],
        ),
      ),
    );
  }

  getPresetName() async {
    var data = await readcontent('presetsData.json');

    return data['Presets'];
  }

  mediaPlayerWidget(BuildContext context, mainBloc) {
    //double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return CircularPercentIndicator(
      radius: w / 1.3,
      lineWidth: 25.0,
      percent: totalTime == null ? 0 : tick / totalTime,
      center: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: w / 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(
                              'assets/images/frequently.png',
                              scale: 3,
                            )
                          ],
                        ),
                      ),
                      Text(
                        'Frequency',
                        style: mediaDescStyle,
                      ),
                      Text(
                        frequency == null
                            ? ''
                            : "Every " + (frequency/60).round().toString() + " minutes",
                        style: mediaDescLowStyle,
                      )
                    ],
                  ),
                  VerticalDivider(
                    width: 30,
                    endIndent: 4,
                    color: Colors.grey[400],
                    thickness: 2,
                    indent: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: w / 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/gong.png',
                              scale: 3,
                            )
                          ],
                        ),
                      ),
                      Text(
                        'Gong',
                        style: mediaDescStyle,
                      ),
                      Text(
                        currentGong == null ? '' : currentGong,
                        style: mediaDescLowStyle,
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: w / 25,
            ),
            Text(
              getTime(tick),
              style: mediaTimeStyle,
            ),
            Text(
              "Minutes",
              style: mediaDescLowStyle,
            ),
            SizedBox(
              height: w / 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: currentIndex == -1
                        ? () {}
                        : () async {
                            if (!_isplaying) {
                              var gongData = await readcontent('gongData.json');
                              if (tick == totalTime) {
                                if (gongData['gongs'][currentGong]['isAsset']) {
                                  assetsAudioPlayer.open(Audio(
                                      gongData['gongs'][currentGong]['path']));
                                } else {
                                  assetsAudioPlayer.open(
                                    Audio.file(
                                        gongData['gongs'][currentGong]['path']),
                                  );
                                }
                              }

                              const oneSec = const Duration(seconds: 1);
                              _timer = new Timer.periodic(
                                oneSec,
                                (Timer timer) => setState(
                                  () {
                                    tick = tick - 1;
                                    if (tick % frequency == 0) {
                                      assetsAudioPlayer.play();
                                    }
                                    if (tick == 0) {
                                      _timer.cancel();
                                      tick = totalTime;
                                      _isplaying = false;
                                    }
                                  },
                                ),
                              );
                            } else {
                              _timer.cancel();
                              assetsAudioPlayer.stop();
                              updateStats(
                                  currentPreset, startTime - tick, mainBloc);
                              startTime = tick;
                            }

                            setState(() {
                              _isplaying
                                  ? _isplaying = false
                                  : _isplaying = true;
                            });
                          },
                    child: _isplaying
                        ? Image.asset(
                            'assets/images/pause.png',
                            scale: 3,
                          )
                        : Image.asset(
                            'assets/images/play.png',
                            scale: 3,
                          )),
                SizedBox(
                  width: w / 20,
                ),
                GestureDetector(
                  child: Image.asset('assets/images/replay.png'),
                  onTap: () {
                    if (_isplaying) {
                      updateStats(currentPreset, startTime - tick, mainBloc);
                      startTime = totalTime;
                    }
                    setState(() {
                      tick = totalTime;
                      _isplaying = false;
                      _timer.cancel();
                      assetsAudioPlayer.stop();
                    });
                  },
                )
              ],
            )
          ],
        ),
      ),
      progressColor: yellow,
      backgroundColor: Colors.white,
      curve: Curves.easeIn,
      circularStrokeCap: CircularStrokeCap.round,
    );
  }
}

getTime(int tick) {
  int minutes = (tick / 60).toInt();
  int seconds = (tick % 60);

  String final_minutes =
      minutes > 9 ? minutes.toString() : '0' + minutes.toString();
  String final_seconds =
      seconds > 9 ? seconds.toString() : '0' + seconds.toString();

  return final_minutes + ':' + final_seconds;
}
