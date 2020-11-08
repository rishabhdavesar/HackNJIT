import 'package:bloc/bloc.dart';
import '../helper/helper.dart';
import 'package:equatable/equatable.dart';
import './repo.dart';

//Events

class Events extends Equatable {
  @override
  List<Object> get props => [];
}

//Preset Events
class FetchPreset extends Events {}

class DeletePreset extends Events {
  final presetName;

  DeletePreset(this.presetName);
  @override
  List<Object> get props => [presetName];
}

class UpdateStats extends Events {
  @override
  List<Object> get props => [];
}

class UpdatePreset extends Events {
  @override
  List<Object> get props => [];
}

class AddPreset extends Events {
  final gongName;
  final presetName;
  final frequency;
  final totalTime;

  AddPreset(this.gongName, this.presetName, this.frequency, this.totalTime);

  @override
  List<Object> get props => [gongName, presetName, frequency, totalTime];
}

//Gong Events
class FetchGong extends Events {}

class DeleteGong extends Events {
  final gongName;

  DeleteGong(this.gongName);
  @override
  List<Object> get props => [gongName];
}

class AddGong extends Events {}

//States

class States extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends States {}

class AllPreset extends States {
  final data;
  AllPreset(this.data);
  @override
  List<Object> get props => [data];
}

class PresetUpdated extends States {
  @override
  List<Object> get props => [];
}

class AllGongs extends States {
  final data;
  AllGongs(this.data);
  @override
  List<Object> get props => [data];
}

class GongDeleted extends States {}

class StatsUpdated extends States {}

class MainBloc extends Bloc<Events, States> {
  final Repo repo;
  MainBloc(this.repo) : super(InitialState());

  @override
  Stream<States> mapEventToState(Events event) async* {
    if (event is FetchPreset) {
      var presetData = await repo.getPresetData();
      yield AllPreset(presetData['Presets']);
    } else if (event is DeletePreset) {
      var presetData = await repo.getPresetData();
      presetData['Presets'].remove(event.presetName);
      await writeContent('presetsData.json', presetData);

      yield AllPreset(presetData['Presets']);
    } else if (event is AddPreset) {
      var presetData = await repo.getPresetData();
      presetData['Presets'][event.presetName] = {
        "Gong": event.gongName,
        "Frequency": {"val": event.frequency, "unit": "min"},
        "Total Time": {"val": event.totalTime, "unit": "min"}
      };
      await writeContent('presetsData.json', presetData);
      yield AllPreset(presetData['Presets']);
    } else if (event is FetchGong) {
      var gongData = await repo.getGongData();
      print('---here----');
      print(gongData['gongs']);
      yield AllGongs(gongData['gongs']);
    } else if (event is DeleteGong) {
      var gongData = await repo.getGongData();
      gongData['gongs'].remove(event.gongName);
      writeContent('gongData.json', gongData);
      print('---here----');
      print(event.gongName);
      yield GongDeleted();
    } else if (event is UpdateStats) {
      yield StatsUpdated();
    } else if (event is UpdatePreset) {
      yield PresetUpdated();
    }
  }
}
