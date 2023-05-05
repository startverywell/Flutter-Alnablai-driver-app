import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'app_exception.freezed.dart';

// flutter pub run build_runner build --delete-conflicting-outputs

@freezed
class AppException with _$AppException {
  // Auth
  //const factory AppException.emailAlreadyInUse() = EmailAlreadyInUse;
  //const factory AppException.weakPassword() = WeakPassword;
  const factory AppException.wrongPassword() = WrongPassword;
  const factory AppException.userNotFound() = UserNotFound;

  // Orders
  //const factory AppException.parseOrderFailure(String status) =
  //    ParseOrderFailure;
}

class AppExceptionData {
  AppExceptionData(this.code, this.message);
  final String code;
  final String message;

  @override
  String toString() => 'AppExceptionData(code: $code, message: $message)';
}

extension AppExceptionDetails on AppException {
  AppExceptionData getDetails(BuildContext context) {
    return when(
      // Auth
      // emailAlreadyInUse: () => AppExceptionData(
      //   'email-already-in-use',
      //   'Email already in use'.hardcoded,
      // ),
      // weakPassword: () => AppExceptionData(
      //   'weak-password',
      //   'Password is too weak'.hardcoded,
      // ),
      wrongPassword: () => AppExceptionData(
        'wrong-password',
        AppLocalizations.of(context).wrongPwd,
      ),
      userNotFound: () => AppExceptionData(
        'user-not-found',
        AppLocalizations.of(context).userNotFound,
      ),
    );
  }
}
