import 'package:audio_transcription_app/modle/textmodle.dart';

abstract class QuestionEvent {}
class SendDataquestionmcqEvent extends QuestionEvent {
  List<textmodle>? topics;
  SendDataquestionmcqEvent({required this.topics});
}
class SendDataquestionblankEvent extends QuestionEvent {
  List<textmodle>? topics;
  SendDataquestionblankEvent({required this.topics});
}
class SendDataquestionwhEvent extends QuestionEvent {
  List<textmodle>? topics;
  SendDataquestionwhEvent({required this.topics});
}
