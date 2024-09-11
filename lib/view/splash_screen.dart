// import 'package:audio_transcription_app/view/displaytext.dart';
import 'package:audio_transcription_app/view/main_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [ Column(children: [
                  Image.asset(
                    "assets/images/splash.jpg",
                  ),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainScreen()));
                      },
                      child: const Text("ابدء"))
                ]),
            ],
          ),
        ));
  }
}
