import 'package:flutter/material.dart';

import 'package:alnabali_driver/src/utils/string_validators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Mixin class to be used for client-side email & password validation
mixin EidtProfileValidators {
  final nonEmptyValidator = NonEmptyStringValidator();
  final phoneValidator = PhoneRegexValidator();
  final birthValidator = DateRegexValidator();

  String? usernameErrorText(String username, BuildContext context) {
    if (nonEmptyValidator.isValid(username)) {
      return null;
    }

    return AppLocalizations.of(context).usernameCantBeEmpty;
  }

  String? phoneErrorText(String phone, BuildContext context) {
    if (nonEmptyValidator.isValid(phone)) {
      //if (phoneValidator.isValid(phone)) {
      return null;
    }

    return AppLocalizations.of(context).phoneNumberIsNotValid;
  }

  String? birthErrorText(String birth, BuildContext context) {
    if (nonEmptyValidator.isValid(birth)) {
      //if (phoneValidator.isValid(birth)) {
      return null;
    }

    return birth.isEmpty
        ? AppLocalizations.of(context).dateOfBirthCantBe
        : AppLocalizations.of(context).dateOfBirthIsNotValid;
  }

  String? addressErrorText(String address, BuildContext context) {
    if (nonEmptyValidator.isValid(address)) {
      return null;
    }

    return AppLocalizations.of(context).addrCantBeEmpty;
  }
}
