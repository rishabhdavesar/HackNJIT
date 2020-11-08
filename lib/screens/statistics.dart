import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gong/bloc/blocFunction.dart';
import 'package:gong/screens/transferStatistics.dart';
import 'package:gong/widgets/appBar.dart';
import '../helper/helper.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int weekHighest;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final mainBloc = BlocProvider.of<MainBloc>(context);
    return BlocBuilder<MainBloc, States>(builder: (context, state) {
      return FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print('---hh--');
              return Scaffold(
                backgroundColor: Color(0xFFF7F7FF),
                body: SafeArea(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: w / 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          appBar("Statistics", "Your insights", "statistics",
                              context, false),
                          InkWell(
                            child: Image.asset(
                              'assets/images/updown.png',
                              scale: 2,
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      TransferStatisticsScreen()));
                            },
                          ),
                        ],
                      ),
                    ),

                    //TODO: display existing presests
                    Container(
                      margin: EdgeInsets.all(w / 15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircularCard(
                                minutes: getString(
                                    snapshot.data["today"].toString()),
                                title: 'Today',
                                percent: snapshot.data["today"]/100,
                                color: Color(0xffFEB740),
                              ),
                              CircularCard(
                                minutes: getString(
                                    snapshot.data["overall"].toString()),
                                title: 'Overall',
                                percent: snapshot.data["overall"]/100,
                                color: Color(0xff914204),
                              ),
                            ],
                          ),
                          SizedBox(height: h / 70),
                          //  SizedBox(height: h / 60),
                          BarChartWidget(),
                          SizedBox(height: h / 70),
                          BarChart1Widget(),
                        ],
                      ),
                    )
                  ],
                )),
              );
            } else {
              return CircularProgressIndicator();
            }
          });
    });
  }
}

class CircularCard extends StatefulWidget {
  final String minutes;
  final String title;
  final double percent;
  final Color color;
  const CircularCard(
      {Key key, this.minutes, this.title, this.percent, this.color})
      : super(key: key);
  @override
  _CircularCardState createState() => _CircularCardState();
}

class _CircularCardState extends State<CircularCard> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      width: w / 2.4,
      child: Card(
        elevation: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: h / 40,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(widget.title,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600)),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              //   height: h / 6,
              child: CircularPercentIndicator(
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Colors.grey[200],
                progressColor: widget.color,
                radius: w / 4,
                lineWidth: 6.0,
                percent: widget.percent,
                center: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.minutes,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      "Minutes",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BarChartWidget extends StatefulWidget {
  @override
  _BarChartWidgetState createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          double m = 0;
          List<dynamic> l = snapshot.data['week'].values.toList();
          for (int i = 0; i < l.length; i++) {
            if (l.elementAt(i) > m) {
              m = l.elementAt(i);
            }
          }
          return AspectRatio(
            aspectRatio: h / (w * 1.3),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: h / 40,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: w / 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'This Week',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    height: h / 5,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: m * 2,
                        barTouchData: BarTouchData(
                          enabled: false,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.transparent,
                            tooltipPadding: const EdgeInsets.all(0),
                            tooltipBottomMargin: 8,
                            getTooltipItem: (
                              BarChartGroupData group,
                              int groupIndex,
                              BarChartRodData rod,
                              int rodIndex,
                            ) {
                              return BarTooltipItem(
                                rod.y == 0 ? '' : getString(rod.y.toString()),
                                TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: SideTitles(
                            showTitles: true,
                            // textStyle: TextStyle(
                            //     color: const Color(0xFF000000),
                            //     fontWeight: FontWeight.w600,fontFamily: 'Poppins',
                            //     fontSize: 12),
                            margin: 20,
                            getTitles: (double value) {
                              switch (value.toInt()) {
                                case 1:
                                  return 'Mon';
                                case 2:
                                  return 'Tue';
                                case 3:
                                  return 'Wed';
                                case 4:
                                  return 'Thu';
                                case 5:
                                  return 'Fri';
                                case 6:
                                  return 'Sat';
                                case 7:
                                  return 'Sun';
                                default:
                                  return '';
                              }
                            },
                          ),
                          leftTitles: SideTitles(showTitles: false),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: [
                          BarChartGroupData(x: 1, barRods: [
                            BarChartRodData(
                                y: snapshot.data["week"]["Monday"],
                                colors: [Color(0xff914204)])
                          ], showingTooltipIndicators: [
                            0
                          ]),
                          BarChartGroupData(x: 2, barRods: [
                            BarChartRodData(
                                y: snapshot.data["week"]["Tuesday"],
                                colors: [Color(0xff914204)])
                          ], showingTooltipIndicators: [
                            0
                          ]),
                          BarChartGroupData(x: 3, barRods: [
                            BarChartRodData(
                                y: snapshot.data["week"]["Wednesday"],
                                colors: [Color(0xffFEB740)])
                          ], showingTooltipIndicators: [
                            0
                          ]),
                          BarChartGroupData(x: 4, barRods: [
                            BarChartRodData(
                                y: snapshot.data["week"]["Thursday"],
                                colors: [Color(0xffFEB740)])
                          ], showingTooltipIndicators: [
                            0
                          ]),
                          BarChartGroupData(x: 5, barRods: [
                            BarChartRodData(
                                y: snapshot.data["week"]["Friday"],
                                colors: [Color(0xff914204)])
                          ], showingTooltipIndicators: [
                            0
                          ]),
                          BarChartGroupData(x: 6, barRods: [
                            BarChartRodData(
                                y: snapshot.data["week"]["Saturday"],
                                colors: [Color(0xffFEB740)])
                          ], showingTooltipIndicators: [
                            0
                          ]),
                          BarChartGroupData(x: 7, barRods: [
                            BarChartRodData(
                                y: snapshot.data["week"]["Sunday"],
                                colors: [Color(0xffFEB740)])
                          ], showingTooltipIndicators: [
                            0
                          ])
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class BarChart1Widget extends StatefulWidget {
  @override
  _BarChart1WidgetState createState() => _BarChart1WidgetState();
}

class _BarChart1WidgetState extends State<BarChart1Widget> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: getTitles(),
        builder: (context, snapshot) {
          print('-------1-1--1');
          print(snapshot.data);
          if (snapshot.hasData) {
            print('-data hai bhai');
            return AspectRatio(
              aspectRatio: 1.7,
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(
                      height: h / 40,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: w / 20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Presets Used',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      height: h / 6,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: snapshot.data.keys.toList().length == 0
                              ? 0
                              : snapshot.data.values.toList().first * 2,
                          barTouchData: BarTouchData(
                            enabled: false,
                            touchTooltipData: BarTouchTooltipData(
                              tooltipBgColor: Colors.transparent,
                              tooltipPadding: const EdgeInsets.all(0),
                              tooltipBottomMargin: 8,
                              getTooltipItem: (
                                BarChartGroupData group,
                                int groupIndex,
                                BarChartRodData rod,
                                int rodIndex,
                              ) {
                                print('---222222-----');

                                print(rod.y);
                                print(rodIndex);
                                return BarTooltipItem(
                                  getString(rod.y.toString()) + 'x',
                                  TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: SideTitles(
                              showTitles: true,

                              // textStyle: TextStyle(
                              //     color: const Color(0xFF000000),
                              //     fontWeight: FontWeight.bold,fontFamily: 'Poppins',
                              //     fontSize: 11),
                              margin: 20,
                              getTitles: (double value) {
                                return snapshot.data.keys
                                    .toList()[value.toInt()];
                              },
                            ),
                            leftTitles: SideTitles(showTitles: false),
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          barGroups: getBarGroupData(snapshot.data),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            print('--i am here');
            return Container(
              child: Text('No Stats'),
            );
          }
        });
  }
}

getData() async {
  var data = await readcontent('statistics.json');
  print('------');
  print(data);

  return data;
}

getTitles() async {
  var data = await readcontent('statistics.json');
  print("-----------------111111111111111111--------------");
  List<String> keys = data['presetPlays'].keys.toList();
  keys.sort((a, b) {
    if (data['presetPlays'][a] < data['presetPlays'][b]) {
      return 1;
    } else if (data['presetPlays'][a] > data['presetPlays'][b]) {
      return -1;
    } else {
      return 0;
    }
  });
  print("-----------------22222222222222222222222222--------------");

  var result = {};
  for (int i = 0; i < min(keys.length, 3); i++) {
    result[keys[i]] = double.parse(data['presetPlays'][keys[i]].toString());
  }
  print('----gerererereer--');

  print(result);
  return result;
}

getBarGroupData(data) {
  List<BarChartGroupData> res = [];

  for (int i = 0; i < data.length; i++) {
    print(data.values.toList()[i]);
    res.add(BarChartGroupData(x: i, barRods: [
      BarChartRodData(y: data.values.toList()[i], colors: [Color(0xff914204)])
    ], showingTooltipIndicators: [
      0
    ]));
  }
  print('---======');
  print(res);
  return res;
}
