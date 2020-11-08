import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gong/bloc/blocFunction.dart';

import 'package:gong/helper/helper.dart';
import 'package:gong/screens/home.dart';
import 'package:gong/screens/presets.dart';
import 'package:gong/widgets/bottomYellowButtom.dart';
import 'package:gong/widgets/slider.dart';

import 'package:gong/widgets/style.dart';
import '../widgets/appBar.dart';

// TODO: add functionality to buttons

class EditPreset extends StatefulWidget {
  final String presetName;
  final double duration; // in minutes
  final double frequency; // in 10*seconds
  final String gongName;

  const EditPreset(
      {Key key, this.presetName, this.duration, this.frequency, this.gongName})
      : super(key: key);
  @override
  _EditPresetState createState() => _EditPresetState(
      gongName: gongName,
      presetName: presetName,
      frequency: frequency,
      duration: duration);
}

class _EditPresetState extends State<EditPreset> {
  double duration; // in minutes
  double frequency; // in 10*seconds
  String presetName;
  String gongName;
  int _selectedGong = -1;
  double statvalue;
  _EditPresetState(
      {this.duration, this.frequency, this.gongName, this.presetName});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVal();
  }

  @override
  Widget build(BuildContext context) {
    print('------aaaaaa-------');
    print(presetName);
    print(frequency);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final mainBloc = BlocProvider.of<MainBloc>(context);
    return Scaffold(
      backgroundColor: Color(0xFFF7F7FF),
      body: BlocBuilder<MainBloc, States>(builder: (context, state) {
        return SafeArea(
          child: ListView(
            children: [
              appBar("Edit Preset", "Create your own meditation",
                  "transferStatistics", context, true),
              SizedBox(height: h / 20),
              // TODO: add widgets according to design

              Container(
                margin: EdgeInsets.only(
                    left: w / 15, right: w / 10, bottom: w / 45),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Time",
                      style: mediaDescStyle2,
                    ),
                    Container(
                      width: w / 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${duration.round().toString()}",
                            style: mediaDescStyle2,
                          ),
                          SizedBox(
                            width: w / 65,
                          ),
                          Text(
                            "Min",
                            style: mediaDescLowStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: yellow,
                  showValueIndicator: ShowValueIndicator.never,
                  inactiveTrackColor: Colors.grey.withOpacity(.5),
                  trackHeight: h / 18,
                  thumbShape: CustomSliderThumbCircle(
                    thumbRadius: h / 12 * .4,
                    min: 0,
                    max: 100,
                  ),
                  overlayColor: Colors.white.withOpacity(.4),
                  activeTickMarkColor: Colors.white,
                  valueIndicatorColor: Colors.white,
                  thumbColor: Colors.white,
                  inactiveTickMarkColor: Colors.red.withOpacity(.7),
                ),
                child: Slider(
                  value: duration,
                  min: 1,
                  max: 120,
                  divisions: 120,
                  label: duration.round().toString() + "Min",
                  onChanged: (double value) {
                    setState(() {
                      duration = value.roundToDouble();
                    });
                  },
                ),
              ),
              SizedBox(
                height: h / 30,
              ),
              Container(
                margin: EdgeInsets.only(
                    left: w / 15, right: w / 10, bottom: w / 45),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Frequency",
                      style: mediaDescStyle2,
                    ),
                    Container(
                      width: w / 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Every",
                            style: mediaDescLowStyle,
                          ),
                          SizedBox(
                            width: w / 65,
                          ),
                          Text(
                            "${frequency.round().toString()}",
                            style: mediaDescStyle2,
                          ),
                          SizedBox(
                            width: w / 65,
                          ),
                          Text(
                            "Min",
                            style: mediaDescLowStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: yellow,
                  showValueIndicator: ShowValueIndicator.never,
                  inactiveTrackColor: Colors.grey.withOpacity(.5),
                  trackHeight: h / 18,
                  valueIndicatorColor: Colors.white,
                  thumbShape: CustomSliderThumbCircle(
                    thumbRadius: h / 12 * .4,
                    min: 0,
                    max: 100,
                  ),
                  overlayColor: Colors.white.withOpacity(.4),
                  activeTickMarkColor: Colors.white,
                  thumbColor: Colors.white,
                  inactiveTickMarkColor: Colors.red.withOpacity(.7),
                ),
                child: Slider(
                  value: frequency,
                  min: 1,
                  max: 120,
                  divisions: 120,
                  onChanged: (double value) {
                    print('---as-da-sd-as-d-as-d-as-dsa');
                    print(value);
                    setState(() {
                      frequency = value.roundToDouble();
                    });
                  },
                ),
              ),

              SizedBox(
                height: h / 20,
              ),
              Container(
                margin: EdgeInsets.all(w / 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Gongs",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                            fontFamily: 'Poppins')),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PresetsScreen()));
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

              FutureBuilder(
                  future: getGong(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        height: h / 10,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.keys.toList().length,
                            itemBuilder: (context, index) {
                              return buttonBar(
                                  snapshot.data.keys.toList()[index],
                                  context,
                                  index);
                            }),
                      );
                    }
                  }),
              SizedBox(height: h / 18),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: w / 3,
                  child: Center(
                      child: TextField(
                    onChanged: (val) {
                      setState(() {
                        presetName = val;
                      });
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.edit),
                        border: InputBorder.none,
                        hintText: presetName),
                  )),
                ),
              ),
              SizedBox(height: h / 70),
              Container(
                margin: EdgeInsets.only(left: w / 20, right: w / 20),
                child: bottomYellowButton("Save Preset", () async {
                  Map<String, dynamic> initialData =
                      await readcontent('presetsData.json');

                  var statsData = await readcontent('statistics.json');
                  initialData['Presets'][presetName] = {
                    "Gong": gongName,
                    "Frequency": {"val": frequency * 60, "unit": "min"},
                    "Total Time": {"val": duration * 60, "unit": "min"}
                  };

                  statsData['presetPlays'][presetName] = statvalue;

                  writeContent('statistics.json', statsData);
                  writeContent('presetsData.json', initialData);
                  mainBloc.add(UpdatePreset());
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => PresetsScreen()),
                      (Route<dynamic> route) => false);
                  /*add funcitonality here*/
                }, context),
              )
            ],
          ),
        );
      }),
    );
  }

  buttonBar(String data, context, index) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      width: w / 2.6,
      margin: EdgeInsets.all(w / 35),
      child: RaisedButton(
        padding: EdgeInsets.all(w / 25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        focusElevation: 0,
        disabledElevation: 0,
        focusColor: Colors.transparent,
        highlightElevation: 0,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        color: _selectedGong == index ? yellow : Colors.white,
        onPressed: () {
          setState(() {
            _selectedGong = index;
            gongName = data;
          });
          // set state
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/gong.png',
              color: _selectedGong != index ? Colors.black : Colors.white,
              scale: 2.5,
            ),
            SizedBox(
              width: w / 35,
            ),
            Text(
              data,
              style: TextStyle(
                  color: _selectedGong != index ? Colors.black : Colors.white,
                  fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  getVal() async {
    var data = await readcontent('statistics.json');
    statvalue = data['presetPlays'][presetName];
    data['presetPlays'].remove(presetName);
    writeContent('statistics.json', data);
    Map<String, dynamic> initialData = await readcontent('presetsData.json');
    initialData['Presets'].remove(presetName);
    writeContent('presetsData.json', initialData);
  }

  getGong() async {
    var data = await readcontent('gongData.json');
    print("0239r0-239043298092398439839840ru903");
    print(data);
    Map<String, dynamic> a = data['gongs'];
    print("0239r0-239043298092398439839840ru903");
    print(a.keys.toList().indexOf(gongName));

    _selectedGong = a.keys.toList().indexOf(gongName);

    return data['gongs'];
  }
}
