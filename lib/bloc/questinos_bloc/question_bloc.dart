// data_bloc.dart
import 'package:audio_transcription_app/bloc/questinos_bloc/question_event.dart';
import 'package:audio_transcription_app/bloc/questinos_bloc/question_state.dart';
import 'package:audio_transcription_app/modle/questionblank.dart';
import 'package:audio_transcription_app/modle/questionmcq.dart';
import 'package:audio_transcription_app/modle/questionwh.dart';
import 'package:audio_transcription_app/service/questions_service.dart';
import 'package:bloc/bloc.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  QuestionBloc() : super(InitialState()) {
    on<SendDataquestionmcqEvent>(((event, emit) async {
      emit(LoadingState());
      List<questionmcq>? response =
          await dataserver.question_mcq_get(topics: event.topics);
      // ignore: unnecessary_null_comparison
      response != null
          ? emit(SuccessmcqState(questionmcqresponse: response))
          : emit(ErrorState());
    }));
    on<SendDataquestionblankEvent>(((event, emit) async {
      emit(LoadingState());
      List<questionblank>? response =
          await dataserver.question_blank_get(topics: event.topics);
      // ignore: unnecessary_null_comparison
      response != null
          ? emit(SuccessblankState(questionblankresponse: response))
          : emit(ErrorState());
    }));
    on<SendDataquestionwhEvent>(((event, emit) async {
      emit(LoadingState());
      List<questionwh>? response =
          await dataserver.question_wh_get(topics: event.topics);
      response != null
          ? emit(SuccesswhState(questionwhresponse: response))
          : emit(ErrorState());
    }));
  }
  questionserv dataserver = questionserv();
}
