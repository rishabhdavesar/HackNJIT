import 'package:gong/helper/helper.dart';

class Repo {
  Future getPresetData() async {
    final result = await readcontent('presetsData.json');
    return result;
  }

  Future getGongData() async {
    final result = await readcontent('gongData.json');
    return result;
  }
}
