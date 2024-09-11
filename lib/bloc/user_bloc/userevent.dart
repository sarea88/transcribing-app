import 'package:audio_transcription_app/modle/usermodle.dart';
abstract class UserEvent {}

class Loginevent extends UserEvent{
   loginreqmod user;
 Loginevent({required this.user});
}
 
 class Logoutevent extends UserEvent{
   String token;
 Logoutevent( {required this.token});
}

class regesturevent extends UserEvent{
 signupreqmod user;
regesturevent({required this.user});

}