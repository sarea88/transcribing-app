import 'package:audio_transcription_app/bloc/data_bloc/databloc.dart';
import 'package:audio_transcription_app/bloc/questinos_bloc/question_bloc.dart';
import 'package:audio_transcription_app/bloc/user_bloc/userbloc.dart';
import 'package:audio_transcription_app/ui/theme.dart';
import 'package:audio_transcription_app/view/displaytext.dart';
import 'package:audio_transcription_app/view/home_screen.dart';
import 'package:audio_transcription_app/view/login_screen.dart';
import 'package:audio_transcription_app/view/main_screen.dart';
import 'package:audio_transcription_app/view/pdf_screen.dart';
import 'package:audio_transcription_app/view/singup_screen.dart';
import 'package:audio_transcription_app/view/splash_screen.dart';
import 'package:audio_transcription_app/view/summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'view/archive_screen.dart';
import 'view/question_screen.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DataBloc(),
          ),
          BlocProvider(
            create: (context) => UserBloc(),
          ),
          BlocProvider(
            create: (context) => QuestionBloc(),
          ),
        ],
        child: SafeArea(
          child: MaterialApp(
            locale: Locale('ar'),
            debugShowCheckedModeBanner: false,
            theme: theme,
            initialRoute: '/Login',
            routes: {
              '/Splash': (context) =>  SplashScreen(),
              '/main-screen': (context) =>  MainScreen(),
              '/DisplayText': (context) => DisplayText(),
              '/Home' : (context) => HomeScreen(),
              '/Login' : (context) => LoginScreen(),
              '/Singup' : (context) => SignUpScreen(),
              '/Archive' : (context) => ArchiveScreen(),
              '/Question' : (context) => QuestionsGenerationScreen(topics: [],),
              '/Summary' : (context) => SummaryScreen(text:[]),
              '/pdf': (context) => PdfViewerPage(pdfUrl: '',),
            },
          ),
        ));
  }
}
