import 'dart:io';

import 'package:audio_transcription_app/bloc/data_bloc/databloc.dart';
import 'package:audio_transcription_app/bloc/data_bloc/dataevent.dart';
import 'package:audio_transcription_app/view/displaytext.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class MainScreen extends StatelessWidget {
  MainScreen({super.key, this.picked});
  File? picked;
  // Function to pick a file
  Future<File?> pickFile() async {
    // Request necessary permissions
    await [
      Permission.storage,
    ].request();
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['mp4', 'wav'],
      );

      if (result != null) {
        // Use the picked file
        print('Picked file: ${result.files.single.path}');
        File file = File(result.files.single.path ?? '');
        return file;
      } else {
        // User canceled the picker
        print('No file selected.');
      }
    } catch (e) {
      print('An error occurred while picking the file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              sharedPreferences.setString('name', ' no name ');
              sharedPreferences.setString('email', 'no email');
              sharedPreferences.setString('token', 'no token');
              sharedPreferences.setBool('islog', false);
              sharedPreferences.setBool('isreg', false);
              Navigator.pushNamed(context,'/Login');
            },
            icon: Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(flex: 2, child: Image.asset("assets/images/main.jpg")),
          Expanded(
            child: Center(
              child: Column(
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      File? file = await pickFile();
                      picked = file;
                    },
                    icon: const Icon(Icons.file_upload_outlined),
                    label: const Text("اختر ملف "),
                  ),
                  // Display the picked file name here if needed
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (picked != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DisplayText()));
                BlocProvider.of<DataBloc>(context)
                    .add(SendDataEvent(dir: picked, type: 'file'));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('الرجاء اختيار ملف')),
                );
                print('لم يتم اختيار أي ملف');
              }
            },
            child: const Text(
              "ابدء التحويل ",
            ),
          ),
        ],
      ),
    );
  }
}
