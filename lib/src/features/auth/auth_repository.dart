import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/exceptions/app_exception.dart';
import 'package:alnabali_driver/src/network/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  String? _uid; // AuthRepository will not use data model.

  String? get uid => _uid;

  set setUid(String str) {
    _uid = str;
  }

  Future<bool> doLogIn(String username, String password) async {
    final data = await DioClient.postLogin(username, password);
    developer.log('doLogin() returned: $data');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("login_id", 'not');
    await prefs.setBool('isLogin', false);

    var result = data['result'];
    if (result == 'Login Successfully') {
      _uid = data['id'].toString();
      await prefs.setString("login_id", data['id'].toString());
      await prefs.setBool('isLogin', true);
      await prefs.setBool('dateType', data['date'].toString() == '1');
      return true;
    } else if (result == 'Invalid Driver') {
      throw const AppException.userNotFound();
    } else if (result == 'Invalid Password') {
      throw const AppException.wrongPassword();
    }

    return false;
  }

  Future<bool> doSendMobile(String phone) async {
    await Future.delayed(const Duration(seconds: 1));

    return true;
  }

  Future<bool> doVerifyOTP(String otp) async {
    await Future.delayed(const Duration(seconds: 1));

    return true;
  }

  Future<bool> doResetPwd(String newPwd) async {
    await Future.delayed(const Duration(seconds: 1));

    return true;
  }

  Future<void> doLogOut() async {
    _uid = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('login_id', 'not');
    prefs.setBool('isLogin', false);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
