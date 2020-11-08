

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gong/widgets/style.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import '../widgets/appBar.dart';
import '../helper/helper.dart';

// TODO: add functionality to buttons

class TransferStatisticsScreen extends StatefulWidget {
  @override
  _TransferStatisticsScreenState createState() =>
      _TransferStatisticsScreenState();
}

class _TransferStatisticsScreenState extends State<TransferStatisticsScreen> {
   Future<void> shareFile() async {
  
       final directory = await getApplicationDocumentsDirectory();
             Share.shareFiles(['${directory.path}/statistics.json'], text: 'Great picture');
  
  
  }
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFF7F7FF),
      body: SafeArea(
          child: Column(
        children: [
          appBar("Transfer Statistics", "Don't lose your data",
              "transferStatistics", context, true),
          SizedBox(height: h / 20),
          InkWell(
            onTap: ()  {
              shareFile();
            },
            child: Container(
              alignment: Alignment.centerLeft,
              height: h / 15,
              width: w,
              margin: EdgeInsets.all(w / 25),
              padding: EdgeInsets.only(left: w / 55),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Text(
                "Export statistics",
                style: mediaDescStyle3,
              ),
            ),
          ),
          InkWell(
            
            onTap: () async
            {
              FilePickerResult result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['json'],
                        withData: false);
                        var data  = await readcontent(
                          result.files.first.path
                        );
                        writeContent(
                          'statistics.json' , data
                        );


            },
                      child: Container(
              alignment: Alignment.centerLeft,
              height: h / 15,
              width: w,
              margin: EdgeInsets.all(w / 25),
              padding: EdgeInsets.only(left: w / 55),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Import statistics",
                    style: mediaDescStyle3,
                  ),
                  Icon(
                    Icons.upload_sharp,
                    color: yellow,
                  )
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
