import 'package:audio_transcription_app/modle/questionblank.dart';
import 'package:audio_transcription_app/modle/questionmcq.dart';
import 'package:audio_transcription_app/modle/questionwh.dart';

abstract class QuestionState {}

class InitialState extends QuestionState {}

class LoadingState extends QuestionState {}

class ErrorState extends QuestionState {}
class SuccessmcqState extends QuestionState {
   List<questionmcq>? questionmcqresponse;

  SuccessmcqState({required this.questionmcqresponse});
}

class SuccessblankState extends QuestionState {
   List<questionblank>? questionblankresponse;

  SuccessblankState({required this.questionblankresponse});
}

class SuccesswhState extends QuestionState {
   List<questionwh>? questionwhresponse;
  SuccesswhState({required this.questionwhresponse});
}