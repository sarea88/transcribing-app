import 'dart:io';

import 'package:audio_transcription_app/bloc/data_bloc/databloc.dart';
// import 'package:audio_transcription_app/bloc/dataevent.dart';
import 'package:audio_transcription_app/bloc/data_bloc/datastate.dart';
import 'package:audio_transcription_app/modle/archive.dart';
import 'package:audio_transcription_app/ui/theme.dart';
import 'package:audio_transcription_app/view/pdf_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  _ArchiveScreenState createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  List<archive> files = [];

  @override
  void initState() {
    super.initState();
    // You can initialize files here if needed
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataBloc, DataState>(
      builder: (BuildContext context, DataState state) {
        if (state is SuccessDataReceiveStatearchive) {
          print('Successfully received data ${state.files}');
          files = state.files;
        } else if (state is LoadingState) {
          return const SafeArea(
            child: Scaffold(
              body: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (state is ErrorStatearchive) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('there is something wrong')),
          );
        }
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("الأرشيف"),
          ),
          body: Column(
            children: [
              Expanded(
                child: Image.asset("assets/images/main.jpg")),
              Expanded(
                flex: 2,
                child: ListView(
                  children: [
                    ...files.map((e) => Container(
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PdfViewerPage(
                                    pdfUrl: e.fileLocation!,
                                  ),
                                ),
                              );
                            },
                            tileColor: primaryColor.withOpacity(0.05),
                            title: Text(e.fileName ?? ''),
                            trailing: IconButton(
                              icon: const Icon(Icons.download_outlined),
                              onPressed: () {
                                Future<void> _downloadPdf() async {
                                  final status =
                                      await Permission.storage.request();
                                  if (status.isGranted) {
                                    final response = await http.get(Uri.parse(
                                        'http://192.168.137.93:8000${e.fileLocation}'));
                                    final bytes = response.bodyBytes;
                                    final dir =
                                        await getExternalStorageDirectory();
                                    final file = File(
                                        '${dir!.path}/${e.fileName}downloaded.pdf');
                                    await file.writeAsBytes(bytes, flush: true);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'PDF downloaded to ${file.path}')),
                                    );
                                  } else {
                                    // Handle permission denied
                                  }
                                }

                                _downloadPdf();
                              },
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
