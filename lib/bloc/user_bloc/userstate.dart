import 'package:audio_transcription_app/modle/usermodle.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class ProcessinglogInState extends UserState{}

class SuccessedlogInState extends UserState {
  Usermodleres user;
  SuccessedlogInState({required this.user});
}

class FailduloginState extends UserState {
  String? message ;
FailduloginState({this.message});
}

class SuccessedlogoutState extends UserState{}

class FaildulogoutState extends UserState {}

class ProcessingregesturState extends UserState{}

class SuccessedregesturState extends UserState {
  Usermodleres user;
  SuccessedregesturState({required this.user});
}

class FaildregesturState extends UserState {}

