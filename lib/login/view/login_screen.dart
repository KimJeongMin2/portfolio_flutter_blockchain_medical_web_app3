import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:portfolio_flutter_blockchain_medical_web_app/database/drift_database.dart';
import 'package:portfolio_flutter_blockchain_medical_web_app/home/view/doctor_root_tab.dart';
import 'package:portfolio_flutter_blockchain_medical_web_app/home/view/root_tab.dart';
import 'package:portfolio_flutter_blockchain_medical_web_app/login/view/doctor_signup_screen.dart';
import 'package:portfolio_flutter_blockchain_medical_web_app/login/view/patient_signup_screen.dart';
import '../../colors.dart';
import '../../data.dart';
import '../../home/layout/default_layout.dart';
import '../../main.dart';
import '../component/custom_text_form.field.dart';
import 'package:http/http.dart' as http;

import '../model/user_info.dart';
final userInfoProvider = ChangeNotifierProvider((ref) => UserInfo());

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends ConsumerState<LoginScreen> {
  String username = '';
  String password = '';
  bool isMobile = true;


  Future<bool> doctorLogin() async {
    final url = Uri.parse('http://$webIp/api/v1/sign-in');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': username, 'pw': password}),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['result'] == 'success') {
        print('의료진 로그인 성공!');
        ref.read(userInfoProvider).setUserId(username);
        return true;
      } else {
        print('의료진 로그인 실패..');
        return false;
      }
    } else {
      print('서버 오류로 인한 로그인 실패..');
      return false;
    }
  }

  Future<bool> patientLogin() async {
    final url = Uri.parse('http://$realPhoneIp/api/v1/sign-in');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': username, 'pw': password}),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['result'] == 'success') {
        print('환자 로그인 성공!');
        ref.read(userInfoProvider).setUserId(username);
        return true;
      } else {
        print('환자 로그인 실패..');
        return false;
      }
    } else {
      print('서버 오류로 인한 로그인 실패..');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Title(),
                const SizedBox(height: 16.0),
                const _SubTitle(),
                Image.asset(
                  'asset/img/logo/mainLogo.png',
                  width: MediaQuery.of(context).size.width / 3 * 2,
                ),
                CustomTextFormField(
                  hintText: '아이디를 입력해주세요.',
                  onChanged: (String value) {
                    username = value;
                  },
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요.',
                  onChanged: (String value) {
                    password = value;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (Platform.isAndroid) {
                      bool patientSuccess = await patientLogin();
                      if(patientSuccess) {
                        final patient = await GetIt.I<MyDatabase>()
                            .getPatientByUserIdAndPassword(username, password);
                        if (patient != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RootTab()),
                          );
                        }
                      }
                      else{
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("환자 로그인 실패"),
                              content: Text("아이디와 비밀번호를 확인해주세요."),
                              actions: [
                                TextButton(
                                  child: Text("확인"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                    else if(Platform.isWindows) {
                      bool doctorSuccess = await doctorLogin();
                      if(doctorSuccess) {
                        final doctor = await GetIt.I<MyDatabase>()
                            .getDoctorByUserIdAndPassword(username, password);
                        if (doctor != null) {
                          // 로그인 성공, 다른 화면으로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DoctorRootTab()),
                          );
                        }
                      }
                      else{
                        ScaffoldMessenger.of(context).showMaterialBanner(
                          MaterialBanner(
                            content: Text("아이디와 비밀번호를 확인해주세요."),
                            leading: Icon(Icons.error, color: Colors.red),
                            backgroundColor: Colors.yellow,
                            actions: <Widget>[
                              TextButton(
                                child: Text("확인"),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    }
                    else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("로그인 실패"),
                            content: Text("로그인에 실패하였습니다. 아이디와 비밀번호를 확인해주세요."),
                            actions: [
                              TextButton(
                                child: Text("확인"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: PRIMARY_COLOR,
                  ),
                  child: const Text(
                    '로그인',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    // 플랫폼 확인
                    if (Platform.isAndroid) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PatientSignupScreen()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DoctorSignupScreen()),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                  child: const Text(
                    '회원가입',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override




  Widget build(BuildContext context) {
    return const Text(
      '아이디와 비밀번호를 입력해서 로그인 해주세요!)',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
