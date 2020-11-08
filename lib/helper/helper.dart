import 'dart:convert';
import 'dart:io';
import 'package:gong/bloc/blocFunction.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  // For your reference print the AppDoc directory
  print(directory.path);
  return directory.path;
}

Future<File> localFile(String filename) async {
  final path = await localPath;
  return File('$path/' + filename);
}

writeContent(filename, data) async {
  final file = await localFile(filename);
  // Write the file
  file.writeAsStringSync(json.encode(data));
}

readcontent(filename) async {
  final file = await localFile(filename);
  // Read the file
  var data = await file.readAsString();
  var a = json.decode(data);
  return a;
}

updateStats(presetName, time, bloc) async {
  time = time / 60;
  var data = await readcontent('statistics.json');
  print('--------ststast');
  print(data);
  SharedPreferences pref = await SharedPreferences.getInstance();
  int lastDate = pref.getInt('lastDate');

  DateTime currDate = DateTime.now();

  if (currDate.day != lastDate) {
    data['today'] = 0;
    pref.setInt('lastDate', currDate.day);
    lastDate = currDate.day;

    if (currDate.weekday == 1) {
      data['week'] = {
        "Monday": 0.0,
        "Tuesday": 0.0,
        "Wednesday": 0.0,
        "Thursday": 0.0,
        "Friday": 0.0,
        "Saturday": 0.0,
        "Sunday": 0.0
      };
    }
  }
  print('====');
  print(data);
  data['today'] = data['today'] + time;
  data['overall'] += time;
  data['week'][data['week'].keys.toList()[currDate.weekday - 1]] += time;
  print(presetName);
  print('sssvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvss');
  if (data['presetPlays'][presetName] == null) {
    data['presetPlays'][presetName] = 0;
  }
  data['presetPlays'][presetName] += time;

  print(data);
  writeContent('statistics.json', data);
  bloc.add(UpdateStats());
}

getString(String data) {
  print('--------------');
  print(data.split('.'));
  if (!data.contains('.')) {
    return data;
  }
  String result = data.split('.')[0] + '.';
  if (data.split('.')[1].length < 3) {
    result += data.split('.')[1];
  } else {
    result += data.split('.')[1].substring(0, 2);
  }
  return result;
}
