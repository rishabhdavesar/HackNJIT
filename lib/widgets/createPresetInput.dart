import 'package:flutter/material.dart';
import 'package:gong/widgets/bottomYellowButtom.dart';
import 'package:gong/helper/helper.dart';

class createPresetInput extends StatefulWidget {
  @override
  _createPresetInputState createState() => _createPresetInputState();
}

class _createPresetInputState extends State<createPresetInput> {
  double duration = 1; // in minutes
  double frequency = 10; // in 10*seconds
  String presetName = "";
  String gongName = "gong";

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Container(
        child: Column(
      children: [
        // for duration
        Slider(
          value: duration,
          min: 0,
          max: 100,
          divisions: 5,
          label: duration.round().toString() + "Min",
          onChanged: (double value) {
            setState(() {
              duration = value;
            });
          },
        ),
        // for frequency
        Slider(
          value: frequency,
          min: 0,
          max: 100,
          divisions: 5,
          label: "Every" + frequency.round().toString() + "Min",
          onChanged: (double value) {
            setState(() {
              frequency = value;
            });
          },
        ),
        SizedBox(height: h / 25),
        bottomYellowButton("Save Preset", () async {
          Map<String, dynamic> initialData =
              await readcontent('presetsData.json');
          initialData[presetName] = {
            "Gong": gongName,
            "Frequency": {"val": frequency, "unit": "min"},
            "Total Time": {"val": duration, "unit": "min"}
          };
          writeContent('presetsData.json', initialData);
          /*add funcitonality here*/
        }, context)
      ],
    ));
  }
}
