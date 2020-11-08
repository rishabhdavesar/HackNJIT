import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gong/bloc/blocFunction.dart';
import 'package:gong/helper/helper.dart';
import 'package:gong/widgets/slidableWhiteButton.dart';
import '../widgets/appBar.dart';
import 'createPreset.dart';

// TODO: add functionality to buttons

class PresetsScreen extends StatefulWidget {
  @override
  _PresetsScreenState createState() => _PresetsScreenState();
}

class _PresetsScreenState extends State<PresetsScreen> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    final mainBloc = BlocProvider.of<MainBloc>(context);
    return Scaffold(
        
        backgroundColor: Color(0xFFF7F7FF),
        body: SafeArea(
          child: Stack(
            children: [

              Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    child: appBar("Presets", "Manage your presets", "presets",
                        context, false),
                  ),
                  SizedBox(height: h / 20),
                  BlocBuilder<MainBloc, States>(builder: (context, state) {
                    if (state is AllPreset) {
                      return Expanded(
                          child: ListView.builder(
                        itemBuilder: (context, index) {
                          return slidableWhiteButtonPresets(
                              "slide actions",
                              state.data.keys.toList()[index],
                              (state.data.values
                                  .toList()[index]["Total Time"]['val']/60)
                                  .round()
                                  .toString(),
                              (state.data.values
                                  .toList()[index]["Frequency"]['val']/60)
                                  .round()
                                  .toString(),
                              state.data.values.toList()[index]['Gong'],
                              context);
                        },
                        itemCount: state.data.keys.length,
                      ));
                    } else {
                      mainBloc.add(FetchPreset());
                    }
                  }),
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
                      MaterialPageRoute(builder: (context) => CreatePresetScreen()),
                    );
                  },
                  child: Icon(Icons.add, size: 45)),
            ),
          ),
            ],
          ),
        ));
  }

  getData() async {
    var data = await readcontent('presetsData.json');
    print('------');
    print(data['Presets']);
    return data['Presets'];
  }
}
