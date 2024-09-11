import 'dart:io';

import 'package:audio_transcription_app/modle/textmodle.dart';

abstract class DataEvent {}
class SendDataEvent extends DataEvent {
  File? dir;
  String type;
  SendDataEvent({required this.dir,
 required this.type});
}

class pdfsend extends DataEvent{
  String title;
  String date;
  List<textmodle> content;
  pdfsend({required this.title,required this.date,required this.content});
}

class archiveget extends DataEvent{

}

class summary extends DataEvent{
  List<textmodle> content;
  summary({required this.content});
}