import 'package:audio_transcription_app/bloc/data_bloc/databloc.dart';
import 'package:audio_transcription_app/bloc/data_bloc/dataevent.dart';
import 'package:audio_transcription_app/modle/summarymodle.dart';
import 'package:audio_transcription_app/modle/textmodle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' as intt;
import '../bloc/data_bloc/datastate.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key, required this.text});
  final List<textmodle> text;
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}
class _SummaryScreenState extends State<SummaryScreen>{
    final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
    Future<void> _showInputDialog() async {
    String title = '';
    String date = '';
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ادخل التاريخ والعنوان'),
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
                      return 'الرجاء إدخال العنوان';
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
  List<summarymodle?> responseList = [];
  List<TextEditingController> titleControllers = [];
  List<TextEditingController> textControllers = [];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataBloc, DataState>(
      builder: (BuildContext context, DataState state) {
        if (state is SuccesssummaryReceiveState) {
          // ignore: avoid_print
          print('Successfully received data ${state.text}');
          responseList = state.text!;
          titleControllers = responseList
              .map((e) => TextEditingController(text: e?.title))
              .toList();
          textControllers = responseList
              .map((e) => TextEditingController(text: e?.summary))
              .toList();
        } else if (state is ErrorsummaryState) {
          // ignore: avoid_print
          ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('حصل خطأ ما أعد المحاولة ')),
              );
        } else if (state is LoadingState) {
          return const SafeArea(
            child: Scaffold(
              body: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
    return Scaffold(
      appBar: AppBar(
        title: Text('الملخص'),
        actions: [
        IconButton(icon: Icon(Icons.picture_as_pdf_outlined), onPressed: () {
          _showInputDialog();
        })
      ],),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: SvgPicture.asset(
                "assets/images/summary.svg",
              ),
            ),
            Expanded(
                flex: 2,
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
                              decoration: InputDecoration(labelText: 'ملخص الفقرة'),
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
            // Align(
            //     alignment: Alignment.centerRight,
            //     child: FilledButton(
            //       onPressed: () {},
            //       child: const Text(
            //         "Save",
            //       ),
            //     )),
          ],
        ),
      ),
    );
  });}
}
