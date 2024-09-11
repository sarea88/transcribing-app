import 'package:audio_transcription_app/bloc/questinos_bloc/question_bloc.dart';
import 'package:audio_transcription_app/bloc/questinos_bloc/question_event.dart';
import 'package:audio_transcription_app/bloc/questinos_bloc/question_state.dart';
import 'package:audio_transcription_app/modle/questionmcq.dart';
import 'package:audio_transcription_app/modle/questionblank.dart';
import 'package:audio_transcription_app/modle/questionwh.dart';
import 'package:audio_transcription_app/modle/textmodle.dart';
import 'package:audio_transcription_app/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class QuestionsGenerationScreen extends StatefulWidget {
  const QuestionsGenerationScreen({super.key, required this.topics});
  final List<textmodle> topics;

  @override
  _QuestionsGenerationScreenState createState() =>
      _QuestionsGenerationScreenState();
}

class _QuestionsGenerationScreenState extends State<QuestionsGenerationScreen> {
  String _selectedType = 'اختار الإجابة'; // default type
  List<dynamic> _questions = [];

  @override
  void initState() {
    super.initState();
    // _generateQuestions(_selectedType); // Generate initial questions
  }

  void _generateQuestions(String type) {
    setState(() {
      _questions.clear(); // Clear previous questions before generating new ones
    });

    if (type == 'اختار الإجابة') {
      BlocProvider.of<QuestionBloc>(context)
          .add(SendDataquestionmcqEvent(topics: widget.topics));
    } else if (type == 'فراغات') {
      BlocProvider.of<QuestionBloc>(context)
          .add(SendDataquestionblankEvent(topics: widget.topics));
    } else if (type == 'سردي') {
      BlocProvider.of<QuestionBloc>(context)
          .add(SendDataquestionwhEvent(topics: widget.topics));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionBloc, QuestionState>(
        builder: (BuildContext context, QuestionState state) {
      if (state is SuccessmcqState) {
        print('Successfully received data ${state.questionmcqresponse}');
        _questions = state.questionmcqresponse!;
      } else if (state is ErrorState) {
        print('errorstate');
      } else if (state is LoadingState) {
        return const SafeArea(
          child: Scaffold(
            body: Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
          ),
        );
      } else if (state is SuccessblankState) {
        print('Successfully received data ${state.questionblankresponse}');
        _questions = state.questionblankresponse!;
      } else if (state is SuccesswhState) {
        print('Successfully received data ${state.questionwhresponse}');
        _questions = state.questionwhresponse!;
      }
      return Scaffold(
        appBar: AppBar(
          title: Text(' الأسئلة'),
        ),
        body: Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            children: [
              Expanded(child: SvgPicture.asset("assets/images/question.svg")),
              DropdownButton<String>(
                borderRadius:const BorderRadius.all(Radius.circular(BorderSide.strokeAlignCenter)),
                value: _selectedType,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedType = newValue!;
                  });
                },
                items: <String>['فراغات', 'اختار الإجابة', 'سردي']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              ElevatedButton(
                  onPressed: () {
                    _generateQuestions(_selectedType); // Regenerate questions
                  },
                  child: Text('ابدء')),
              Expanded(
                flex: 2,
                child: ListView.builder(
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    final question = _questions[index];
                    if (question is questionmcq) {
                      return _buildMcqQuestion(question);
                    } else if (question is questionblank) {
                      return _buildBlankQuestion(question);
                    } else if (question is questionwh) {
                      return _buildNarrativeQuestion(question);
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMcqQuestion(questionmcq question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Text(
            question.question ?? "",
            textDirection: TextDirection.rtl,
            style: TextStyle(color: primaryColor),
          ),
        ),
        ...question.choices!.map((choice) {
          return Container(
            alignment: Alignment.centerRight, // Align text to the right
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: Text(
              choice,
              textDirection: TextDirection.rtl,
              style: TextStyle(color: seconderyColor),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildBlankQuestion(questionblank question) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Text(
        question.question ?? "",
        textDirection: TextDirection.rtl,
        style: TextStyle(color: primaryColor),
      ),
    );
  }

  Widget _buildNarrativeQuestion(questionwh question) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Text(
        question.question ?? "",
        textDirection: TextDirection.rtl,
        style: TextStyle(color: primaryColor),
      ),
    );
  }
}
