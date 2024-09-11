import 'package:audio_transcription_app/bloc/user_bloc/userbloc.dart';
import 'package:audio_transcription_app/bloc/user_bloc/userstate.dart';
import 'package:audio_transcription_app/modle/usermodle.dart';
import 'package:audio_transcription_app/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_bloc/userevent.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late bool hidePassword;
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();
  // bool isMale = false;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    hidePassword = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
        builder: (BuildContext context, UserState state) {
      if (state is SuccessedregesturState) {
        print('Successfully received data ${state}');
        Future.delayed(Duration.zero, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        });
      } else if (state is FaildregesturState) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //         SnackBar(content: Text('حصل خطأ ما أعد المحاولة ')),
        //       );
      } else if (state is ProcessingregesturState) {
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
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const Expanded(
                  child: Column(
                children: [
                  Text(
                    "إنشاء حساب",
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(
                    "ادخل الحقول التالية",
                  ),
                ],
              )),
              Expanded(
                flex: 4,
                child: Form(
                  key: key,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(2),
                          child: TextFormField(
                            controller: nameCtrl,
                            decoration: const InputDecoration(
                              label: Text("الاسم الكامل"),
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "الرجاء إدخال الاسم";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(2),
                          child: TextFormField(
                            controller: phoneCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.singleLineFormatter,
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'\+?\d*')),
                            ],
                            decoration: const InputDecoration(
                              label: Text("رقم الهاتف"),
                              prefixIcon: Icon(Icons.phone),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "الرجاء إدخال رقم الهاتف";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(2),
                          child: TextFormField(
                            controller: emailCtrl,
                            decoration: const InputDecoration(
                              label: Text("البريد الإلكترني"),
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "الرجاء إدخال البريد الإلكتروني";
                              }
                              return null;
                            },
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(2),
                          child: TextFormField(
                            controller: passwordCtrl,
                            obscureText: hidePassword,
                            decoration: InputDecoration(
                                label: Text("كلمة المرور"),
                                prefixIcon: Icon(Icons.numbers_outlined),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hidePassword = !hidePassword;
                                      });
                                    },
                                    icon: Icon(hidePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility))),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "الرجاء إدخال كلمة المرور";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(2),
                          child: TextFormField(
                            controller: confirmPasswordCtrl,
                            obscureText: hidePassword,
                            decoration: InputDecoration(
                                label: Text("تأكيد كلمة المرور"),
                                prefixIcon: Icon(Icons.numbers_outlined),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hidePassword = !hidePassword;
                                      });
                                    },
                                    icon: Icon(hidePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility))),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "الرجاء تأكيد كلمة المرور";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: OutlinedButton(
                            onPressed: () {
                              final user = signupreqmod(
                                  email: emailCtrl.text,
                                  name: nameCtrl.text,
                                  phoneNumber: phoneCtrl.text,
                                  password: passwordCtrl.text,
                                  passwordConfirmation:
                                      confirmPasswordCtrl.text);

                              BlocProvider.of<UserBloc>(context)
                                  .add(regesturevent(user: user));

                              setState(() {
                                if (emailCtrl.text.trim().isEmpty ||
                                    nameCtrl.text.trim().isEmpty ||
                                    phoneCtrl.text.trim().isEmpty ||
                                    passwordCtrl.text.trim().isEmpty ||
                                    confirmPasswordCtrl.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('ادخل جميع الحقول ')));
                                } else if (passwordCtrl.text !=
                                    confirmPasswordCtrl.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'تأكد من تطابق كلمة المرور و تأكيدها')));
                                }
                              });
                            },
                            child: const Text(
                              "إنشاء حساب",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
