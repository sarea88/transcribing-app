import 'package:audio_transcription_app/bloc/user_bloc/userbloc.dart';
import 'package:audio_transcription_app/bloc/user_bloc/userevent.dart';
import 'package:audio_transcription_app/bloc/user_bloc/userstate.dart';
import 'package:audio_transcription_app/modle/usermodle.dart';
// import 'package:audio_transcription_app/view/main_screen.dart';
import 'package:audio_transcription_app/view/singup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../ui/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late bool hidePassword;
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    hidePassword = true;
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? isLoggedIn = sharedPreferences.getBool('islog');
    if (isLoggedIn != null && isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is SuccessedlogInState) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SplashScreen()),
              );
            } else if (state is FailduloginState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('حصل خطأ ما أعد المحاولة ')),
              );
            }
          },
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is ProcessinglogInState) {
                return Center(child: CircularProgressIndicator());
              }
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Expanded(
                      child: SvgPicture.asset("assets/images/login.svg"),
                    ),
                    Expanded(
                      flex: 1,
                      child: Form(
                        key: key,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                controller: emailCtrl,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.email),
                                  label: Text("بريد إلكتروني"),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return "الرجاء إدخال البريد الإلكتروني";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: passwordCtrl,
                                obscureText: hidePassword,
                                decoration: InputDecoration(
                                  label: const Text("كلمة المرور"),
                                  prefixIcon:
                                      const Icon(Icons.lock_outline_rounded),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hidePassword = !hidePassword;
                                      });
                                    },
                                    icon: Icon(hidePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return "الرجاء إدخال كلمة المرور";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: OutlinedButton(
                                  onPressed: () {
                                    if (key.currentState!.validate()) {
                                      final user = loginreqmod(
                                          email: emailCtrl.text,
                                          password: passwordCtrl.text);
                                      BlocProvider.of<UserBloc>(context)
                                          .add(Loginevent(user: user));
                                    }
                                  },
                                  child: const Text("تسجيل دخول"),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "إنشاء حساب ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                    const Text("ليس لديك حساب؟"),
                                  ],
                                ),
                              ),
                              // Align(
                              // alignment: Alignment.bottomCenter,
                              // child :Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //   TextButton(
                              //     onPressed: () {
                              //       Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //           builder: (context) => MainScreen(),
                              //         ),
                              //       );
                              //     },
                              //     child: Text('ضيف'),
                              //   ),
                              //   const Text("يمكنك الدخول "),
                              // ]))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
