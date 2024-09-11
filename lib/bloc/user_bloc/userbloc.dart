import 'package:audio_transcription_app/service/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audio_transcription_app/bloc/user_bloc/userevent.dart';
import 'package:audio_transcription_app/bloc/user_bloc/userstate.dart';
import 'package:audio_transcription_app/modle/usermodle.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  bool ? islog ;
   bool ?isreg ;
  UserBloc() : super(UserInitial()) {
    on<Loginevent>((event, emit) async {
      try {
        
        emit(ProcessinglogInState());
        Usermodleres? userlog = await userser.authUser(event.user);
        userlog == null
            ? emit(FailduloginState())
            : {emit(SuccessedlogInState(user: userlog)), islog = true,isreg=true};

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('name', ' ${userlog?.name}');
        sharedPreferences.setString('email', '${userlog?.email}');
        sharedPreferences.setString('token', '${userlog?.apiToken}');
        sharedPreferences.setBool('islog', islog!);
         sharedPreferences.setBool('isreg', isreg!);
         print(userlog?.apiToken);
      } catch (e) {
        emit(FailduloginState(message: e.toString()));
      }
    });

    on<Logoutevent>((event, emit) async {
      bool? logout = await userser.logout(event.token);
      logout == true
          ? {emit(SuccessedlogoutState()), emit(UserInitial())}
          : emit(FaildulogoutState());

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('name', ' no name ');
      sharedPreferences.setString('email', 'no email');
      sharedPreferences.setString('token', 'no token');
      sharedPreferences.setInt('iduser', 0);
      sharedPreferences.setBool('islog', false);
      sharedPreferences.setBool('isreg', false);
    });
    on<regesturevent>((event, emit) async {
    try{
      
      emit(ProcessingregesturState());
      Usermodleres? userreg = await userser.regesUser(event.user);
        userreg == null
            ? emit(FaildregesturState())
            : {emit(SuccessedregesturState(user: userreg)), islog = false, isreg=true};
                SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('name', ' ${userreg?.name}');
        sharedPreferences.setString('email', '${userreg?.email}');
        // sharedPreferences.setString('token', '${userreg?.apiToken}');
        sharedPreferences.setString('phone_number', '${userreg?.phoneNumber}');
        sharedPreferences.setBool('islog', islog!);
        sharedPreferences.setBool('isreg', isreg!);
    }catch(e){
      print(e);
    }
            

    });
  }

  userserv userser = userserv();
}
