import 'package:audio_transcription_app/modle/archive.dart';
import 'package:audio_transcription_app/modle/summarymodle.dart';
import 'package:audio_transcription_app/modle/textmodle.dart';

abstract class DataState {}

class InitialState extends DataState {}

class LoadingState extends DataState {}

class ErrorState extends DataState {}
class SuccessDataReceiveState extends DataState {
   List<textmodle>? text;

  SuccessDataReceiveState({required this.text});
}



class ErrorStatepdf extends DataState {}
class SuccessDataReceiveStatepdf extends DataState {
   String text;

  SuccessDataReceiveStatepdf({required this.text});
}

class ErrorStatearchive extends DataState {}
class SuccessDataReceiveStatearchive extends DataState {
   List<archive> files;

  SuccessDataReceiveStatearchive({required this.files});
}

class ErrorsummaryState extends DataState {}
class SuccesssummaryReceiveState extends DataState {
   List<summarymodle>? text;

  SuccesssummaryReceiveState({required this.text});
}