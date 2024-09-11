// ignore_for_file: prefer_const_constructors
import 'package:audio_transcription_app/bloc/data_bloc/databloc.dart';
import 'package:audio_transcription_app/bloc/data_bloc/dataevent.dart';
import 'package:audio_transcription_app/bloc/data_bloc/datastate.dart';
import 'package:audio_transcription_app/modle/textmodle.dart';
import 'package:audio_transcription_app/service/service.dart';
import 'package:audio_transcription_app/ui/theme.dart';
import 'package:audio_transcription_app/view/archive_screen.dart';
import 'package:audio_transcription_app/view/pdf_screen.dart';
import 'package:audio_transcription_app/view/summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'question_screen.dart';
import 'package:intl/intl.dart' as intt;

class DisplayText extends StatefulWidget {
  const DisplayText({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DisplayTextState createState() => _DisplayTextState();
}

class _DisplayTextState extends State<DisplayText> {
  // ignore: non_constant_identifier_names
  List<String> file_type = ['file', 'url'];
  final DataSender dataSender = DataSender();
  List<textmodle?> responseList = [];
  List<TextEditingController> titleControllers = [];
  List<TextEditingController> textControllers = [];
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();

  // Function to show a dialog for inputting the title and date
  Future<void> _showInputDialog() async {
    String title = '';
    String date = '';
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ادخل التاريخ والعنوان '),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'عنوان'),
                  onChanged: (value) {
                    title = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال العنوان ';
                    }
                    
                  },
                ),
                SizedBox(height: 10),
                InkWell(
                    child: TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(labelText: 'تاريخ'),
                  onChanged: (value) {
                    value = date;
                  },
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      String formattedDate =
                          intt.DateFormat('yyyy-MM-dd').format(pickedDate);
                      setState(() {
                        _dateController.text = formattedDate;
                      });
                    }
                  },
                )),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('إلغاء'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('تأكيد'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  List<textmodle> content = _prepareContentForPDF();
                  BlocProvider.of<DataBloc>(context)
                      .add(pdfsend(title: title, date: date, content: content));
                }
              },
            ),
          ],
        );
      },
    );
  }

  List<textmodle> _prepareContentForPDF() {
    List<textmodle> contents = [];
    for (int i = 0; i < responseList.length; i++) {
      contents.add(textmodle(
        title: titleControllers[i].text,
        text: textControllers[i].text,
      ));
    }
    return contents;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataBloc, DataState>(
      builder: (BuildContext context, DataState state) {
        if (state is SuccessDataReceiveState) {
          // ignore: avoid_print
          print('Successfully received data ${state.text}');
          responseList = state.text!;
          titleControllers = responseList
              .map((e) => TextEditingController(text: e?.title))
              .toList();
          textControllers = responseList
              .map((e) => TextEditingController(text: e?.text))
              .toList();
        } else if (state is ErrorState) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //       SnackBar(content: Text('حصل خطأ ما أعد المحاولة ')),
          //     );
        } else if (state is LoadingState) {
  return const SafeArea(
    child: Scaffold(
      body: Center( // Centers the Column in the middle of the screen
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // Aligns children in the center horizontally
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20), // Adds space between the progress indicator and the text
              Text(
                'الرجاء الانتظار العملية قد تاخذ بعض الوقت',
                textAlign: TextAlign.center, // Centers the text
                style: TextStyle(
                  fontSize: 16, // You can adjust this size to make it responsive
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );


        } else if (state is SuccessDataReceiveStatepdf) {
          // ignore: avoid_print, unnecessary_string_interpolations
          print('${state.text}');
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PdfViewerPage(pdfUrl: state.text),
              ),
            );
          });
        } else if (state is ErrorStatepdf) {
          // ignore: avoid_print
          ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('حصل خطأ ما أعد المحاولة ')),
              );
          // print('errorstatepdf');
        }
        return Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.archive_outlined),
                tooltip: 'فتح الأرشيف',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ArchiveScreen()));
                  BlocProvider.of<DataBloc>(context).add(archiveget());
                },
              )
            ],
            title: const Text('النص'),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: responseList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              decoration: InputDecoration(labelText: 'عنوان'),
                              controller: titleControllers[index],
                              onChanged: (value) {
                                responseList[index]?.title = value;
                              },
                              textDirection: TextDirection.rtl,
                            ),
                            SizedBox(height: 10),
                            TextField(
                              decoration: InputDecoration(labelText: 'فقرة'),
                              controller: textControllers[index],
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              onChanged: (value) {
                                responseList[index]?.text = value;
                              },
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      surfaceTintColor: primaryColor,
                      child: InkWell(
                        onTap: () {
                          _showInputDialog();
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.picture_as_pdf_outlined,
                              color: primaryColor,
                            ),
                            Text(
                              "تحويل الى  PDF",
                              style: TextStyle(color: primaryColor),
                            )
                          ],
                        ),
                      ),
                    ),
                    Material(
                      child: InkWell(
                        onTap: () {
                          List<textmodle> topics = _prepareContentForPDF();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SummaryScreen(
                                text: topics,
                              ),
                            ),
                          );
                          BlocProvider.of<DataBloc>(context)
                              .add(summary(content: topics));
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.summarize_outlined,
                              color: primaryColor,
                            ),
                            Text(
                              "تلخيص",
                              style: TextStyle(color: primaryColor),
                            )
                          ],
                        ),
                      ),
                    ),
                    Material(
                      child: InkWell(
                        onTap: () {
                          List<textmodle> topics = _prepareContentForPDF();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  QuestionsGenerationScreen(topics: topics),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.question_answer_outlined,
                              color: primaryColor,
                            ),
                            Text(
                              "توليد أسئلة ",
                              style: TextStyle(
                                color: primaryColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
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
