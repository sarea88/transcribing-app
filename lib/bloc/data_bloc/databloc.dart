// data_bloc.dart
import 'package:audio_transcription_app/bloc/data_bloc/dataevent.dart';
import 'package:audio_transcription_app/bloc/data_bloc/datastate.dart';
import 'package:audio_transcription_app/modle/archive.dart';
import 'package:audio_transcription_app/modle/summarymodle.dart';
import 'package:audio_transcription_app/modle/textmodle.dart';
import 'package:audio_transcription_app/service/service.dart';
import 'package:bloc/bloc.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc() : super(InitialState()) {
    on<SendDataEvent>(((event, emit) async {
      emit(LoadingState());
      List<textmodle>? response =
          await dataserver.sendData(dir: event.dir, type: 'file');
      // ignore: unnecessary_null_comparison
      response != null
          ? emit(SuccessDataReceiveState(text: response))
          : emit(ErrorState());
    }));
    on<pdfsend>(((event, emit) async {
      emit(LoadingState());
      String? response =
          await dataserver.pdf(title: event.title, date: event.date,content: event.content);
      // ignore: unnecessary_null_comparison
      response != null
          ? emit(SuccessDataReceiveStatepdf(text: response))
          : emit(ErrorStatepdf());
    }));
    on<archiveget>(((event, emit) async {
      emit(LoadingState());
      List<archive>? response =
          await dataserver.archiveget();
      response != null
          ? emit(SuccessDataReceiveStatearchive(files: response))
          : emit(ErrorStatepdf());
    }));
    on<summary>(((event, emit) async {
      emit(LoadingState());
      List<summarymodle>? response =
          await dataserver.summary(content: event.content);
      response != null
          ? emit(SuccesssummaryReceiveState(text: response))
          : emit(ErrorsummaryState());
    }));
  }
  DataSender dataserver = DataSender();
}
