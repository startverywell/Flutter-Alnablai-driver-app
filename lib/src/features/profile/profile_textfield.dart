import 'package:alnabali_driver/src/features/profile/profile_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// text field types used in profile screen.
enum ProfileTextFieldType {
  name,
  phone,
  dateOfBirth,
  address,
  currPassword,
  newPassword,
  confirmPassword,
}

class ProfileTextField extends ConsumerStatefulWidget {
  const ProfileTextField({
    Key? key,
    required this.txtFieldType,
    required this.controller,
    this.onEditComplete,
  }) : super(key: key);

  final ProfileTextFieldType txtFieldType;
  final TextEditingController controller;
  final VoidCallback? onEditComplete;

  @override
  ConsumerState<ProfileTextField> createState() => _ProfileTextFieldState();
}

class _ProfileTextFieldState extends ConsumerState<ProfileTextField> {
  String _langCode = '';

  @override
  void initState() {
    super.initState();

    _langCode = ref.read(langCodeProvider);
  }

  @override
  Widget build(BuildContext context) {
    String guideText = '';
    String prefixText = '';
    double fieldH = 120.h;
    double fieldRadius = 100;
    bool isObscureText = false;
    TextInputType inputType = TextInputType.text;
    int? inputMaxLines = 1;
    TextInputAction inputAction = TextInputAction.next;
    List<TextInputFormatter> formatters = <TextInputFormatter>[
      FilteringTextInputFormatter.deny('\n')
    ];
    if (widget.txtFieldType == ProfileTextFieldType.name) {
      guideText = AppLocalizations.of(context).name;
      inputType = TextInputType.name;
    } else if (widget.txtFieldType == ProfileTextFieldType.phone) {
      guideText = AppLocalizations.of(context).phone;
      prefixText = '+962';
      inputType = TextInputType.phone;
      formatters.add(FilteringTextInputFormatter.digitsOnly);
    } else if (widget.txtFieldType == ProfileTextFieldType.dateOfBirth) {
      guideText = AppLocalizations.of(context).dateOfBirth;
      inputType = TextInputType.datetime;
      formatters.add(FilteringTextInputFormatter.digitsOnly);
    } else if (widget.txtFieldType == ProfileTextFieldType.address) {
      guideText = AppLocalizations.of(context).addr;
      inputType = TextInputType.multiline;
      inputMaxLines = null;
      inputAction = TextInputAction.done;
      fieldH = 280.h;
      fieldRadius = 28;
    } else if (widget.txtFieldType == ProfileTextFieldType.currPassword) {
      guideText = AppLocalizations.of(context).currentPwd;
      isObscureText = true;
      inputType = TextInputType.visiblePassword;
    } else if (widget.txtFieldType == ProfileTextFieldType.newPassword) {
      guideText = AppLocalizations.of(context).newPwd2;
      isObscureText = true;
      inputType = TextInputType.visiblePassword;
    } else if (widget.txtFieldType == ProfileTextFieldType.confirmPassword) {
      guideText = AppLocalizations.of(context).confirmNewPwd;
      isObscureText = true;
      inputType = TextInputType.visiblePassword;
      inputAction = TextInputAction.done;
    }

    final fieldW = 700.w;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 46.w, vertical: 10.h),
          child: Text(
            guideText,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 32.sp,
              color: kColorPrimaryBlue,
            ),
          ),
        ),
        Container(
          width: fieldW,
          height: fieldH,
          decoration: BoxDecoration(
            color: kColorPrimaryBlue,
            border: Border.all(color: kColorPrimaryBlue),
            borderRadius: BorderRadius.circular(fieldRadius),
          ),
          child: _langCode == 'en'
              ? Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Text(
                        prefixText,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 36.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: fieldH,
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 25.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(fieldRadius)),
                        ),
                        child: TextField(
                          controller: widget.controller,
                          onEditingComplete: widget.onEditComplete,
                          obscureText: isObscureText,
                          keyboardType: inputType,
                          maxLines: inputMaxLines,
                          textInputAction: inputAction,
                          inputFormatters: formatters,
                          cursorColor: kColorSecondaryGrey,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 36.sp,
                            color: kColorSecondaryGrey,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Text(
                        prefixText,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 36.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: fieldH,
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 25.h),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(100)),
                        ),
                        child: TextField(
                          controller: widget.controller,
                          onEditingComplete: widget.onEditComplete,
                          obscureText: isObscureText,
                          keyboardType: inputType,
                          textInputAction: inputAction,
                          inputFormatters: formatters,
                          cursorColor: kColorSecondaryGrey,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 36.sp,
                            color: kColorSecondaryGrey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
